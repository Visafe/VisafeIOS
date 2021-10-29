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

struct SocialNetworkAuthParametersParser: IURLSchemeParametersParser {
    private let executor: IURLSchemeExecutor
    private let socialErrorUserNotFound = "user_not_found"
    
    init(executor: IURLSchemeExecutor) {
        self.executor = executor
    }
    
    
    func parse(_ url: URL) -> Bool {
        guard let params = url.parseAuthUrl().params else { return false }
        
        if let error = params["error"] {
            socialLoginErrorProcessor(error: error)
            return false
        } else {
            guard let token = params["access_token"], !token.isEmpty else { return false }
            guard let state = params["state"], !state.isEmpty else { return false }
            return executor.login(withAccessToken: token, state: state)
        }
    }
    
    private func socialLoginErrorProcessor(error: String) {
        DDLogInfo("(URLSchemeProcessor) Social login error: \(error)")
    }
}
