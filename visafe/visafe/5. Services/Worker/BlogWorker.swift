//
//  BlogWorker.swift
//  TripTracker
//
//  Created by quangpc on 11/30/18.
//  Copyright © 2018 triptracker. All rights reserved.
//

import Foundation
import UIKit

class BlogWorker {
    
    static func createBlogEntry(name: String, completion: @escaping (_ entry: BlogEntry?, _ error: Error?) -> Void) {
        let router = APIRouter.createBlogEntry(name: name)
        APIManager.shared.request(target: router) { (json, error) in
            if let json = json, let model = BlogEntry(json: json) {
                completion(model, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func listBlogEntry(completion: @escaping (_ entries: [BlogEntry]?, _ error: Error?) -> Void) {
        let router = APIRouter.listBlogEntry
        APIManager.shared.request(target: router) { (json, error) in
            if let json = json {
                var items: [BlogEntry] = []
                for sub in json.arrayValue {
                    if let model = BlogEntry(json: sub) {
                        items.append(model)
                    }
                }
                completion(items, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func loadBlogs(viewId: Int?, entryId: Int?, page: Int?, limit: Int?, completion: @escaping (_ blogs: [Blog]?, _ error: Error?) -> Void) {
        let router = APIRouter.listBlog(viewId: viewId, entryId: entryId, page: page, limit: limit)
        APIManager.shared.request(target: router) { (json, error) in
            if let json = json {
                var blogs = [Blog]()
                for blogJson in json.arrayValue {
                    if let model = Blog(json: blogJson) {
                        blogs.append(model)
                    }
                }
                completion(blogs, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func likeOrUnlike(blog: Blog, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let router: APIRouter = APIRouter.likeBlog(blogId: blog.id)
        APIManager.shared.request(target: router) { (json, error) in
            if let _ = json {
                blog.count_like = blog.islike ? blog.count_like + 1 : blog.count_like - 1
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    static func sendComment(blog: Blog, text: String, completion: @escaping (_ comment: Comment?, _ error: Error?) -> Void) {
        let router = APIRouter.commentBlog(blogId: blog.id, content: text, commentId: nil)
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
    
    static func listLikers(id: Int, page: Int, limit: Int, completion: @escaping (_ likers: [User]?, _ error: Error?) -> Void) {
        
    }
    
    static func deleteBlog(blogId: Int, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let router: APIRouter = APIRouter.deleteBlog(blogId: blogId)
        APIManager.shared.request(target: router) { (json, error) in
            if let _ = json {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    static func createBlog(blog: Blog, cover: UIImage?, completion: @escaping CompletionHandler) {
        let router = APIRouter.createBlog(blog: blog, image: cover)
        APIManager.shared.request(target: router) { (json, error) in
            if let _ = json {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    static func updateBlog(blog: Blog, cover: UIImage?, completion: @escaping CompletionHandler) {
        let router = APIRouter.updateBlog(blog: blog, image: cover)
        APIManager.shared.request(target: router) { (json, error) in
            if let _ = json {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
}
