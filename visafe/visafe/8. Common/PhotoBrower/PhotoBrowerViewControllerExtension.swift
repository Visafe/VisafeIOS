//
//  PhotoBrowerViewControllerExtension.swift
//  TripTracker
//
//  Created by Hung NV on 5/16/19.
//  Copyright © 2019 triptracker. All rights reserved.
//

import UIKit
import IDMPhotoBrowser
extension UIViewController {

    func showPhoto(urlStrings:[String], animatedFrom:UIView? = nil) {
        let photos = urlStrings.map { (urlString) -> IDMPhoto in
            return IDMPhoto(url: URL(string: urlString)!)
        }
        var photoBrower:IDMPhotoBrowser!
        if let animatedFrom = animatedFrom{
            photoBrower = IDMPhotoBrowser(photos: photos, animatedFrom: animatedFrom)
        }else{
            photoBrower = IDMPhotoBrowser(photos: photos)
        }
        self.present(photoBrower, animated: true, completion: nil)
    }
    
    func showPhoto(moreItems:[ActionSheetItem],urlStrings:[String], animatedFrom:UIView? = nil,didClickMoreItem:((_ item:ActionSheetItem,_ index:UInt)->Void)?) {
        let photos = urlStrings.map { (urlString) -> IDMPhoto in
            return IDMPhoto(url: URL(string: urlString)!)
        }
        var photoBrower:BusinessPhotoBrowerVC!
        if let animatedFrom = animatedFrom{
            photoBrower = BusinessPhotoBrowerVC(photos: photos, animatedFrom: animatedFrom)
        }else{
            photoBrower = BusinessPhotoBrowerVC(photos: photos)
        }
        photoBrower.moreItems = moreItems
        photoBrower.didClickMoreItem = didClickMoreItem
        self.present(photoBrower, animated: true, completion: nil)
    }
}

