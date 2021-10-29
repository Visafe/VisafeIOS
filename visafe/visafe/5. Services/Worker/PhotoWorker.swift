//
//  PhotoWorker.swift
//  TripTracker
//
//  Created by quangpc on 11/14/18.
//  Copyright © 2018 triptracker. All rights reserved.
//

import Foundation

class PhotoWorker {
    
    static func createAlbum(name: String, completion: @escaping (_ album: Album?, _ error: Error?) -> Void) {
        let router = APIRouter.createAlbum(name: name)
        APIManager.shared.request(target: router) { (json, error) in
            if let json = json {
                if let model = Album(json: json) {
                    completion(model, nil)
                } else {
                    completion(nil, APIError.serverLogicError(message: "Cannot parse data"))
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func loadPhotoAlbums(completion: @escaping (_ albums: [Album]?, _ error: Error?) -> Void) {
        let router = APIRouter.listAlbums
        APIManager.shared.request(target: router) { (json, error) in
            if let json = json {
                var items: [Album] = []
                for item in json["list"].arrayValue {
                    if let model = Album(json: item) {
                        items.append(model)
                    }
                }
                completion(items, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func loadPhotos(viewId: Int?, albumId: Int?, page: Int?, limit: Int?, completion: @escaping (_ photos: [Photo]?, _ error: Error?) -> Void) {
        let router = APIRouter.listPhotos(viewUserId: viewId, albumId: albumId, page: page, limit: limit)
        APIManager.shared.request(target: router) { (json, error) in
            if let json = json {
                var photos: [Photo] = []
                for pho in json.arrayValue {
                    if let model = Photo(json: pho) {
                        photos.append(model)
                    }
                }
                completion(photos, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func likeOrUnlike(photo: Photo, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        //        let router: APIRouter = photo.islike ? APIRouter.like(type_id: photo.id, type: .photo) : APIRouter.unlike(type_id: photo.id, type: .photo)
        //        APIManager.shared.request(target: router) { (json, error) in
        //            if let _ = json {
        //                photo.count_like = photo.islike ? photo.count_like + 1 : photo.count_like - 1
        //                completion(true, nil)
        //            } else {
        //                completion(false, error)
        //            }
        //        }
        
        let router: APIRouter = APIRouter.likePhoto(photoId: photo.id)
        APIManager.shared.request(target: router) { (json, error) in
            if let _ = json {
                photo.count_like = photo.islike ? photo.count_like + 1 : photo.count_like - 1
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    static func sendComment(photo: Photo, text: String, completion: @escaping (_ comment: Comment?, _ error: Error?) -> Void) {
        let router = APIRouter.commentPhoto(photoId: photo.id, content: text, commentId: nil)
        APIManager.shared.request(target: router) { (json, error) in
            if let json = json {
                guard let comment = Comment(json: json) else {
                    completion(nil, APIError.serverLogicError(message: "no comment return"))
                    return
                }
                completion(comment, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
