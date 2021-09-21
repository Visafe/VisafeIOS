//
//  DoHNative.swift
//  visafe
//
//  Created by Nguyễn Tuấn Vũ on 04/08/2021.
//

import UIKit
import NetworkExtension

class DoHNative {

    static let shared = DoHNative()
    var isEnabled = false {
        didSet {
            if oldValue != isEnabled {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: updateDnsStatus), object: nil)
                pushNoti()
            }
        }
    }
    var isInstalled = false

    func pushNoti() {
        let isEnabled = DoHNative.shared.isEnabled
        let content = UNMutableNotificationContent()
        content.title = isEnabled ? "Đã kích hoạt chế độ bảo vệ!": "Bạn đã tắt chế độ bảo vệ"
        content.body = isEnabled ? "Chế độ chống lừa đảo, mã độc, tấn công mạng đã được kích hoạt!": "Thiết bị của bạn có thể bị ảnh hưởng bởi tấn công mạng"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "localNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

    }

    func saveDNS(_ onSavedStatus: @escaping (_ error: Error?) -> Void) {
        if #available(iOS 14.0, *) {
            NEDNSSettingsManager.shared().loadFromPreferences { (error) in
                if let _error = error {
                    onSavedStatus(_error)
                    return
                }
                let dohSetting = NEDNSOverHTTPSSettings(servers: [])
                dohSetting.serverURL = URL(string: Common.getDnsServer())
                NEDNSSettingsManager.shared().dnsSettings = dohSetting
                NEDNSSettingsManager.shared().saveToPreferences { (saveError) in
                    if let _error = saveError {
                        onSavedStatus(nil)
                    } else {
                        onSavedStatus(nil)
                    }
                }
            }
        }
    }

    @available(iOS 14.0, *)
    func getDnsManagerStatus() {
        loadDnsManager { dnsManager in
            guard let manager = dnsManager else {
                self.isInstalled = false
                self.isEnabled = false
                return
            }
            self.isInstalled = manager.dnsSettings != nil
            self.isEnabled = manager.isEnabled
        }
    }

    @available(iOS 14.0, *)
    private func loadDnsManager(_ onManagerLoaded: @escaping (_ dnsManager: NEDNSSettingsManager?) -> Void) {
        let dnsManager = NEDNSSettingsManager.shared()
        dnsManager.loadFromPreferences { error in
            if error != nil {
                onManagerLoaded(nil)
                return
            }
            onManagerLoaded(dnsManager)
        }
    }

    @available(iOS 14.0, *)
    func removeDnsManager(_ onErrorReceived: @escaping (_ error: Error?) -> Void) {
        loadDnsManager { [weak self] dnsManager in
            guard let dnsManager = dnsManager else {
                onErrorReceived(NativeDnsProviderError.failedToLoadManager)
                return
            }
            dnsManager.removeFromPreferences(completionHandler: onErrorReceived)
            // Check manager status after delete
            self?.getDnsManagerStatus()
        }
    }
}

enum NativeDnsProviderError: Error {
    case unsupportedDnsProtocol
    case failedToLoadManager
    case unsupportedProtocolsConfiguration
    case invalidUpstreamsNumber
}
