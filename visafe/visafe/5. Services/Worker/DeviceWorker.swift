//
//  DeviceWorker.swift
//  visafe
//
//  Created by Nguyễn Tuấn Vũ on 04/08/2021.
//

import UIKit
import Foundation
import ObjectMapper
import SwiftyJSON

class DeviceWorker {

    static func genDeviceId(completion: @escaping (_ result: GenDeviceResult?, _ error: Error?) -> Void) {
        let router = APIRouter.genDeviceId
        APIManager.shared.request(target: router) { (data, error) in
            var result: GenDeviceResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    result = Mapper<GenDeviceResult>().map(JSONObject: json)
                } catch { }
            }
            completion(result, error)
        }
    }
}
