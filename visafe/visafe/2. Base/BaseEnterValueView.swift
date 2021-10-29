//
//  EnterLinkWebsiteView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit
import SwiftMessages

public enum EnterValueViewEnum: Int {
    case link = 1
    case deviceName = 2
    case userName = 3
}

class BaseEnterValueView: MessageViewBase {
    
    var acceptAction:((_ name: String?) -> Void)?
    var cancelAction:(() -> Void)?
    
    @IBOutlet weak var titleViewLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var enterTextfield: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    class func loadFromNib() -> BaseEnterValueView? {
        return self.loadFromNib(withName: BaseEnterValueView.className)
    }
    
    var type: EnterValueViewEnum = .link
    
    func bindingData(type: EnterValueViewEnum, name: String?) {
        self.type = type
        switch self.type {
        case .link:
            titleViewLabel.text = "Chặn website không cho nhóm sử dụng"
            nameLabel.text = name
            enterTextfield.placeholder = "Nhập link website muốn chặn"
        case .deviceName:
            titleViewLabel.text = "Thiết bị"
            nameLabel.text = name
            enterTextfield.placeholder = "Nhập tên thiết bị"
        case .userName:
            titleViewLabel.text = "Chỉnh sửa thông tin cá nhân"
            nameLabel.text = name
            enterTextfield.placeholder = "Nhập tên"
        }
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        if validate() {
            acceptAction?(enterTextfield.text)
            SwiftMessages.hide()
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        cancelAction?()
        SwiftMessages.hide()
    }
    
    func validate() -> Bool {
        var success = true
        let value = enterTextfield.text ?? ""
        if type == .link {
            if value.isEmpty {
                success = false
                descriptionLabel.text = "Link không được để trống"
            } else if !value.isValidUrl {
                success = false
                descriptionLabel.text = "Link không đúng định dạng"
            }
        } else if type == .deviceName {
            if value.isEmpty {
                success = false
                descriptionLabel.text = "Tên thiết bị không được để trống"
            }
        } else if type == .userName {
            if value.isEmpty {
                success = false
                descriptionLabel.text = "Tên không được để trống"
            }
        }
        return success
    }
}

extension BaseEnterValueView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let field = textField as? BaseTextField else { return }
        if field.type != .error {
            field.setState(type: .active)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let field = textField as? BaseTextField else { return }
        if field.type != .error {
            field.setState(type: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == enterTextfield {
            acceptAction(textField)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 50
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
