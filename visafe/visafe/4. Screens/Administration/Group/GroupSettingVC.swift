//
//  GroupSettingVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit

class GroupSettingVC: BaseViewController {

    var group: GroupModel
    var editMode: EditModeEnum
    
    var onContinue:(() -> Void)?
    
    var sources: [PostGroupModel] = []
    
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    init(group: GroupModel, editMode: EditModeEnum) {
        self.group = group
        self.editMode = editMode
        super.init(nibName: GroupSettingVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configObserve()
        prepareData()
    }
    
    func configView() {
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 25
        
        tableView.registerCells(cells: [GroupSettingCell.className])
    }
    
    func prepareData() {
        sources = group.buildSource()
        tableView.reloadData()
    }
    
    func configObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                //key point 0,
                self.bottomContraint.constant =  8
                UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        }
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.bottomContraint.constant = keyboardHeight + 8
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @IBAction func continueActionButton(_ sender: Any) {
        group.bindingData(sources: sources)
        onContinue?()
    }
}

extension GroupSettingVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = sources[section]
        if model.isSelected ?? false {
            return sources[section].children.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sources[indexPath.section]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupSettingCell.className) as? GroupSettingCell else {
            return UITableViewCell()
        }
        switch model.type {
        case .appads:
            if let data = model.children[indexPath.row] as? AppAdsModel {
                cell.bindingData(ads: data)
            } else {
                cell.bindingData(ads: nil)
            }
        case .service:
            if let data = model.children[indexPath.row] as? BlockServiceModel {
                cell.bindingData(service: data)
            } else {
                cell.bindingData(service: nil)
            }
        case .nativetracking:
            if let data = model.children[indexPath.row] as? NativeTrackingModel {
                cell.bindingData(tracking: data)
            } else {
                cell.bindingData(tracking: nil)
            }
        case .safesearch:
            if let data = model.children[indexPath.row] as? SafeSearchModel {
                cell.bindingData(safeSearch: data)
            } else {
                cell.bindingData(safeSearch: nil)
            }
        default:
            cell.bindingData(safeSearch: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = GroupSettingHeaderView.loadFromNib()
        headerView?.binding(data: sources[section])
        headerView?.switchChangeValue = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
        return headerView
    }
}

