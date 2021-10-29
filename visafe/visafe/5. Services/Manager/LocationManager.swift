//
//  LocationManager.swift
//  TripTracker
//
//  Created by quangpc on 10/11/18.
//  Copyright © 2018 triptracker. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager {
    
    static let shared = LocationManager()
    
    var currentLocation: CLLocation?
    
    var subscribeSignificantLocations: ((_ location: CLLocation?) -> Void)?
    
    init() {
    }
    
    func subscribe() {
        Locator.requestAuthorizationIfNeeded(.whenInUse)
        Locator.subscribeSignificantLocations(onUpdate: { [weak self] (newLocation) -> (Void) in
            self?.currentLocation = newLocation
            self?.subscribeSignificantLocations?(newLocation)
            print(newLocation)
        }) { (error, lastLocation) -> (Void) in
            
        }
    }
    
}
