/**
       This file is part of Visafe for iOS (https://github.com/VisafeTeam/VisafeForiOS).
       Copyright © Visafe Software Limited. All rights reserved.
 
       Visafe for iOS is free software: you can redistribute it and/or modify
       it under the terms of the GNU General Public License as published by
       the Free Software Foundation, either version 3 of the License, or
       (at your option) any later version.
 
       Visafe for iOS is distributed in the hope that it will be useful,
       but WITHOUT ANY WARRANTY; without even the implied warranty of
       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
       GNU General Public License for more details.
 
       You should have received a copy of the GNU General Public License
       along with Visafe for iOS.  If not, see <http://www.gnu.org/licenses/>.
 */

import Foundation

@objc class DnsProxyUpstream: NSObject {
    let upstream: String
    let isCrypto: Bool
    
    init(upstream: String, isCrypto: Bool) {
        self.upstream = upstream
        self.isCrypto = isCrypto
    }
}

@objc
protocol DnsProxyServiceProtocol : NSObjectProtocol {
    var upstreamsById: [Int: DnsProxyUpstream] { get }
    
    func start(upstreams: [String], bootstrapDns: [String], fallbacks: [String], serverName: String, filtersJson: String, userFilterId:Int, whitelistFilterId:Int, ipv6Available: Bool, blockingMode: AGBlockingMode, blockedResponseTtlSecs: Int, customBlockingIpv4: String?, customBlockingIpv6: String?, blockIpv6: Bool) -> Bool
    func stop(callback:@escaping ()->Void)
    func resolve(dnsRequest:Data, callback:  @escaping (_ dnsResponse: Data?)->Void);
}

class DnsProxyService : NSObject, DnsProxyServiceProtocol {
    var upstreamsById: [Int : DnsProxyUpstream] = [:]
    
    // set it to 2000 to make sure we will quickly fallback if needed
    private let timeout = 2000
    private let dnsRecordsWriter: DnsLogRecordsWriterProtocol
    private let resources: AESharedResourcesProtocol
    private let dnsProvidersService: DnsProvidersServiceProtocol
    
    private var nextUpstreamId: Int { upstreamsById.count }
    
    private let resolveQueue = DispatchQueue(label: "dns proxy resolve queue", attributes: [.concurrent])
    
    let events: AGDnsProxyEvents
    
    @objc
    init(logWriter: DnsLogRecordsWriterProtocol, resources: AESharedResourcesProtocol, dnsProvidersService: DnsProvidersServiceProtocol) {
        DDLogInfo("(DnsProxyService) initializing")
        dnsRecordsWriter = logWriter
        self.resources = resources
        self.dnsProvidersService = dnsProvidersService
        events = AGDnsProxyEvents()
        
        super.init()
        
        events.onRequestProcessed = { [weak self] (event) in
            if event != nil {
                self?.dnsRecordsWriter.handleEvent(event!)
            }
        }
    }
    
    var agproxy: AGDnsProxy?
    
    @objc func start(upstreams: [String], bootstrapDns: [String], fallbacks: [String], serverName: String, filtersJson: String, userFilterId:Int, whitelistFilterId:Int, ipv6Available: Bool, blockingMode: AGBlockingMode, blockedResponseTtlSecs: Int, customBlockingIpv4: String?, customBlockingIpv6: String?, blockIpv6: Bool) -> Bool {
        resolveQueue.sync(flags: .barrier) {
            return self.startInternal(upstreams: upstreams, bootstrapDns: bootstrapDns, fallbacks: fallbacks, serverName: serverName, filtersJson: filtersJson, userFilterId: userFilterId, whitelistFilterId: whitelistFilterId, ipv6Available: ipv6Available, blockingMode: blockingMode, blockedResponseTtlSecs: blockedResponseTtlSecs, customBlockingIpv4: customBlockingIpv4, customBlockingIpv6: customBlockingIpv6, blockIpv6: blockIpv6)
        }
    }
    
    @objc func stop(callback:@escaping ()->Void) {
        resolveQueue.sync(flags: .barrier) { [weak self] in
            DDLogInfo("(DnsProxyService) - stop")
            self?.agproxy = nil
            self?.upstreamsById.removeAll()
            
            DDLogInfo("(DnsProxyService) - stopped")
            self?.dnsRecordsWriter.flush()
            
            callback()
        }
    }
    
    @objc func resolve(dnsRequest: Data, callback: @escaping (Data?) -> Void) {
        resolveQueue.async { [weak self] in
            let reply = self?.agproxy?.handlePacket(dnsRequest)
            callback(reply)
        }
    }
    
    private func upstreamIsCrypto() -> Bool {
        if let activeDnsServer = dnsProvidersService.activeDnsServer {
            return activeDnsServer.dnsProtocol != .dns
        }
        return false
    }
    
