//
//  JSONModelable.swift
//  TripTracker
//
//  Created by quangpc on 10/17/18.
//  Copyright © 2018 triptracker. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONModelable {
    
    init?(json: JSON)
    
}

extension JSON {
    
    func imageURLFromJson() -> String {
        let path = self["path"].stringValue
        let name = self["name"].stringValue
        return APIConstant.imageURL(path: path, name: name)
    }
    
}
