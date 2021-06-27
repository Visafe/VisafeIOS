//
//  SetupSecurityWorkspaceVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit

class SetupSecurityWorkspaceVC: BaseViewController {
    
    var workspace: WorkspaceModel
    var editMode: EditModeEnum

    @IBOutlet weak var tableView: UITableView!
    init(workspace: WorkspaceModel, editMode: EditModeEnum) {
        self.workspace = workspace
        self.editMode = editMode
        super.init(nibName: SetupSecurityWorkspaceVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
    }
    
    func registerTableView() {
        tableView.registerCells(cells: [SecurityWorkspaceCell.className])
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        showLoading()
        if editMode == .add {
            WorkspaceWorker.add(workspace: workspace) { [weak self] (result, error) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()
                weakSelf.handleResult(result: result, error: error)
            }
        } else {
            WorkspaceWorker.update(workspace: workspace) { [weak self] (result, error) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()
                weakSelf.handleResult(result: result, error: error)
            }
        }
    }
    
    func handleResult(result: BaseResult?, error: Error?) {
        if result == nil && error == nil {
            if editMode == .add {
                showMemssage(title: "Tạo cấu hình thành công", content: "Visafe đã sẵn sàng bảo vệ bạn")
            } else {
                showMemssage(title: "Sửa cấu hình thành công", content: "Visafe đã sẵn sàng bảo vệ bạn")
            }
        } else {
            if editMode == .add {
                showError(title: "Tạo cấu hình thất bại", content: "Có lỗi xảy ra, vui lòng thử lại")
            } else {
                showMemssage(title: "Sửa cấu hình thất bại", content: "Có lỗi xảy ra, vui lòng thử lại")
            }
        }
    }
}

extension SetupSecurityWorkspaceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SecurityWorkspaceEnum.getAll().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SecurityWorkspaceCell.className) as? SecurityWorkspaceCell else {
            return UITableViewCell()
        }
        let type = SecurityWorkspaceEnum.getAll()[indexPath.row]
        cell.bindingData(workspace: workspace, type: type)
        return cell
    }
}

