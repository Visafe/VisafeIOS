//
//  CT135RequestAdapter.swift
//  TripTracker
//
//  Created by Cuong Nguyen on 12/8/20.
//  Copyright © 2020 triptracker. All rights reserved.
//

import UIKit
import Alamofire

class VisafeRequestAdapter: RequestAdapter, RequestRetrier {
    
    
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?) -> Void

    private let lock = NSLock()

    private var isRefreshing = false
//    private var requestsToRetry: [RequestRetryCompletion] = []
    var accessToken:String? = nil
    var refreshToken:String? = nil
    static let shared = VisafeRequestAdapter()

    private init(){
        let sessionManager = Alamofire.Session.default
//        sessionManager.adapter = self
//        sessionManager.retrier = self
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest

        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(APIConstant.baseURL), !urlString.hasSuffix("/renew") {
            if let token = accessToken {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
    }
    
    // MARK: - RequestRetrier
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        lock.lock() ; defer { lock.unlock() }

        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
//            requestsToRetry.append(completion)

            if !isRefreshing {
                refreshTokens { [weak self] succeeded, accessToken in
                    guard let strongSelf = self else { return }

                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }

                    if let accessToken = accessToken {
                        strongSelf.accessToken = accessToken
                    }

//                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
//                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }
    
    // MARK: - Private - Refresh Tokens

    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }

        isRefreshing = true

        let urlString = "\(APIConstant.baseURL)/token/renew"
        

//        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization":"Bearer \(refreshToken!)"]).responseJSON { [weak self] response in
//            guard let strongSelf = self else { return }
//            if
//                let json = response.result.value as? [String: Any],
//                let accessToken = json["accessToken"] as? String
//            {
//                completion(true, accessToken)
//            } else {
//                completion(false, nil)
//            }
//            strongSelf.isRefreshing = false
//        }

    }
}
