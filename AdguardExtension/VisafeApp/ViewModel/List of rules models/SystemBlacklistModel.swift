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

class SystemBlacklistModel: ListOfRulesModelProtocol {
    
    private let filterRulesAction = "dns_filter_rules"
    private let openUrlFrom = "dns_user_filter"
    
    // MARK: - Variables
    
    /* State of model */
    var state: ControllerState = .normal {
        didSet {
            allRules.forEach({ $0.attributedString = nil })
            if state == .searching {
                searchRules = allRules
            }
        }
    }
    
    var delegate: ListOfRulesModelDelegate?
    
    var rules: [RuleInfo] {
        get {
            return (state == .searching) ? searchRules : allRules
        }
    }
    
    var type: RulesType = .systemBlacklist
    
    var enabled: Bool {
        get {
            return resources.systemUserFilterEnabled
        }
        set{
            if enabled != newValue {
                resources.systemUserFilterEnabled = newValue
                vpnManager.updateSettings(completion: nil)
            }
        }
    }
    
    var searchString: String? {
        didSet {
            searchRule()
        }
    }
    
    // MARK: - Titles
    
    var title: String {
        get {
            return ACLocalizedString("dns_blacklist_title", nil)
        }
    }
    
    var leftButtonTitle: String {
        get {
            return ACLocalizedString("common_delete", nil)
        }
    }
    
    var middleButtonTitle: String {
        get {
            return ACLocalizedString("common_select_all", nil)
        }
    }
    
    var helperLabelText: String {
        get {
            return ""
        }
    }
    
    var descriptionTitle: String {
        get {
            let format = ACLocalizedString("dns_blacklist_text_format", nil)
            let url = UIApplication.shared.VisafeUrl(action: filterRulesAction, from: openUrlFrom, buildVersion: productInfo.buildVersion())
            return String(format: format, url)
        }
    }
    
    // MARK: - Private variables
    
    /* Services */
    private var dnsFiltersService: DnsFiltersServiceProtocol
    private let resources: AESharedResourcesProtocol
    private let theme: ThemeServiceProtocol
    private let fileShare: FileShareServiceProtocol = FileShareService()
    private let vpnManager: VpnManagerProtocol
    private let productInfo: ADProductInfoProtocol
    
    /* Variables */
    private let fileName = "dns_blocklist.txt"
    
    private var allRules = [RuleInfo]()
    private var searchRules = [RuleInfo]()
    
    // MARK: - Initializer
    
    init(resources: AESharedResourcesProtocol, dnsFiltersService: DnsFiltersServiceProtocol, theme: ThemeServiceProtocol, vpnManager: VpnManagerProtocol, productInfo: ADProductInfoProtocol) {
        self.resources = resources
        self.dnsFiltersService = dnsFiltersService
        self.theme = theme
        self.vpnManager = vpnManager
        self.productInfo = productInfo
        
        // Needs to be changed
        // dnsFiltersService must store rules as [RuleInfo] because we need to know their state
        // for now it is always initialized with true
        allRules = dnsFiltersService.userRules.map { RuleInfo($0, false, true, theme) }
    }
    
    // MARK: - Main functions
    
    func exportList(parentController: UIViewController, sourceView: UIView, sourceRect: CGRect) {
        fileShare.exportFile(parentController: parentController, sourceView: sourceView, sourceRect: sourceRect, filename: fileName, text: plainText()) { (message) in
        }
    }
    
    func importList(parentController: UIViewController) {
        fileShare.importFile(parentController: parentController) { [weak self] (text, errorMessage) in
            guard let strongSelf = self else { return }
            if errorMessage != nil {
                ACSSystemUtils.showSimpleAlert(for: parentController, withTitle: nil, message: errorMessage)
            }
            else {
                strongSelf.importRules(text) { errorMessage in
                    ACSSystemUtils.showSimpleAlert(for: parentController, withTitle: nil, message: errorMessage)
                }
            }
        }
    }
    
