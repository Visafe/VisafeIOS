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

// MARK: - DnsTrackers
struct DnsTrackers: Codable {
    let timeUpdated: String
    let categories: [String: String]
    let trackers: [String: Tracker]
    let trackerDomains: [String: String]
}

// MARK: - Tracker
struct Tracker: Codable {
    let name: String
    let categoryId: Int
    let url: String?
}

@objc protocol DnsTrackerServiceProtocol {
    func getTrackerInfo(by domain: String) -> DnsTrackerInfo?
}

@objc class DnsTrackerInfo: NSObject {
    let categoryKey: String?
    let categoryId: Int
    let name: String?
    let url: String?
    let isVisafeJson: Bool
    
    init(categoryKey: String?, categoryId: Int, name: String?, url: String?, isVisafeJson: Bool) {
        self.categoryKey = categoryKey
        self.categoryId = categoryId
        self.name = name
        self.url = url
        self.isVisafeJson = isVisafeJson
    }
}

@objc class DnsTrackerService: NSObject, DnsTrackerServiceProtocol {
    
    private var whotracksmeTrackers: DnsTrackers?
    private var VisafeTrackers: DnsTrackers?
    
    override init() {
        super.init()
        initializeDnsTrackers()
    }
    
    func getTrackerInfo(by domain: String) -> DnsTrackerInfo? {
        
        if let trackers = VisafeTrackers, let info = getTrackerInfo(by: domain, dnsTrackers: trackers, isVisafeJson: true) {
            return info
        }
        
        if let trackers = whotracksmeTrackers, let info = getTrackerInfo(by: domain, dnsTrackers: trackers, isVisafeJson: false) {
            return info
        }
        
        return nil
    }
    
    // MARK: - Initialization of dns trackers object
    
    private func getTrackerInfo(by domain: String, dnsTrackers: DnsTrackers, isVisafeJson: Bool) -> DnsTrackerInfo? {
        let trackerDomains = dnsTrackers.trackerDomains
        
        var cuttedDomain = domain
        var domainKey: String?
        while cuttedDomain.count > 0 {
            domainKey = trackerDomains[cuttedDomain]
            if domainKey != nil { break }
            
            let splitted = cuttedDomain.split(separator: ".", maxSplits: 1)
            if splitted.count != 2 { break }
            
            cuttedDomain = String(splitted.last!)
        }
        
        if domainKey == nil { return nil }
        
        let trackers = dnsTrackers.trackers
        guard let info = trackers[domainKey!] else { return nil }
        
        let categories = dnsTrackers.categories
        
        let categoryId = info.categoryId
        guard let categoryKey = categories[String(categoryId)] else { return nil }
        
        return DnsTrackerInfo(categoryKey: categoryKey, categoryId: categoryId, name: info.name, url: info.url, isVisafeJson: isVisafeJson)
    }
    
    private func initializeDnsTrackers(){
        /**
         This file is downloaded from https://github.com/VisafeTeam/VisafeHome/tree/master/client/src/helpers/trackers
         */
        guard let whotracksmePath = Bundle.main.path(forResource: "whotracksme", ofType: "json"),
                let VisafePath = Bundle.main.path(forResource: "Visafe", ofType: "json")
            else { return }
        do {
            let whotracksmeData = try Data(contentsOf: URL(fileURLWithPath: whotracksmePath), options: .mappedIfSafe)
            try decodeWhotraksmeTrackers(data: whotracksmeData)
            
            let VisafeData = try Data(contentsOf: URL(fileURLWithPath: VisafePath), options: .mappedIfSafe)
            try decodeVisafeTrackers(data: VisafeData)
        } catch {
            assertionFailure("Failed to decode whotracksme.json \(error)")
            DDLogError("Failed to decode whotracksme.json \(error)")
        }
    }
    
    func decodeWhotraksmeTrackers(data: Data) throws {
        whotracksmeTrackers = try JSONDecoder().decode(DnsTrackers.self, from: data)
    }
    
    func decodeVisafeTrackers(data: Data) throws {
        VisafeTrackers = try JSONDecoder().decode(DnsTrackers.self, from: data)
    }
}
