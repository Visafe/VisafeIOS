import Foundation

enum AdGuardVpnOperatingMode: CaseIterable {
    case general
    case ipSec
    
    /* ACNCidrRange objects represent IP address range with network mask  */
    var networkInterfaces: [ACNCidrRange] {
        switch self {
        case .general: return [ACNCidrRange(cidrString: "172.16.209.2"), ACNCidrRange(cidrString: "fd12:1:1:1::2")]
        case .ipSec: return [ACNCidrRange(cidrString: "10.40.32.0/19")]
        }
    }
    
    /* All available AdGuard VPN network interfaces */
    static var allAvailableInterfaces: [ACNCidrRange] { AdGuardVpnOperatingMode.allCases.flatMap { $0.networkInterfaces } }
}
