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

extension UIApplication {
    
    static let VisafeSigninURL = "https://my.Visafe.com"
    static let VisafeUrl = "https://Visafe.com/forward.html"
    static let rateVisafeAppUrl = "https://itunes.apple.com/app/id1047223162?action=write-review"
    static let rateVisafeProAppUrl = "https://itunes.apple.com/app/id1126386264?action=write-review"
    
    func openVisafeUrl(action: String, from: String, buildVersion: String) {
        
        let urlString = VisafeUrl(action: action, from: from, buildVersion: buildVersion)
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func VisafeUrl(action: String, from: String, buildVersion: String)->String {
        var params: Dictionary<String, String> = [:]
        
        params["app"] = "ios"
        params["v"] = buildVersion
        params["action"] = action
        params["from"] = from
        
        let paramsString = ABECRequest.createString(fromParameters: params)
        
        return UIApplication.VisafeUrl + "?" + paramsString
    }
    
    func openAppStoreToRateApp() {
        if let writeReviewURL = URL(string: Bundle.main.isPro ? UIApplication.rateVisafeProAppUrl : UIApplication.rateVisafeAppUrl) {
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }
    }
}
