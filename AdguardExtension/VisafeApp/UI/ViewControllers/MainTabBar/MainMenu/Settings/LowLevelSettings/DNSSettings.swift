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

enum UpstreamType {
    case bootstrap
    case fallback
    case customAddress
}

@objc
enum BlockingModeSettings: Int {
    case agDefault = 0
    case agRefused = 1
    case agNxdomain = 2
    case agUnspecifiedAddress = 3
    case agCustomAddress = 4
    
    dynamic var name: String {
        switch self {
        case .agDefault:
            return "Default"
        case .agRefused:
            return "REFUSED"
        case .agNxdomain:
            return "NXDOMAIN"
        case .agUnspecifiedAddress:
            return "Null IP"
        case .agCustomAddress:
            return "Custom IP"
        }
    }
}
