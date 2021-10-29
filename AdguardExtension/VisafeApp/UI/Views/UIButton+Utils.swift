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
import UIKit

extension UIButton {
    /**
     Makes button's title uppercased for paticular state (default is normal)
     */
    func makeTitleTextUppercased(for state: UIControl.State = .normal){
        let buttonTitle = title(for: state)
        setTitle(buttonTitle?.uppercased(), for: state)
    }
    
    /*
     Makes button look like standard Visafe green button
     with green background, no border and white text
     */
    func applyStandardGreenStyle() {
        let greenColor = UIColor.VisafeColor.lightGreen1
        self.layer.cornerRadius = 8.0
        self.backgroundColor = greenColor
        self.setTitleColor(.white, for: .normal)
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    /*
     Makes button look like standard Visafe VPN green button
     with green background, no border and white text
     */
    func applyStandardVisafeVPNGreenStyle() {
        let greenColor = UIColor.VisafeColor.vpnLightGreen
        self.layer.cornerRadius = 8.0
        self.backgroundColor = greenColor
        self.setTitleColor(.white, for: .normal)
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    /*
     Makes button look like standard Visafe button
     with opaque background, selected color for borders and text
     */
    func applyStandardOpaqueStyle(color: UIColor = UIColor.VisafeColor.lightGray4) {
        self.layer.cornerRadius = 8.0
        self.backgroundColor = .clear
        self.setTitleColor(color, for: .normal)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color.cgColor
    }
    
    /*
     Makes button look like standard Visafe Sign in button
     */
    func applyRoundRectStyle(color: CGColor) {
        self.layer.cornerRadius = self.frame.height / 4
        self.layer.borderWidth = 1.5
        self.layer.borderColor = color
    }
}
