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

protocol NetworkSettingsModelProtocol {
    /* Variables */
    var exceptions: [WifiException] { get }
    var delegate: NetworkSettingsChangedDelegate? { get set }
    var filterWifiDataEnabled: Bool { get set }
    var filterMobileDataEnabled: Bool { get set }
    
    /* Methods */
    func addException(rule: String)
    func delete(rule: String)
    func change(rule: String, newRule: String)
    func change(rule: String, newEnabled: Bool)
    
}

class NetworkSettingsModel: NetworkSettingsModelProtocol {
    
    var filterWifiDataEnabled: Bool {
        get {
            return networkSettingsService.filterWifiDataEnabled
        }
        set {
            networkSettingsService.filterWifiDataEnabled = newValue
        }
    }
    
    var filterMobileDataEnabled: Bool {
        get {
            return networkSettingsService.filterMobileDataEnabled
        }
        set {
            networkSettingsService.filterMobileDataEnabled = newValue
        }
    }
    
    var delegate: NetworkSettingsChangedDelegate? {
        didSet{
            networkSettingsService.delegate = delegate
        }
    }
    
    var exceptions: [WifiException] {
        get {
            networkSettingsService.exceptions
        }
    }
    
    // MARK: - Private variables
    
    private var networkSettingsService: NetworkSettingsServiceProtocol
    
    init(networkSettingsService: NetworkSettingsServiceProtocol) {
        self.networkSettingsService = networkSettingsService
    }
    
    // MARK: - Global methods
    
    func addException(rule: String) {
        let exception = WifiException(rule: rule, enabled: true)
        networkSettingsService.add(exception: exception)
    }
    
    func delete(rule: String) {
        for exception in exceptions {
            if exception.rule == rule {
                networkSettingsService.delete(exception: exception)
            }
        }
    }
    
    func change(rule: String, newRule: String) {
        for exception in exceptions {
            if exception.rule == rule {
                let newException = WifiException(rule: newRule, enabled: exception.enabled)
                networkSettingsService.change(oldException: exception, newException: newException)
            }
        }
    }
    
    func change(rule: String, newEnabled: Bool) {
        for exception in exceptions {
            if exception.rule == rule {
                let newException = WifiException(rule: exception.rule, enabled: newEnabled)
                networkSettingsService.change(oldException: exception, newException: newException)
            }
        }
    }
    
    // MARK: - Private methods

}
