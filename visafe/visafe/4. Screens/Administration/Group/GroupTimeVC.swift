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
        showLoading()
        GroupWorker.add(group: group) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.handleResponse(group: result, error: error)
        }
    }
    
    func handleResponse(group: GroupModel?, error: Error?) {
        if group != nil {
            showMemssage(title: "Tạo nhóm thành công", content: "Nhóm của bạn đã được áp dụng các thiết lập mà bạn khởi tạo.")
        } else {
            showError(title: "Tạo nhóm không thành công", content: "Có lỗi xảy ra. Vui lòng thử lại")
        }
    }
}
