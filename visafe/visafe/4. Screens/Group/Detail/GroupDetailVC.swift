//
//  GroupDetailVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/19/21.
//

import UIKit
import PageMenu
import SwiftMessages

class GroupDetailVC: HeaderedPageMenuScrollViewController, CAPSPageMenuDelegate {
    
    var subPageControllers: [UIViewController] = []
    var header: GroupDetailHeader!
    var group: GroupModel
    var timeType: ChooseTimeEnum = .day
    var statisticVC: GroupStatisticVC!
    var settingVC: GroupSettingDetailVC!
    var statisticModel: StatisticModel = StatisticModel()
    var pageMenu: CAPSPageMenu!
    var isSet = false
    
    var updateGroup:(() -> Void)?
    
    init(group: GroupModel) {
        self.group = group
        super.init(nibName: GroupDetailVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBarItem()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isSet {
            isSet = true
            pageMenu.view.frame = CGRect(x: 0, y: 0, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height)
            statisticVC.view.frame = CGRect(x: 0, y: 56, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height - 56)
            settingVC.view.frame = CGRect(x: 0, y: 56, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height - 56)
        }
    }
    
    func refreshData() {
        GroupWorker.getGroup(id: group.groupid!) { [weak self] (group, error, responseCode) in
            guard let weakSelf = self else { return }
            if let g = group {
                weakSelf.group = g
                weakSelf.header.bindingData(group: weakSelf.group)
            }
        }
    }
    
    func configView() {
        header = GroupDetailHeader.loadFromNib()
        header.bindingData(group: group)
        header.viewMemberAction = { [weak self] in
            guard let weakSelf = self else { return }
            let vc = GroupListUserVC(group: weakSelf.group)
            vc.onUpdate = {
                weakSelf.refreshData()
            }
            weakSelf.navigationController?.pushViewController(vc)
        }
        header.viewDeviceAction = { [weak self] in
            guard let weakSelf = self else { return }
            let vc = GroupListDeviceVC(group: weakSelf.group)
            vc.onUpdate = {
                weakSelf.refreshData()
            }
            weakSelf.navigationController?.pushViewController(vc)
        }
        header.addDeviceAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.addDevice()
        }
        header.addMemberAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.addMember()
        }
        
        // 1) Set the header
        self.headerView = header
        
        // 2) Set the subpages
        statisticVC = GroupStatisticVC(group: group)
        statisticVC.timeType = timeType
        statisticVC.title = "Thống kê"
        statisticVC.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        statisticVC.view.backgroundColor = .white
        addChild(statisticVC)
        subPageControllers.append(statisticVC)
        statisticVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        
        settingVC = GroupSettingDetailVC(group: group)
        statisticModel.timeType = timeType
        settingVC.statisticModel = statisticModel
        settingVC.parentVC = self
        settingVC.title = "Thiết lập bảo vệ"
        settingVC.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        settingVC.view.backgroundColor = .white
        addChild(settingVC)
        subPageControllers.append(settingVC)
        settingVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        
        let parameters: [CAPSPageMenuOption] = [
            .selectionIndicatorHeight(3),
            .selectionIndicatorColor(UIColor.mainColorOrange()),
            .menuItemWidth(kScreenWidth/2),
            .viewBackgroundColor(.white),
            .menuItemFont(UIFont.systemFont(ofSize: 16, weight: .semibold)),
            .menuHeight(56),
            .selectedMenuItemLabelColor(.black),
            .unselectedMenuItemLabelColor(UIColor(hexString: "222222")!),
            .menuMargin(0),
            .scrollMenuBackgroundColor(.white)
        ]
        pageMenu = CAPSPageMenu(viewControllers: subPageControllers, frame: CGRect(x: 0, y: 0, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height), pageMenuOptions: parameters)
        self.addPageMenu(menu: pageMenu)
        self.pageMenuController!.delegate = self

        self.navBarColor = UIColor.white
        self.headerBackgroundColor = UIColor.white
        self.navBarItemsColor = UIColor.black
        self.navBarTransparancy = 1.0
    }
    
    func addDevice() {
        let vc = AddDeviceToGroupVC(group: group)
        vc.addDevice = { [weak self] device in
            guard let weakSelf = self else { return }
            weakSelf.group.devicesGroupInfo.append(device)
            weakSelf.header.bindingData(group: weakSelf.group)
        }
        present(vc, animated: true)
    }
    
    func addMember() {
        let vc = InviteMemberToGroupVC(group: group)
        vc.onDone = { [weak self] user in
            guard let strongSelf = self else { return }
            strongSelf.group.usersGroupInfo.append(user)
            strongSelf.header.bindingData(group: strongSelf.group)
        }
        navigationController?.pushViewController(vc)
    }
    
    
    
    func configBarItem() {
        // left
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "cancel_icon"), style: .done, target: self, action: #selector(onClickLeftButton))
        navigationItem.leftBarButtonItem = leftBarButton
        
        // right
        let notifiBarButton = UIBarButtonItem(image: UIImage(named: "more_icon"), style: .done, target: self, action: #selector(onClickMoreButton))
        navigationItem.rightBarButtonItem = notifiBarButton
    }
    
    @objc private func onClickLeftButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func onClickMoreButton() {
        guard let view = MoreActionView.loadFromNib() else { return }
        view.binding(title: group.name ?? "", type: .group)
        view.deleteAction = { [weak self] in
            guard let weakSelf = self else { return }
            if weakSelf.group.groupid == CacheManager.shared.getCurrentUser()?.defaultGroup {
                weakSelf.view.makeToast("Bạn không được phép xoá nhóm mặc định")
                return
            }
            Timer.scheduledTimer(timeInterval: 0.3, target: weakSelf, selector:#selector(weakSelf.deleteGroup(sender:)), userInfo: weakSelf.group , repeats:false)
        }
        view.editAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.editGroup()
        }
        showPopup(view: view)
    }
    
    func editGroup() {
        let vc = PostGroupVC(group: group)
        vc.onDone = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.refreshData()
            weakSelf.updateGroup?()
        }
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    @objc func deleteGroup(sender: Timer) {
        guard let group = sender.userInfo as? GroupModel else { return }
        showConfirmDelete(title: "Bạn có chắc chắn muốn xoá nhóm \(group.name ?? "") không?") { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.deleteGroupAction(group: group)
        }
    }
    
    func deleteGroupAction(group: GroupModel) {
        guard let groupId = group.groupid else { return }
        guard let userId = CacheManager.shared.getCurrentUser()?.userid else { return }
        showLoading()
        GroupWorker.delete(groupId: groupId, userId: userId) { [weak self] (result, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.updateGroup?()
            weakSelf.dismiss(animated: true, completion: nil)
        }
    }
}
