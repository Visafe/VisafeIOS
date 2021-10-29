//
//  GroupNameVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit

class PostWorkspacesVC: BaseViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var nameTextfield: BaseTextField!
    @IBOutlet weak var nameInfoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var workspace: WorkspaceModel
    var editMode: EditModeEnum
    
    var onUpdate:(() -> Void)?
    
    init(workspace: WorkspaceModel, editMode: EditModeEnum) {
        self.workspace = workspace
        self.editMode = editMode
        super.init(nibName: PostWorkspacesVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    
    func updateView() {
        nameTextfield.text = workspace.name
        let mutableAttributedString = NSMutableAttributedString.init(string: "Khi nhấn tạo, bạn đã đồng ý với ")
        let attribute1 = NSAttributedString(string: "Điều khoản & Chính sách", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "15A1FA")!])
        let attribute2 = NSAttributedString(string: " dành cho khách hàng của")
        let attribute3 = NSAttributedString(string: " Visafe", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        mutableAttributedString.append(attribute1)
        mutableAttributedString.append(attribute2)
        mutableAttributedString.append(attribute3)
        descriptionLabel.attributedText = mutableAttributedString
        updateStateButtonContinue()
        
        // title
        if editMode == .add {
            title = "Tạo workspace"
            continueButton.setTitle("Tạo", for: .normal)
        } else {
            title = "Chỉnh sửa workspace"
            continueButton.setTitle("Sửa", for: .normal)
        }
        
        // left
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "cancel_icon"), style: .done, target: self, action: #selector(onClickLeftButton))

        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc private func onClickLeftButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if validateInfo() {
            workspace.name = nameTextfield.text?.trim()
            workspace.type = WorkspaceTypeEnum.family
            workspace.phishingEnabled = true
            workspace.malwareEnabled = true
            workspace.logEnabled = true
            showLoading()
            if editMode == .add {
                WorkspaceWorker.add(workspace: workspace) { [weak self] (result, error, responseCode) in
                    guard let weakSelf = self else { return }
                    weakSelf.hideLoading()
                    weakSelf.handleResult(result: result, error: error, code: responseCode)
                    weakSelf.onUpdate?()
                }
            } else {
                let param = WorkspaceUpdateNameParam()
                param.workspace_name = workspace.name
                param.workspace_id = workspace.id
                WorkspaceWorker.updateName(param: param) { [weak self] (result, error, responseCode) in
                    guard let weakSelf = self else { return }
                    weakSelf.hideLoading()
                    weakSelf.handleUpdatename(result: result, error: error, code: responseCode)
                    weakSelf.onUpdate?()
                }
            }
        }
    }
    
    func handleUpdatename(result: WorkspaceModel?, error: Error?, code: Int?) {
        if code == 200 {
            if let id = result?.id, id == CacheManager.shared.getCurrentWorkspace()?.id {
                CacheManager.shared.setCurrentWorkspace(value: result!)
            }
            showMessage(title: "Sửa workspace thành công", content: "Bây giờ, bạn đã có thể thêm các nhóm để bảo vệ các thành viên khác") { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.parent?.dismiss(animated: true, completion: nil)
            }
        } else {
            showError(title: "Sửa cấu hình thất bại", content: result?.local_msg ?? "")
        }
    }

    func handleResult(result: WorkspaceModel?, error: Error?, code: Int?) {
        if code == 200 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUpdateWorkspace), object: nil)
            showMessage(title: "Tạo workspace thành công", content: "Bây giờ, bạn đã có thể thêm các nhóm để bảo vệ các thành viên khác") { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.parent?.dismiss(animated: true, completion: nil)
            }
        } else {
            showError(title: "Tạo cấu hình thất bại", content: result?.local_msg ?? "")
        }
    }
    
    func validateInfo() -> Bool {
        var success = true
        let name = nameTextfield.text ?? ""
        if name.isEmpty {
            nameInfoLabel.text = "Tên tài khoản không được để trống"
            success = false
        } else if name.length > 50 {
            nameInfoLabel.text = "Tên tài khoản không được dài hơn 50 ký tự"
            success = false
        }
        return success
    }
    
    func updateStateButtonContinue() {
        if (nameTextfield.text?.count ?? 0) == 0 {
            continueButton.backgroundColor = UIColor(hexString: "F8F8F8")
            continueButton.setTitleColor(UIColor(hexString: "111111"), for: .normal)
            continueButton.isUserInteractionEnabled = false
        } else {
            continueButton.backgroundColor = UIColor.mainColorOrange()
            continueButton.setTitleColor(UIColor.white, for: .normal)
            continueButton.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func valueChanged(_ sender: BaseTextField) {
        updateStateButtonContinue()
    }
}


extension PostWorkspacesVC: UITextFieldDelegate {
    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 50
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
