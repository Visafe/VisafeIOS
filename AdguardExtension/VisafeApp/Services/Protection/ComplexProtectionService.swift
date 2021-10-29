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
import NetworkExtension

// MARK: - Complex protection Interface -

@objc
protocol ComplexProtectionServiceProtocol: class {
    
    // Turns on/off complex protection
    func switchComplexProtection(state enabled: Bool, for VC: UIViewController?,  completion: @escaping (_ systemError: Error?)->Void)
    
    // Turns on/off safari protection
//     func switchSafariProtection(state enabled: Bool, for VC: UIViewController?, completion: @escaping (Error?)->Void)
    
    // Turns on/off tracking protection
    func switchSystemProtection(state enabled: Bool, for VC: UIViewController?, completion: @escaping (Error?)->Void)
    
//    var safariProtectionEnabled: Bool { get }
    var systemProtectionEnabled: Bool { get }
    var complexProtectionEnabled: Bool { get }
}

enum ComplexProtectionError: Error {
    case cancelledAddingVpnConfiguration
    case invalidDnsImplementation
}

// MARK: - Complex protection class -
class ComplexProtectionService: ComplexProtectionServiceProtocol{
    
    static let systemProtectionChangeNotification = Notification.Name(rawValue: "systemProtectionChangeNotification")
    
    var systemProtectionEnabled: Bool {
        if resources.dnsImplementation == .vpn {
            return proStatus
                && resources.systemProtectionEnabled
                && resources.complexProtectionEnabled
                && vpnManager.vpnInstalled
        } else {
            return nativeProvidersService.managerIsEnabled
        }
    }
    
    var complexProtectionEnabled: Bool {
        return resources.complexProtectionEnabled
    }
    
    private let resources: AESharedResourcesProtocol
    private let configuration: ConfigurationServiceProtocol
    private let vpnManager: VpnManagerProtocol
    private let productInfo: ADProductInfoProtocol
    private let nativeProvidersService: NativeProvidersServiceProtocol
    
    private var vpnConfigurationObserver: NotificationToken!
    private var vpnStateChangeObserver: NotificationToken!
    private var dnsImplementationObserver: NotificationToken!
    
    private var proStatus: Bool {
        return configuration.proStatus
    }

    init(resources: AESharedResourcesProtocol, configuration: ConfigurationServiceProtocol, vpnManager: VpnManagerProtocol,
         productInfo: ADProductInfoProtocol, nativeProvidersService: NativeProvidersServiceProtocol) {
        self.resources = resources
        self.configuration = configuration
        self.vpnManager = vpnManager
        self.productInfo = productInfo
        self.nativeProvidersService = nativeProvidersService
        
        nativeProvidersService.delegate = self
        
        addObservers()
        checkVpnInstalled()
        DDLogInfo("(ComplexProtectionService) - ComplexProtectionService was initialized")
    }
    
    func switchComplexProtection(state enabled: Bool, for VC: UIViewController?, completion: @escaping (_ systemError: Error?)->Void) {
        let complexEnabled = resources.complexProtectionEnabled
        let systemEnabled = resources.systemProtectionEnabled
        resources.complexProtectionEnabled = enabled
        
        DDLogInfo("(ComplexProtectionService) - complexProtection state: \(complexEnabled)")
        DDLogInfo("(ComplexProtectionService) - systemProtection state: \(systemEnabled)")
        DDLogInfo("(ComplexProtectionService) - switchComplexProtection to state: \(enabled)")
        
        if enabled && !systemEnabled {
            if resources.dnsImplementation == .vpn {
                resources.systemProtectionEnabled = proStatus
            }
        }
        
        if #available(iOS 14.0, *) {
            if resources.dnsImplementation == .native {
                if enabled {
                    nativeProvidersService.saveDnsManager { _ in }
                } else {
                    nativeProvidersService.removeDnsManager { _ in }
                }
            }
        }
        
        // We can't control native DNS configuration, we can only check it's state
        let shouldUpdateSystemProtection = resources.dnsImplementation == .vpn
        
        updateProtections(system: shouldUpdateSystemProtection, vc: VC) { [weak self] (systemError) in
            guard let self = self else { return }
            
            if systemError != nil {
                self.resources.systemProtectionEnabled = systemEnabled
            }
            
            completion(systemError)
        }
    }
    
