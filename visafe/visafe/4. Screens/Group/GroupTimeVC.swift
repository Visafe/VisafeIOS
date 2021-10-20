//
//  GroupTimeVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit

class GroupTimeVC: BaseViewController {
    
    var group: GroupModel
    var editMode: EditModeEnum
    
    var onContinue:(() -> Void)?
    
    init(group: GroupModel, editMode: EditModeEnum) {
        self.group = group
        self.editMode = editMode
        super.init(nibName: GroupTimeVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func doneAction(_ sender: Any) {
        
        if editMode == .add {
            showLoading()
            GroupWorker.add(group: group) { [weak self] (result, error, responseCode) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()
                weakSelf.handleResponse(group: result, error: error, responseCode: responseCode)
            }
        } else {
            let param = RenameGroupParam()
            param.group_id = group.groupid
            param.group_name = group.name
            showLoading()
            GroupWorker.rename(param: param) { [weak self] (result, error, responseCode) in
                guard let weakSelf = self else { return }
                GroupWorker.update(group: weakSelf.group) { [weak self] (result, error, responseCode) in
                    guard let weakSelf = self else { return }
                    weakSelf.hideLoading()
                    weakSelf.handleResponseUpdate(group: result, error: error, responseCode: responseCode)
                }
            }
        }
    }
    
    func handleResponse(group: GroupModel?, error: Error?, responseCode: Int?) {
        if responseCode == 200 {
            showMessage(title: "Tạo nhóm thành công", content: "Nhóm của bạn đã được áp dụng các thiết lập mà bạn khởi tạo.") { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.parent?.dismiss(animated: true, completion: nil)
            }
        } else {
            showError(title: "Tạo nhóm không thành công", content: group?.local_msg ?? "")
        }
    }
    
    func handleResponseUpdate(group: GroupModel?, error: Error?, responseCode: Int?) {
        if responseCode == 200 {
            showMessage(title: "Sửa nhóm thành công", content: "Nhóm của bạn đã được áp dụng các thiết lập mà bạn cập nhật.") { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.parent?.dismiss(animated: true, completion: nil)
            }
        } else {
            showError(title: "Sửa nhóm không thành công", content: group?.local_msg ?? "")
        }
    }
}
