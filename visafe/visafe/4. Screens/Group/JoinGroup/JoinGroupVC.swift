//
//  JoinGroupVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit

class JoinGroupVC: BaseViewController {
    
    @IBOutlet weak var nameTextfield: BaseTextField!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var nameInfoLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    var dismissJoinGroup:(() -> Void)?
    
    var param: AddDeviceToGroupParam
    
    init(param: AddDeviceToGroupParam) {
        self.param = param
        super.init(nibName: JoinGroupVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // left
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "cancel_icon"), style: .done, target: self, action: #selector(onClickLeftButton))
        navigationItem.leftBarButtonItem = leftBarButton
        updateStateButtonContinue()
        configUI()
    }
    
    func configUI() {
        groupNameLabel.text = param.groupName
        deviceNameLabel.text = param.deviceName
    }
    
    @objc func onClickLeftButton() {
        dismiss(animated: true) {
            self.dismissJoinGroup?()
        }
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        if validateInfo() {
            param.deviceOwner = nameTextfield.text
            addDeviceToGroup(device: param)
        }
    }
    
    func addDeviceToGroup(device: AddDeviceToGroupParam) {
        showLoading()
        GroupWorker.addDevice(param: device) { [weak self] (result, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            if responseCode == 200 {
                weakSelf.showMessage(title: "Tham gia nhóm thành công", content: "Bây giờ, thiết bị của bạn sẽ được bảo vệ bởi nhóm \(device.groupName ?? "")") { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.dismissJoinGroup?()
                    strongSelf.dismiss(animated: true) {
                        strongSelf.dismissJoinGroup?()
                    }
                }
            } else {
                weakSelf.showError(title: "Tham gia nhóm thất bại", content: result?.local_msg ?? "")
            }
        }
    }
    
    func validateInfo() -> Bool {
        var success = true
        let name = nameTextfield.text ?? ""
        if name.isEmpty {
            success = false
            nameInfoLabel.text = "Tên không được để trống"
        } else {
            nameInfoLabel.text = nil
        }
        return success
    }
    
    func updateStateButtonContinue() {
        if (nameTextfield.text?.count ?? 0) == 0 {
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

extension JoinGroupVC: UITextFieldDelegate {
    
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
        if textField == nameTextfield {
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
