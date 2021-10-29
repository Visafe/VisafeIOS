//
//  FirebaseManager.swift
//  TripTracker
//
//  Created by Cuong Nguyen on 6/9/19.
//  Copyright © 2019 triptracker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

let kTBUser = "users"
let kTBMessage = "messages"
let kTBUserMessage = "user_messages"

class FirebaseManager {
    static let shared = FirebaseManager()
    let dbRef = Database.database().reference(fromURL: "https://triptracker-35bb1.firebaseio.com/")
    let storageRef = Storage.storage().reference(forURL: "gs://triptracker-35bb1.appspot.com/")
    
    func createUserFirebase(email: String, password: String, name: String, avartar: UIImage, completion: CompletionHandler?) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (response, error) in
            guard let sSelf = self else { return }
            if error == nil, let res = response {
                var data = Data()
                data = avartar.jpegData(compressionQuality: 0.8) ?? Data()
                let storeRef = sSelf.storageRef.child("profile_images").child("\(UUID().uuidString).png")
                storeRef.putData(data as Data, metadata: nil){ (metaData, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completion?(false, error)
                    } else {
                        storeRef.downloadURL(completion: { (url, error) in
                            let profileImageUrl = url?.absoluteString ?? ""
                            if let _ = url {
                                sSelf.dbRef.child(kTBUser).child(res.user.uid).updateChildValues(["username": name, "avatar_url":profileImageUrl, "email":email])
                                completion?(true, nil)
                            } else {
                                completion?(false, error)
                            }
                        })
                    }
                }
            } else {
                completion?(false, error)
            }
        }
    }
    
    func signInFirebase(email: String, password: String, completion: CompletionHandler?) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let _ = result?.user {
                completion?(true, nil)
            } else {
                completion?(false, error)
            }
        }
    }
    
    func sendMessage(message: String?, toId: String?) {
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = toId else { return }
        guard let message = message else { return }
        let timestamp = Int(Date().timeIntervalSince1970)
        let messageRef = FirebaseManager.shared.dbRef.child(kTBMessage).childByAutoId()
        let values: [String: Any] = ["text": message, "fromId": fromId, "toId": toId, "timestamp": timestamp]
        messageRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let messageId = messageRef.key {
                let userMessageRef = FirebaseManager.shared.dbRef.child(kTBUserMessage).child(fromId).child(toId)
                userMessageRef.updateChildValues([messageId: 1])
                let userReciveMessageRef = FirebaseManager.shared.dbRef.child(kTBUserMessage).child(toId).child(fromId)
                userReciveMessageRef.updateChildValues([messageId: 1])
            }
        }
    }
    
    func sendImage(image: UIImage, toId: String?) {
        guard let toId = toId else { return }
        var data = Data()
        data = image.jpegData(compressionQuality: 0.5) ?? Data()
        let storeRef = self.storageRef.child("message_images").child("\(UUID().uuidString).png")
        storeRef.putData(data as Data, metadata: nil){ [weak self] (metaData, error) in
            guard let sSelf = self else { return }
            if let error = error {
                print(error.localizedDescription)
            } else {
                storeRef.downloadURL(completion: { (url, error) in
                    if let imageUrl = url?.absoluteString {
                        sSelf.sendMessageWithImageUrl(imageUrl: imageUrl, toId: toId)
                    }
                })
            }
        }
    }
    
    func sendMessageWithImageUrl(imageUrl: String, toId: String?) {
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = toId else { return }
        let timestamp = Int(Date().timeIntervalSince1970)
        let messageRef = FirebaseManager.shared.dbRef.child(kTBMessage).childByAutoId()
        let values: [String: Any] = ["imageUrl": imageUrl, "fromId": fromId, "toId": toId, "timestamp": timestamp]
        messageRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let messageId = messageRef.key {
                let userMessageRef = FirebaseManager.shared.dbRef.child(kTBUserMessage).child(fromId).child(toId)
                userMessageRef.updateChildValues([messageId: 1])
                let userReciveMessageRef = FirebaseManager.shared.dbRef.child(kTBUserMessage).child(toId).child(fromId)
                userReciveMessageRef.updateChildValues([messageId: 1])
            }
        }
    }
}
