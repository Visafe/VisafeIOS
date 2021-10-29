//
//  BusinessWorker.swift
//  TripTracker
//
//  Created by Cuong Nguyen on 5/24/19.
//  Copyright © 2019 triptracker. All rights reserved.
//

import Foundation
import UIKit

class BusinessWorker {
    
    static func getListServices(parentId: Int?, page: Int?, limit: Int?, keysearch: String? = nil, completion: @escaping (_ services: [Service]?, _ error: Error?) -> Void) {
        let router = APIRouter.getListService(parentId: parentId, page: page, limit: limit, keysearch: keysearch)
        APIManager.shared.request(target: router) { (json, error) in
            if let json = json {
                var services = [Service]()
                for blogJson in json["list"].arrayValue {
                    if let model = Service(json: blogJson) {
                        services.append(model)
                    }
                }
                completion(services, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func createService(service: Service, image: UIImage?, completion: @escaping (_ service: Service?, _ error: Error?) -> Void) {
        let router = APIRouter.createService(service: service, image: image)
        APIManager.shared.request(target: router) { (json, error) in
            if let json = json, let ser = Service(json: json) {
                completion(ser, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func updateService(service: Service, image: UIImage?, completion: @escaping CompletionHandler) {
        let router = APIRouter.updateService(service: service, image: image)
        APIManager.shared.request(target: router) { (json, error) in
            if let _ = json {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    static func createBusiness(business: Business, image: UIImage?, completion: @escaping (_ business: Business?, _ error: Error?) -> Void) {
        let router = APIRouter.createBusiness(business: business, image: image)
        APIManager.shared.request(target: router) { (json, error) in
            if let json = json, let model = Business(json: json) {
                completion(model, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func activeBusiness(id: Int?, code: String?, completion: @escaping CompletionHandler) {
        let router = APIRouter.activeBusiness(businessId: id, code: code)
        APIManager.shared.request(target: router) { (json, error) in
            if let _ = json {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    static func businessDetail(id: Int?, completion: @escaping (_ business: Business?, _ error: Error?) -> Void) {
        let router = APIRouter.businessDetail(id: id)
        APIManager.shared.request(target: router) { (json, error) in
            if let json = json, let model = Business(json: json) {
                completion(model, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func updateBusiness(business: Business, image: UIImage?, completion: @escaping CompletionHandler) {
        let router = APIRouter.updateBusiness(business: business, image: image)
        APIManager.shared.request(target: router) { (json, error) in
            if let _ = json {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
}
