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

// Affinity lists bitmasks
struct Affinity: OptionSet {
    
    let rawValue: UInt8
    
    static let general = Affinity(rawValue: 1 << 0)
    static let privacy = Affinity(rawValue: 1 << 1)
    static let socialWidgetsAndAnnoyances = Affinity(rawValue: 1 << 2)
    static let other = Affinity(rawValue: 1 << 3)
    static let custom = Affinity(rawValue: 1 << 4)
    static let security = Affinity(rawValue: 1 << 5)
}
