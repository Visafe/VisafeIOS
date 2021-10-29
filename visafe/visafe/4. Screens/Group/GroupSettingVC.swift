//
//  GroupSettingVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit
import SwiftMessages

class GroupSettingVC: BaseViewController {

    var group: GroupModel
    var editMode: EditModeEnum
    var sources: [PostGroupModel] = []
    var parentType: GroupSettingParentEnum
    var scrollDelegateFunc:((UIScrollView)->Void)?
    var continueAction:(() -> Void)?
    
    @IBOutlet weak var tableView: UITableView!
    
    init(group: GroupModel, editMode: EditModeEnum, parentType: GroupSettingParentEnum) {
        self.group = group
        self.editMode = editMode
        self.parentType = parentType
        super.init(nibName: GroupSettingVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        prepareData()
    }
    
    func configView() {
        navigationItem.title = parentType.getTitleNavi()
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 25
        tableView.registerCells(cells: [GroupSettingCell.className, GroupSettingLinkCell.className])
    }
    
    func prepareData() {
        sources = group.buildSource(type: parentType)
        tableView.reloadData()
    }
    
    
    @IBAction func resetDefaultAction(_ sender: Any) {
        group.setDefault(type: parentType)
        sources = group.buildSource(type: parentType)
        tableView.reloadData()
    }
    
    @IBAction func continueActionButton(_ sender: Any) {
        group.bindingData(sources: sources)
        if let action = continueAction {
            action()
        } else {
            navigationController?.popViewController()
        }
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
        if model.type == .website {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupSettingLinkCell.className) as? GroupSettingLinkCell else {
                return UITableViewCell()
            }
            if let link = model.children[indexPath.row] as? String {
                cell.binding(link: link)
                cell.moreAction = { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.moreLinkAction(link: link, index: indexPath.row)
                }
            }
            return cell
        } else {
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let model = sources[section]
        if model.type == .website && (model.isSelected == true) {
            let viewFooter = GroupSettingFooterView.loadFromNib()
            viewFooter?.onClickAddLink = { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.handleActionAddLink()
            }
            return viewFooter
        } else {
            return UIView()
        }
    }
    
    func moreLinkAction(link: String, index: Int) {
        guard let view = MoreLinkSettingView.loadFromNib() else { return }
        view.binding(name: link)
        view.editAction = { [weak self] in
            guard let weakSelf = self else { return }
            var dic: [String: Any] = [:]
            dic["link"] = link
            dic["index"] = index
            Timer.scheduledTimer(timeInterval: 0.3, target: weakSelf, selector:#selector(weakSelf.editLinkAction(sender:)), userInfo: dic , repeats:false)
        }
        view.deleteAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.removeLink(index: index)
        }
        showPopup(view: view)
    }
    
    @objc func editLinkAction(sender: Timer) {
        guard let view = BaseEnterValueView.loadFromNib() else { return }
        guard let dic = sender.userInfo as? [String: Any] else { return }
        view.bindingData(type: .link, name: group.name)
        let link = dic["link"] as? String ?? ""
        let index = dic["index"] as? Int ?? 0
        view.enterTextfield.text = link
        view.acceptAction = { [weak self] link in
            guard let weakSelf = self else { return }
            guard let linkAddress = link else { return }
            weakSelf.handleEditlink(link: linkAddress, index: index)
        }
        showPopup(view: view)
    }
    
    func handleEditlink(link: String, index: Int) {
        for item in sources {
            if item.type == .website {
                item.children[index] = link
            }
        }
        tableView.reloadData()
    }
    
    func removeLink(index: Int) {
        for item in sources {
            if item.type == .website {
                if item.children.count >= index {
                    item.children.remove(at: index)
                    tableView.reloadData()
                }
                return
            }
        }
    }
    
    func handleActionAddLink() {
        guard let view = BaseEnterValueView.loadFromNib() else { return }
        view.bindingData(type: .link, name: group.name)
        view.acceptAction = { [weak self] link in
            guard let weakSelf = self else { return }
            guard let linkAddress = link else { return }
            weakSelf.handleAddlink(link: linkAddress)
        }
        showPopup(view: view)
    }
    
    func handleAddlink(link: String) {
        guard let postModel = sources.filter({ (post) -> Bool in
            return post.type == .website
        }).first else { return }
        var listAddress: [String] = postModel.children as? [String] ?? []
        listAddress.append(link)
        postModel.children = listAddress
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let model = sources[section]
        if model.type == .website {
            return 56.0000
        } else {
            return 0.0001
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = sources[section]
        if model.type == .website {
            let headerView = GroupWebsiteSettingHeaderView.loadFromNib()
            headerView?.binding(type: group.websiteType)
            headerView?.onChangeTab = { type in
                self.group.bindingData(sources: self.sources)
                self.group.websiteType = type
                self.prepareData()
            }
            return headerView
        } else {
            let headerView = GroupSettingHeaderView.loadFromNib()
            headerView?.binding(data: sources[section])
            headerView?.switchChangeValue = { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.tableView.reloadData()
            }
            return headerView
        }
    }
}

extension GroupSettingVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollDelegateFunc != nil {
            self.scrollDelegateFunc!(scrollView)
        }
    }
}

