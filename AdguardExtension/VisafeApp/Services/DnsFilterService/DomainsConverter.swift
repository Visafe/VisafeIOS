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

protocol DomainsConverterProtocol {
    // converts whitelist rule to domain
    func whitelistDomainFromRule(_ rule: String) -> String
    
    // converts whitelist domain to rule
    func whitelistRuleFromDomain(_ domain:String) -> String
    
    // converts blacklist domain to rule
    func blacklistRuleFromDomain(_ domain: String) -> String
}

class DomainsConverter: DomainsConverterProtocol {
    
    private let whitelistPrefix = "@@||"
    private let whitelistSuffix = "^|$important"
    
    private let blacklistPrefix = "||"
    private let blacklistSuffix = "^$important"
    
    func whitelistDomainFromRule(_ rule: String)->String {
        let start = rule.hasPrefix(whitelistPrefix) ? whitelistPrefix.count : 0
        let end = rule.hasSuffix(whitelistSuffix) ? -whitelistSuffix.count : 0
        
        let startIndex = rule.index(rule.startIndex, offsetBy: start)
        let endIndex = end != 0 ? rule.index(rule.endIndex, offsetBy: end) : rule.endIndex
        
        let domain = rule[startIndex..<endIndex]
        return String(domain)
    }
    
    func blacklistRuleFromDomain(_ domain: String)->String {
        let trimmed = domain.hasSuffix(".") ? String(domain.dropLast()) : domain
        var rule = trimmed.hasPrefix(blacklistPrefix) ? trimmed : (blacklistPrefix + trimmed)
        rule = trimmed.hasSuffix(blacklistSuffix) ? rule : (rule + blacklistSuffix)
        return rule
    }
    
    func whitelistRuleFromDomain(_ domain:String)->String {
        var rule = domain.hasPrefix(whitelistPrefix) ? domain : (whitelistPrefix + domain)
        rule = domain.hasSuffix(whitelistSuffix) ? rule : (rule + whitelistSuffix)
        return rule
    }
}
