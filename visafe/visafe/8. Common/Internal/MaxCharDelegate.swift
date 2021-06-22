//
//  MaxCharDelegate.swift
//  TripTracker
//
//  Created by quangpc on 11/6/18.
//  Copyright © 2018 triptracker. All rights reserved.
//

import Foundation
import UIKit

class MaxCharDelegate: NSObject {
    
    var maxChar = 100
    var charLeftHandler: ((_ charLeft: Int) -> Void)?
    var textWillChangeHandler: ((_ newText: String) -> Void)?
    
    convenience init(maxChar: Int) {
        self.init()
        self.maxChar = maxChar
    }
    
}

extension MaxCharDelegate: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        if newText.count > maxChar {
            return false
        }
        let left = maxChar - newText.count
        charLeftHandler?(left)
        textWillChangeHandler?(newText)
        return true
    }
}

extension MaxCharDelegate: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = NSString(string: textView.text).replacingCharacters(in: range, with: text)
        if newText.count > maxChar {
            return false
        }
        let left = maxChar - newText.count
        charLeftHandler?(left)
        textWillChangeHandler?(newText)
        return true
    }
}

