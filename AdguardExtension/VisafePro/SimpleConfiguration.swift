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

class SimpleConfigurationSwift: NSObject, ConfigurationServiceProtocol{
    
    var advancedMode: Bool = false
    
    var showStatusBar: Bool = false
    
    var appRated: Bool = false
    
    var userThemeMode: AEThemeMode {
        guard let themeMode = resources.sharedDefaults().object(forKey: AEDefaultsDarkTheme) as? UInt else {
            if #available(iOS 13.0, *) {
                return AESystemDefaultThemeMode
            } else {
                return AELightThemeMode
            }
        }
        return AEThemeMode.init(themeMode)
    }
    
    var systemAppearenceIsDark: Bool = false
    
    var resources: AESharedResourcesProtocol!

    var darkTheme: Bool {
        switch userThemeMode {
        case AESystemDefaultThemeMode:
            return systemAppearenceIsDark
        case AELightThemeMode:
            return false
        case AEDarkThemeMode:
            return true
        default:
            return false
        }
    }
    
    var proStatus: Bool {
        return true
    }

    var purchasedThroughLogin: Bool {
        return false
    }

    @objc init(withResources resources: AESharedResourcesProtocol, systemAppearenceIsDark: Bool) {
        super.init()
        initialize(withResources: resources, systemAppearenceIsDark: systemAppearenceIsDark)
    }

//    init(withResources resources: AESharedResourcesProtocol, systemAppearenceIsDark: Bool, purchaseService: PurchaseServiceProtocol?) {
//        super.init()
//        initialize(withResources: resources, systemAppearenceIsDark: systemAppearenceIsDark, purchaseService: purchaseService)
//    }
    
    func initialize(withResources resources: AESharedResourcesProtocol, systemAppearenceIsDark: Bool) {
        self.resources = resources
        self.systemAppearenceIsDark = systemAppearenceIsDark
    }
    
    var allContentBlockersEnabled: Bool = true
    
    var someContentBlockersEnabled: Bool = true
}