    private func startInternal(upstreams: [String], bootstrapDns: [String], fallbacks: [String], serverName: String, filtersJson: String, userFilterId:Int, whitelistFilterId:Int, ipv6Available: Bool, blockingMode: AGBlockingMode, blockedResponseTtlSecs: Int, customBlockingIpv4: String?, customBlockingIpv6: String?, blockIpv6: Bool) -> Bool {
        
        let isCrypto = upstreamIsCrypto()
        let agUpstreams = upstreams.map {(upstream) -> AGDnsUpstream in
            let id = nextUpstreamId
            let dnsProxyUpstream = DnsProxyUpstream(upstream: upstream, isCrypto: isCrypto)
            upstreamsById[id] = dnsProxyUpstream
            
            return AGDnsUpstream(address: upstream, bootstrap: bootstrapDns, timeoutMs: timeout, serverIp: nil, id: id, outboundInterfaceName: nil)
        }
        
        /// If fallback is set to none than we set empty upstreams list
        let agFallbacks: [AGDnsUpstream]
        if fallbacks.first == "none" {
            agFallbacks = []
        } else {
            agFallbacks = fallbacks.map { (fallback) -> AGDnsUpstream in
                let id = nextUpstreamId
                let isCrypto = false
                let dnsProxyUpstream = DnsProxyUpstream(upstream: fallback, isCrypto: isCrypto)
                upstreamsById[id] = dnsProxyUpstream
                
                return AGDnsUpstream(address: fallback, bootstrap: bootstrapDns, timeoutMs: timeout, serverIp: nil, id: id, outboundInterfaceName: nil)
            }
        }
        
        let filterFiles = (try? JSONSerialization.jsonObject(with: filtersJson.data(using: .utf8)! , options: []) as? Array<[String:Any]>) ?? Array<Dictionary<String, Any>>()
        
        var filters = [Int:String]()
        
        var otherFilterIds = [Int]()
        
        for filter in filterFiles {
            
            let identifier = filter["id"] as! Int
            let path = filter["path"] as! String
            
            if identifier != userFilterId && identifier != whitelistFilterId {
                otherFilterIds.append(identifier)
            }
            
            let numId = identifier
            
            filters[numId] = path
        }
        
        dnsRecordsWriter.userFilterId = userFilterId as NSNumber?
        dnsRecordsWriter.whitelistFilterId = whitelistFilterId as NSNumber?
        dnsRecordsWriter.otherFilterIds = otherFilterIds as [NSNumber]
        
        /**
         Detect ipv6 addresses,
         If address contains ":", than it is ipv6 address
         We need to use system DNS in dns64Settings variable, that's why we iterate through fallbacks variable
         */
        let ipv6Addresses = fallbacks.filter({ $0.contains(":") })
        
        let ipv6Upstreams = ipv6Addresses.map { (address) -> AGDnsUpstream in
            let id = nextUpstreamId
            let isCrypto = false
            let dnsProxyUpstream = DnsProxyUpstream(upstream: address, isCrypto: isCrypto)
            upstreamsById[id] = dnsProxyUpstream
            
            return AGDnsUpstream(address: address, bootstrap: bootstrapDns, timeoutMs: timeout, serverIp: nil, id: id, outboundInterfaceName: nil)
        }
        
        let agFilters = filters.compactMap { AGDnsFilterParams(id: Int($0.key), data: $0.value, inMemory: false) }
        
        let dns64Settings = AGDns64Settings(upstreams: ipv6Upstreams, maxTries: 2, waitTimeMs: timeout)
        let defaultConfig = AGDnsProxyConfig.getDefault()!
        let config = AGDnsProxyConfig(upstreams: agUpstreams,
                                      fallbacks: agFallbacks,
                                      fallbackDomains: defaultConfig.fallbackDomains,
                                      detectSearchDomains: defaultConfig.detectSearchDomains,
                                      filters: agFilters,
                                      blockedResponseTtlSecs: blockedResponseTtlSecs,
                                      dns64Settings: dns64Settings,
                                      listeners: nil,
                                      outboundProxy: defaultConfig.outboundProxy,
                                      ipv6Available: ipv6Available,
                                      blockIpv6: blockIpv6,
                                      blockingMode: blockingMode,
                                      customBlockingIpv4: customBlockingIpv4,
                                      customBlockingIpv6: customBlockingIpv6,
                                      dnsCacheSize: 128,
                                      optimisticCache: false,
                                      enableDNSSECOK: false,
                                      enableRetransmissionHandling: true,
                                      helperPath: nil)

        var error: NSError?
        agproxy = AGDnsProxy(config: config, handler: events, error: &error)
        resources.tunnelErrorCode = error?.code
        if agproxy == nil && error != nil {
            DDLogError("(DnsProxyService) can not start dns proxy - \(error!)")
        }
        else if error != nil {
            DDLogInfo("(DnsProxyService) dns proxy started with error - \(error!)")
        }
        
        return agproxy != nil
    }
}
