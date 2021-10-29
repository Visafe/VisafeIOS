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

protocol ServiceLocating {
    func getService<T>() -> T?
}

// MARK: - ServiceLocator -
/**
 ServiceLocator this service locates all shared services
 */
final class ServiceLocator: NSObject, ServiceLocating {
    
    private lazy var services: Dictionary<String, Any> = [:]
    private func typeName(some: Any) -> String {
        return "\(some)"
    }
    
    func addService<T>(service: T) {
        let key = typeName(some: T.self)
        services[key] = service
    }
    
    func getService<T>() -> T? {
        let key = typeName(some: T.self)
        return services[key] as? T
    }
    
    /// for using in obj c code
    @objc func getSetvice(typeName: String) -> Any? {
        return services[typeName]
    }
    
    @objc public static let shared = ServiceLocator()
}
