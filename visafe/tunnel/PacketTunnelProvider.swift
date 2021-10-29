//
//  PacketTunnelProvider.swift
//  tunnel
//
//  Created by Nguyễn Tuấn Vũ on 04/07/2021.
//

import NetworkExtension

class PacketTunnelProvider: NEPacketTunnelProvider {
    override init() {
        super.init()
    }

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        // Add code here to start the process of connecting the tunnel.
        let setting = NETunnelNetworkSettings()
        let dnsSetting = NEDNSSettings(servers: ["https://dns-staging.visafe.vn/dns-query/"])
        setting.dnsSettings = dnsSetting
        self.setTunnelNetworkSettings(setting) { (error) in
            if error == nil {
                print("succress")
            } else {
                print(error?.localizedDescription)
                completionHandler(error)
            }
        }
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code here to start the process of stopping the tunnel.
        completionHandler()
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        // Add code here to handle the message.
        if let handler = completionHandler {
            handler(messageData)
        }
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        // Add code here to get ready to sleep.
        completionHandler()
    }
    
    override func wake() {
        // Add code here to wake up.
    }
}
