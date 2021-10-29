import UIKit

extension UIApplication {
    
    /* Checks if Visafe VPN is installed on device */
    static var VisafeVpnIsInstalled: Bool {
        let appUrl = URL(string: "\(VisafeVpnScheme)://")!
        return shared.canOpenURL(appUrl)
    }
    
    /* Checks if Visafe VPN tunnel is running */
    static var VisafeVpnIsActive: Bool {
        let activeNetworkInterfaces = NetworkManager.networkInterfaces
        
        /// Checks if there is Visafe VPN tunnel interface among all active interfaces
        for adgInterface in VisafeVpnOperatingMode.allAvailableInterfaces {
            for interface in activeNetworkInterfaces {
                guard let cidrRange = ACNCidrRange(cidrString: interface) else { continue }
                
                if adgInterface.contains(cidrRange) {
                    return true
                }
            }
        }
        return false
    }
    
    /* Visafe VPN app scheme */
    static let VisafeVpnScheme = "Visafe-vpn"
    
    /* Opens AppStore app and redirects to Visafe VPN app page */
    static func openVisafeVpnAppStorePage() {
        let vpnAppUrlString = "https://itunes.apple.com/app/id1525373602"
        if let vpnAppUrl = URL(string: vpnAppUrlString) {
            shared.open(vpnAppUrl, options: [:], completionHandler: nil)
        }
    }
    
    /*
     Opens Visafe VPN app if it is installed
     Does nothing otherwise
     */
    static func openVisafeVpnAppIfInstalled() {
        let appUrl = URL(string: "\(VisafeVpnScheme)://")!
        if shared.canOpenURL(appUrl) {
            DDLogInfo("Visafe VPN is installed, open it now")
            shared.open(appUrl)
        }
    }
    
    static func youtubeAppInstalled()->Bool {
        let appUrl = URL(string: "youtube://")!
        return shared.canOpenURL(appUrl)
    }
}
