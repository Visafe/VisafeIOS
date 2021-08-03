//
//  EnterLinkWebsiteView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit
import SwiftMessages
import TweeTextField

class BaseEnterValueView: MessageView {
    
    var acceptAction:((_ website: String?) -> Void)?
    var cancelAction:(() -> Void)?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var enterTextfield: UITextField!
    
    class func loadFromNib() -> BaseEnterValueView? {
        return self.loadFromNib(withName: BaseEnterValueView.className)
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        if validateLink() {
            websiteTextfield.showInfo("")
            acceptAction?(websiteTextfield.text)
            SwiftMessages.hide()
        } else {
            websiteTextfield.showInfo("Link không đúng định dạng")
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        cancelAction?()
        SwiftMessages.hide()
    }
    
    func validateLink() -> Bool {
        guard let inputString = websiteTextfield.text else { return false }
        return inputString.isValidUrl
    }
}
