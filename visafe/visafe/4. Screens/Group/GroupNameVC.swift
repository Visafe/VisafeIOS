//
//  GroupNameVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit

class GroupNameVC: BaseViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var nameTextfield: BaseTextField!
    @IBOutlet weak var nameInfoLabel: UILabel!
    
    var group: GroupModel
    var editMode: EditModeEnum
    
    var onContinue:(() -> Void)?
    
    init(group: GroupModel, editMode: EditModeEnum) {
        self.group = group
        self.editMode = editMode
        super.init(nibName: GroupNameVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    
    func updateView() {
        nameTextfield.text = group.name
        updateStateButtonContinue()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if validateInfo() {
            group.name = nameTextfield.text?.trim()
            onContinue?()
        }
    }
    
    func validateInfo() -> Bool {
        var success = true
        let name = nameTextfield.text ?? ""
        if name.isEmpty {
            nameInfoLabel.text = "Tên nhóm không được để trống"
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


extension GroupNameVC: UITextFieldDelegate {
    
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
}
