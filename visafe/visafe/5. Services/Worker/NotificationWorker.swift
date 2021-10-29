//
//  NotificationWorker.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/11/21.
//

import UIKit
import Foundation
import ObjectMapper
import SwiftyJSON

class NotificationWorker {
    
    static func list(page: Int, completion: @escaping (_ result: NotificationResult?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.listNotification(pageIndex: page)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var result: NotificationResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    result = Mapper<NotificationResult>().map(JSONObject: json)
                } catch { }
            }
            completion(result, error, statusCode)
        }
    }
    
    static func readNotification(id: Int, completion: @escaping (_ result: BaseResult?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.readNotification(id: id)
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
