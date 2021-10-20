//
//  PaymentWorker.swift
//  visafe
//
//  Created by Cuong Nguyen on 8/12/21.
//

import UIKit
import Foundation
import ObjectMapper
import SwiftyJSON

class PaymentWorker {

    static func getPackages(completion: @escaping (_ result: [PackageModel]?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.packages
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var result: [PackageModel]?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    result = Mapper<PackageModel>().mapArray(JSONObject: json)
                } catch { }
            }
            completion(result, error, statusCode)
        }
    }
    
    static func order(id: Int, completion: @escaping (_ result: OrderResult?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = APIRouter.order(id: id)
        APIManager.shared.request(target: router) { (data, error, statusCode) in
            var result: OrderResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    result = Mapper<OrderResult>().map(JSONObject: json)
                } catch { }
            }
            completion(result, error, statusCode)
        }
    }
}