//    func switchSafariProtection(state enabled: Bool, for VC: UIViewController?, completion: @escaping (Error?)->Void){
//        let needsUpdateSystemProtection = false
//        let needsUpdateSafari = true
//
//        let systemOld = resources.systemProtectionEnabled
//
//        DDLogInfo("(ComplexProtectionService) - complexProtection state: \(resources.complexProtectionEnabled)")
//        DDLogInfo("(ComplexProtectionService) - systemProtection state: \(systemOld)")
//        DDLogInfo("(ComplexProtectionService) - switchSafariProtection to state: \(enabled)")
//
//        if enabled && !resources.complexProtectionEnabled {
//            resources.complexProtectionEnabled = true
//
//            if resources.systemProtectionEnabled {
//                resources.systemProtectionEnabled = false
//            }
//        }
//
//        if !enabled && !systemProtectionEnabled {
//            resources.complexProtectionEnabled = false
//        }
//
//        updateProtections(system: needsUpdateSystemProtection, vc: VC) { [weak self] (systemError) in
//            guard let self = self else { return }
//            if systemError != nil {
//                self.resources.systemProtectionEnabled = systemOld
//            }
//
//            completion(systemError)
//        }
//    }
    
    func switchSystemProtection(state enabled: Bool, for VC: UIViewController?, completion: @escaping (Error?)->Void) {
        switchSystemProtectionInternal(state: enabled, for: VC, completion: completion)
    }
    
    // MARK: - Private methods
    
    private func switchSystemProtectionInternal(state enabled: Bool, for VC: UIViewController?, completion: @escaping (Error?)->Void) {
        let systemOld = resources.systemProtectionEnabled
        
        let needsUpdate = updateSystemProtectionResources(toEnabledState: enabled)
        
        updateProtections(system: needsUpdate.needsUpdateSystem, vc: VC) { [weak self] (systemError) in
            guard let self = self else { return }
            if systemError != nil {
                self.resources.systemProtectionEnabled = systemOld
            }
            
            completion(systemError)
        }
    }
    
    private func updateProtections(system: Bool, vc: UIViewController?, completion: @escaping (_ systemError: Error?)->Void) {
        
        DispatchQueue(label: "complexA protection queue").async { [weak self] in
            guard let self = self else { return }
            var systemError: Error?
            
            let group = DispatchGroup()
            if system {
                DDLogInfo("(ComplexProtectionService) - Begining updating dns protection")
                group.enter()
                self.updateVpnSettings(vc: vc) { error in
                    systemError = error
                    DDLogInfo("(ComplexProtectionService) - Ending updating safari protection with error - \(error?.localizedDescription ?? "nil")")
                    group.leave()
                }
            }
            
            group.wait()
            
            completion(systemError)
        }
    }
    
    private func updateSystemProtectionResources(toEnabledState enabled: Bool) -> (needsUpdateSafari: Bool, needsUpdateSystem: Bool){
        let needsUpdateSafari = false
        let needsUpdateSystem = true
        
        DDLogInfo("(ComplexProtectionService) - complexProtection state: \(resources.complexProtectionEnabled)")
        DDLogInfo("(ComplexProtectionService) - systemProtection state: \(resources.systemProtectionEnabled)")
        DDLogInfo("(ComplexProtectionService) - switchSystemProtection to state: \(enabled)")
        
        if enabled && !resources.complexProtectionEnabled {
            resources.complexProtectionEnabled = true
        }
        
        if !enabled {
            self.resources.complexProtectionEnabled = false
        }
        
        resources.systemProtectionEnabled = enabled
        
        return (needsUpdateSafari, needsUpdateSystem)
    }

    private func updateVpnSettings(vc: UIViewController?, completion: @escaping (Error?)->Void) {
        if !proStatus {
            DDLogInfo("(ComplexProtectionService) Failed \(#function) with reason: proStatus - \(proStatus)")
            completion(nil)
            return
        }
        
        if !vpnManager.vpnInstalled && resources.systemProtectionEnabled && vc != nil {
            
            #if !APP_EXTENSION
            self.showConfirmVpnAlert(for: vc!) { [weak self] (confirmed) in
                guard let self = self else { return }
                
                if !confirmed {
                    self.resources.systemProtectionEnabled = false
                    completion(ComplexProtectionError.cancelledAddingVpnConfiguration)
                    return
                }
                
                self.vpnManager.installVpnConfiguration(completion: completion)
            }
            #endif
        }
        else {
            vpnManager.updateSettings { (error) in
                if error as? VpnManagerError == VpnManagerError.managerNotInstalled {
                    completion(nil)
                }
                else {
                    completion(error)
                }
            }
        }
    }
    
    private func addObservers() {
        vpnConfigurationObserver = NotificationCenter.default.observe(name: VpnManager.configurationRemovedNotification, object: nil, queue: nil) { [weak self] (note) in
            DDLogInfo("(ComplexProtectionService) configurationRemovedNotification called")
            guard let self = self else { return }
            self.resources.systemProtectionEnabled = false
            NotificationCenter.default.post(name: ComplexProtectionService.systemProtectionChangeNotification, object: self)
        }
        
        vpnStateChangeObserver = NotificationCenter.default.observe(name: VpnManager.stateChangedNotification, object: nil, queue: nil) { [weak self] (note) in
            DDLogInfo("(ComplexProtectionService) stateChangedNotification called")
            guard let self = self else { return }
            if let enabled = note.object as? Bool {
                self.resources.systemProtectionEnabled = enabled
                // if safariProtection is disabled we must update complex protection state
//                if !self.safariProtectionEnabled {
                    self.resources.complexProtectionEnabled = enabled
//                }
            }
            
            NotificationCenter.default.post(name: ComplexProtectionService.systemProtectionChangeNotification, object: self)
        }
        
        dnsImplementationObserver = NotificationCenter.default.observe(name: .dnsImplementationChanged, object: nil, queue: nil) { [weak self] _ in
            DDLogInfo("(ComplexProtectionService) dnsImplementationChanged called")
            guard let self = self else { return }
        
            if self.resources.dnsImplementation == .vpn {
                self.checkVpnInstalled()
            } else {
                self.switchSystemProtectionInternal(state: false, for: nil) { [weak self] error in
                    guard let self = self else { return }
                
                    if let error = error {
                        DDLogError("Failed to turn off system protection, error: \(error.localizedDescription)")
                    }
                
                    let managerIsEnabled = self.nativeProvidersService.managerIsEnabled
                    let _ = self.updateSystemProtectionResources(toEnabledState: managerIsEnabled)
                    NotificationCenter.default.post(name: ComplexProtectionService.systemProtectionChangeNotification, object: self)
                }
            }
        }
    }
    
    private func checkVpnInstalled() {
        vpnManager.checkVpnInstalled { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                DDLogError("(ComplexProtectionService) checkVpnInstalled error: \(error!)")
            }
            else {
                if !self.vpnManager.vpnInstalled {
                    self.resources.systemProtectionEnabled = false
                    NotificationCenter.default.post(name: ComplexProtectionService.systemProtectionChangeNotification, object: self)
                }
            }
        }
    }
    
#if !APP_EXTENSION
    private func showConfirmVpnAlert(for vc: UIViewController, confirmed: @escaping (Bool)->Void){
        
        DispatchQueue.main.async {
            let title: String = "Kết nối VPN"
            let message: String = "Bạn có đồng ý Visafe sẽ thiết lập một kết nối VPN để bảo vệ thiết bị của bạn?"
            let okTitle: String = "Đồng ý"
            let cancelTitle: String = "Hủy bỏ"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: okTitle, style: .default) {(alert) in
                confirmed(true)
            }
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (alert) in
                confirmed(false)
            }
            alert.addAction(cancelAction)
            alert.addAction(okAction)

            
            alert.preferredAction = okAction
            
            vc.present(alert, animated: true, completion: nil)
        }
    }
#endif
}

extension ComplexProtectionService: NativeProvidersServiceDelegate {
    func dnsManagerStatusChanged() {
        if resources.dnsImplementation == .native {
            let managerIsEnabled = nativeProvidersService.managerIsEnabled
            let _ = updateSystemProtectionResources(toEnabledState: managerIsEnabled)
            NotificationCenter.default.post(name: ComplexProtectionService.systemProtectionChangeNotification, object: self)
        }
    }
}
