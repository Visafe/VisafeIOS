//
//  UIViewController+ImagePicker.swift
//  TripTracker
//
//  Created by quangpc on 10/17/18.
//  Copyright © 2018 triptracker. All rights reserved.
//

import Foundation
import UIKit
import YPImagePicker

extension UIViewController {
    
    func showImagePicker(completion: @escaping (_ image: UIImage) -> Void) {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.onlySquare  = false
        config.onlySquareImagesFromCamera = false
        config.targetImageSize = .original
        config.usesFrontCamera = true
        config.showsFilters = true
        config.shouldSaveNewPicturesToAlbum = false
        config.albumName = "TripTracker"
        config.screens = [.photo, .library]
        config.startOnScreen = .photo
        config.showsCrop = .none
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 3
        config.library.spacingBetweenItems = 2
        config.isScrollToChangeModesEnabled = false
        
        // Build a picker with your configuration
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] (items, _) in
            
            picker.dismiss(animated: true, completion: {
                if let photo = items.singlePhoto {
                    completion(photo.image)
                }
            })
//            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    func showImagePickers(completion: @escaping (_ images: [UIImage],_ isCancel:Bool) -> Void) {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.onlySquare  = false
        config.onlySquareImagesFromCamera = false
        config.targetImageSize = .original
        config.usesFrontCamera = true
        config.showsFilters = true
        config.shouldSaveNewPicturesToAlbum = false
        config.albumName = "TripTracker"
        config.screens = [.photo, .library]
        config.startOnScreen = .photo
        config.showsCrop = .none
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.library.maxNumberOfItems = 5
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 3
        config.library.spacingBetweenItems = 2
        config.isScrollToChangeModesEnabled = false
        
        // Build a picker with your configuration
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] (items, isCancel) in
            
            picker.dismiss(animated: true, completion: {
                completion(items.photos,isCancel)
            })
            //            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
}
public extension Array where Element == YPMediaItem {
    var photos: [UIImage] {
        var photos : [UIImage] = []
        for f in self {
            if case let .photo(p) = f {
                photos.append(p.image)
            }
        }
        return photos
    }
    
}
