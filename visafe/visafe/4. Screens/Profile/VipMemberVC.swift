//
//  VipMemberVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit

class VipMemberVC: BaseViewController {
    
    @IBOutlet weak var codeTextfield: BaseTextField!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var nameInfoLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // left
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "cancel_icon"), style: .done, target: self, action: #selector(onClickLeftButton))
        navigationItem.leftBarButtonItem = leftBarButton
        updateStateButtonContinue()
    }
    
    
    @objc func onClickLeftButton() {
        dismiss(animated: true)
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        if validateInfo() {
            showLoading()
            GroupWorker.activeVip(key: codeTextfield.text!) { [weak self] (result, error, responseCode) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()

                if responseCode == 200{
                    CacheManager.shared.setVipStatus(value: result?.key_info?.DOHurl)
                    if #available(iOS 14.0, *) {
                        DoHNative.shared.resetDnsSetting()
                    } else {
                    }
                    weakSelf.showMessage(title: "Kích hoạt thành viên VIP thành công", content: "") {
                        weakSelf.dismiss(animated: true, completion: nil)
                    }
                } else {
                    weakSelf.showError(title: "Có lỗi xảy ra. Vui lòng thử lại!", content: result?.local_msg ?? "")
                }
            }
        }
    }
    
    func validateInfo() -> Bool {
        var success = true
        let name = codeTextfield.text ?? ""
        if name.isEmpty {
            success = false
            nameInfoLabel.text = "Mã không được để trống"
        } else {
            nameInfoLabel.text = nil
        }
        return success
    }
    
    func updateStateButtonContinue() {
        if (codeTextfield.text?.count ?? 0) == 0 {
            doneButton.backgroundColor = UIColor(hexString: "F8F8F8")
            doneButton.setTitleColor(UIColor(hexString: "111111"), for: .normal)
            doneButton.isUserInteractionEnabled = false
        } else {
            doneButton.backgroundColor = UIColor.mainColorOrange()
            doneButton.setTitleColor(UIColor.white, for: .normal)
            doneButton.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func valueChanged(_ sender: BaseTextField) {
        updateStateButtonContinue()
    }
}

extension VipMemberVC: UITextFieldDelegate {
    
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
        if textField == codeTextfield {
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
