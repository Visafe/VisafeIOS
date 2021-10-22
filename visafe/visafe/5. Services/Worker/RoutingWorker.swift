//
//  RoutingWorker.swift
//  visafe
//
//  Created by Nguyễn Tuấn Vũ on 22/10/2021.
//

import UIKit
import Foundation
import ObjectMapper
import SwiftyJSON

class RoutingWorker {
    static func getDnsServer(completion: @escaping (_ result: RoutingModel?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.routing
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var model: RoutingModel?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    model = Mapper<RoutingModel>().map(JSONObject: json)
                } catch { }
            }
            completion(model, error, statusCode)
        }
    }

}