    func addRule(ruleText: String, errorHandler: @escaping (String) -> Void, completionHandler: @escaping () -> Void) {
        if ruleText.count == 0 { return }
        
        let components = ruleText.components(separatedBy: .newlines)
        
        var rules: [String] = []
        
        for component in components {
            let trimmed = component.trimmingCharacters(in: .whitespaces)
            if trimmed.count > 0 {
                rules.append(trimmed)
            }
        }
        
        if rules.count == 0 {
            return
        }
        
        rules.forEach({ dnsFiltersService.addBlacklistRule($0) })
        
        allRules.append(contentsOf: rules.map { RuleInfo($0, false, true, theme) })
        
        delegate?.listOfRulesChanged()
    }
    
    func selectAllRules() {
        allRules.forEach({ $0.selected = true })
    }
    
    func deleteSelectedRules(completionHandler: @escaping (_ rulesWereDeleted: Bool) -> Void, errorHandler: @escaping (String) -> Void) {
        var newRules = [RuleInfo]()
        var rulesWereDeleted = false
        for rule in allRules {
            if !rule.selected {
                newRules.append(rule)
            } else {
                rulesWereDeleted = true
            }
        }
        completionHandler(rulesWereDeleted)
        allRules = newRules
        dnsFiltersService.userRules = allRules.map({ $0.rule })
        
        delegate?.listOfRulesChanged()
    }
    
    func delete(rule: RuleInfo, errorHandler: @escaping (String) -> Void, completionHandler: @escaping () -> Void) {
        
        guard let index = allRules.firstIndex(of: rule) else { return }
        if let indexWhileSearching = searchRules.firstIndex(of: rule){
            searchRules.remove(at: indexWhileSearching)
        }
        
        allRules.remove(at: index)
        dnsFiltersService.userRules = allRules.map { $0.rule }
        
        delegate?.listOfRulesChanged()
        completionHandler()
    }
    
    func changeRule(rule: RuleInfo, newText: String, errorHandler: @escaping (String) -> Void, completionHandler: @escaping () -> Void) {
        
        guard let index = allRules.firstIndex(of: rule) else {
            DDLogError("(UserFilterViewModel) change rule failed - rule not found")
            return
        }
        
        allRules[index].rule = newText
        dnsFiltersService.userRules = allRules.map { $0.rule }
        
        completionHandler()
        delegate?.listOfRulesChanged()
    }
    
    func processRulesFromString(_ string: String, errorHandler: @escaping (String) -> Void) {
        // Unrealized method
    }
    
    // MARK: - Private methods
        
    /**
     retuns all rules from list of rules as a plain text
     */
    func plainText() -> String {
        return allRules.map({ $0.rule }).joined(separator: "\n")
    }
    
    /**
     parse plain text to array of rules. Save it to list of rules and reload safari content blockers
    */
    private func importRules(_ plainText: String, errorHandler: @escaping (_ error: String)->Void) {
        
        let ruleStrings = plainText.components(separatedBy: .newlines)
        
        var newRules = [String]()
        
        for ruleString in ruleStrings {
            
            let trimmedRuleString = ruleString.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedRuleString.count == 0 {
                continue
            }
            
            newRules.append(trimmedRuleString)
        }
        
        dnsFiltersService.userRules = newRules
        allRules = newRules.map { RuleInfo($0, false, true, theme) }
        
        delegate?.listOfRulesChanged()
    }
    
    private func searchRule(){
        searchRules = []
        allRules.forEach({ $0.attributedString = nil })
        
        if searchString == nil || (searchString?.isEmpty ?? true) {
            searchRules = allRules
            delegate?.listOfRulesChanged()
            return
        }
        
        guard let components = searchString?.lowercased().split(separator: " ") else { return }
        let searchStrings = components.map({ String($0) })
        
        for rule in allRules {
            if checkRule(rule: rule, components: components) {
                rule.attributedString = rule.rule.highlight(search: searchStrings)
                searchRules.append(rule)
            }
        }
        
        delegate?.listOfRulesChanged()
    }
    
    private func checkRule(rule: RuleInfo, components: [Substring]) -> Bool {
        let name = rule.rule
        for component in components {
            let range = name.range(of: component, options: .caseInsensitive)
            if range != nil {
                return true
            }
        }
        return false
    }
}
