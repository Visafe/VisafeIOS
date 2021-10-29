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

    static func genDeviceId(completion: @escaping (_ result: GenDeviceResult?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.genDeviceId
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var result: GenDeviceResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    result = Mapper<GenDeviceResult>().map(JSONObject: json)
                } catch { }
            }
            completion(result, error, statusCode)
        }
    }
    
    static func registerDevice(token: String?, completion: @escaping (_ result: BaseResult?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.registerDevice(token: token, deviceId: CacheManager.shared.getDeviceId())
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var result: BaseResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    result = Mapper<BaseResult>().map(JSONObject: json)
                } catch { }
            }
            completion(result, error, statusCode)
        }
    }
}
