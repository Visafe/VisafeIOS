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

// MARK: - data types -
@objc enum DnsProtocol: Int, Codable, CaseIterable {
    case dns = 0
    case dnsCrypt
    case doh
    case dot
    case doq
    
    static var allCases: [DnsProtocol] = [DnsProtocol.dns, .dnsCrypt, .doh, .dot, .doq]
    
    init(type: DnsType) {
        switch (type) {
        case .dns:
            self = .dns
        case .dnscrypt:
            self = .dnsCrypt
        case .doh:
            self = .doh
        case .dot:
            self = .dot
        case .doq:
            self = .doq
        }
    }
    
    init(dnslibProto: AGStampProtoType) {
        switch dnslibProto {
        case .AGSPT_PLAIN: self = .dns
        case .AGSPT_DOH: self = .doh
        case .AGSPT_TLS: self = .dot
        case .AGSPT_DNSCRYPT: self = .dnsCrypt
        case .AGSPT_DOQ: self = .doq
        @unknown default: self = .dns
        }
    }
    
    static let protocolByString: [String: DnsProtocol] = [ "dns": .dns,
                                                           "dnscrypt": .dnsCrypt,
                                                           "doh": .doh,
                                                           "dot": .dot,
                                                           "doq": .doq]
    
    static let stringIdByProtocol: [DnsProtocol: String] = [.dns: "regular_dns_protocol",
                                                            .dnsCrypt: "dns_crypt_protocol",
                                                            .doh: "doh_protocol",
                                                            .dot: "dot_protocol",
                                                            .doq: "doq_protocol"]
    
    static let prefixByProtocol: [DnsProtocol: String] = [.dnsCrypt: "sdns://",
                                                          .doh: "https://",
                                                          .dot: "tls://",
                                                          .doq: "quic://"]
    
    static func getProtocolByUpstream(_ upstream: String) -> DnsProtocol {
        if let dohPrefix = DnsProtocol.prefixByProtocol[.doh], upstream.hasPrefix(dohPrefix) {
            return .doh
        }
        
        if let dotPrefix = DnsProtocol.prefixByProtocol[.dot], upstream.hasPrefix(dotPrefix) {
            return .dot
        }
        
        if let dnsCryptPrefix = DnsProtocol.prefixByProtocol[.dnsCrypt], upstream.hasPrefix(dnsCryptPrefix) {
            return .dnsCrypt
        }
        
        if let doqPrefix = DnsProtocol.prefixByProtocol[.doq], upstream.hasPrefix(doqPrefix) {
            return .doq
        }
        
        return .dns
    }
}

struct DnsProviderFeature {
    var name: String
    var title: String
    var summary: String
    var iconId: String
}

@objc(DnsServerInfo)
@objcMembers
class DnsServerInfo : ACObject, Codable {
    
    var dnsProtocol: DnsProtocol
    var serverId: String
    var providerId: Int?
    var name: String
    var upstreams: [String]
    var anycast: Bool?
    
    @objc static let VisafeDnsIds: Set<String> = ["Visafe-dns", "Visafe-doh", "Visafe-dot", "Visafe-dnscrypt"]
    @objc static let VisafeFamilyDnsIds: Set<String> = ["Visafe-dns-family", "Visafe-family-doh", "Visafe-family-dot", "Visafe-family-dnscrypt"]
    
    // MARK: - initializers and NSCoding methods
    
    init(dnsProtocol: DnsProtocol, serverId: String, name: String, upstreams: [String], providerId: Int?) {
        self.serverId = serverId
        self.dnsProtocol = dnsProtocol
        self.name = name
        self.upstreams = upstreams
        self.providerId = providerId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        serverId = aDecoder.decodeObject(forKey: "server_id") as! String
        name = aDecoder.decodeObject(forKey: "name") as! String
        upstreams = aDecoder.decodeObject(forKey: "upstreams") as! [String]
        dnsProtocol = DnsProtocol(rawValue: aDecoder.decodeInteger(forKey: "dns_protocol")) ?? .dns
        providerId = aDecoder.decodeObject(forKey: "providerId") as? Int
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
        aCoder.encode(serverId, forKey: "server_id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(upstreams, forKey: "upstreams")
        aCoder.encode(dnsProtocol.rawValue, forKey: "dns_protocol")
        aCoder.encode(providerId, forKey: "providerId")
    }
}

@objc(DnsProviderInfo)
@objcMembers class DnsProviderInfo : ACObject {
    var name: String
    var logo: String?
    var logoDark: String?
    var summary: String?
    var protocols: [DnsProtocol]?
    var features: [DnsProviderFeature]?
    var website: String?
    var providerId: Int
    var isCustomProvider: Bool { providerId <= DnsProvidersService.customProviderIdUpperRange }
    @objc var servers: [DnsServerInfo]?
    
    // MARK: - initializers and NSCoding methods
    
    init(name: String, logo: String?, logoDark: String?, summary: String?, protocols: [DnsProtocol]?, features: [DnsProviderFeature]?, website: String?, servers: [DnsServerInfo]?, providerId: Int) {
        self.name = name
        self.logo = logo
        self.logoDark = logoDark
        self.summary = summary
        self.protocols = protocols
        self.features = features
        self.website = website
        self.servers = servers
        self.providerId = providerId
        super.init()
    }
    
    init(name: String, providerId: Int) {
        self.name = name
        self.providerId = providerId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        providerId = aDecoder.decodeInteger(forKey: "providerId")
        servers = aDecoder.decodeObject(forKey: "servers") as? [DnsServerInfo]
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(name, forKey: "name")
        aCoder.encode(providerId, forKey: "providerId")
        aCoder.encode(servers, forKey: "servers")
    }
    
    func serverByProtocol(dnsProtocol: DnsProtocol) -> DnsServerInfo? {
        if servers == nil { return nil }
        for server in servers! {
            if server.dnsProtocol == dnsProtocol {
                return server
            }
        }
        
        /**
         If searching a server by protocol failed
         the method will just return the first protocol of this server
         */
        return servers?.first
    }
    
    func getActiveProtocol(_ resources: AESharedResourcesProtocol) -> DnsProtocol? {
        if let protocolRawValue = resources.dnsActiveProtocols[name]{
            return DnsProtocol(rawValue: protocolRawValue)
        }
        return nil
    }
    
    func setActiveProtocol(_ resources: AESharedResourcesProtocol, protcol: DnsProtocol?) {
        resources.dnsActiveProtocols[name] = protcol?.rawValue
    }
}
