//
//  NVTagging.swift
//  TripTracker
//
//  Created by Hung NV on 9/24/19.
//  Copyright © 2019 triptracker. All rights reserved.
//

import UIKit

class NVTagging: Tagging {
    var maxHeight: CGFloat = 102
    var minHeight: CGFloat = 48
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        
    }
    func setup() {
        
        backgroundColor = UIColor.white
        placeHolder = "What's new?"
        placeHolderLabel.textColor = "264CDB".toColor().withAlphaComponent(0.28)
        placeHolderLabel.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = AppColor.blue
        textView.font = UIFont.systemFont(ofSize: 15)
        textInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        defaultAttributes = [NSAttributedString.Key.foregroundColor: AppColor.blue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        symbolAttributes = [NSAttributedString.Key.foregroundColor: AppColor.blue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        taggedAttributes = [NSAttributedString.Key.foregroundColor: AppColor.blue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        var height = textView.sizeThatFits(CGSize(width: textView.frame.width, height: 99999)).height
        height = min(height, maxHeight)
        height = max(minHeight, height)
        for con in constraints {
            if con.firstAttribute == .height && con.constant != height{
                con.constant = height
                dataSource?.tagging(self, didChangedHeight: height)
                break
            }
        }
    }
    
    override func updateTaggedList(allText: String, tagText: String, object: Any? = nil) {
        super.updateTaggedList(allText: allText, tagText: tagText, object: object)
        textViewDidChange(textView)
    }
}
