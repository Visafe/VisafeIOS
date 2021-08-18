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

    static func reportWebsite(url: String, completion: @escaping (_ result: BaseResult?, _ error: Error?) -> Void) {
        let router = APIRouter.reportPhishing(url: url)
        APIManager.shared.request(target: router) { (data, error) in
            var result: BaseResult?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    result = Mapper<BaseResult>().map(JSONObject: json)
                } catch { }
            }
            completion(result, error)
        }
    }
}
