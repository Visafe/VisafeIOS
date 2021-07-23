//
//  GroupSettingDetailVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit

class GroupSettingDetailVC: BaseViewController {
    
    var group: GroupModel
    var onContinue:(() -> Void)?
    
    var sources: [PostGroupParentModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    init(group: GroupModel) {
        self.group = group
        super.init(nibName: GroupSettingDetailVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindingData()
    }
    
    func configView() {
        tableView.registerCells(cells: [GroupSettingDetailCell.className])
    }
    
    func bindingData() {
        sources = group.getAllModel()
        tableView.reloadData()
    }
}

extension GroupSettingDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sources[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupSettingDetailCell.className) as? GroupSettingDetailCell else {
            return UITableViewCell()
        }
        cell.bindingData(group: model)
        cell.actionMore = { [weak self] in
            guard let weakSelf = self else { return }
//            let vc = GroupSettingVC(group: weakSelf.group, editMode: weakSelf.editMode, parentType: model.type!)
//            weakSelf.navigationController?.pushViewController(vc)
        }
        cell.switchAction = { [weak self] isOn in
            guard let weakSelf = self else { return }
            if isOn {
                weakSelf.group.setDefault(type: model.type!)
            } else {
                weakSelf.group.disable(type: model.type!)
            }
        }
        return cell
    }
}
