//
//  CommonWorker.swift
//  visafe
//
//  Created by Cuong Nguyen on 8/18/21.
//

import UIKit
import Foundation
import ObjectMapper
import SwiftyJSON

class CommonWorker {

    static func reportWebsite(url: String, completion: @escaping (_ result: BaseResult?, _ error: Error?, _ statusCode: Int?) -> Void) {
        let router = ReportAPIRouter.reportPhishing(url: url)
        ReportAPIManager.shared.request(target: router) { (data, error, statusCode) in
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
