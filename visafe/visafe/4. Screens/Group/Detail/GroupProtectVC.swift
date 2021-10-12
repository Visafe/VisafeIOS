//
//  GroupProtectVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/24/21.
//

import UIKit

import UIKit
import PageMenu

class GroupProtectVC: HeaderedPageMenuScrollViewController, CAPSPageMenuDelegate {
    
    var subPageControllers: [UIViewController] = []
    var header: ProtectHeaderView!
    var group: GroupModel
    var type: GroupSettingParentEnum
    var listBlockVC: GroupListLogVC!
    var settingVC: GroupSettingVC!
    var statisticModel: StatisticModel!
    var pageMenu: CAPSPageMenu!
    var isSet = false
    
    var onUpdateGroup:(() -> Void)?
    
    init(group: GroupModel, type: GroupSettingParentEnum) {
        self.group = group
        self.type = type
        super.init(nibName: GroupDetailVC.className, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.headerHeight = 253
        super.viewDidLoad()
        configBarItem()
        configView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isSet {
            isSet = true
            pageMenu.view.frame = CGRect(x: 0, y: 0, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height)
            listBlockVC.view.frame = CGRect(x: 0, y: 56, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height - 56)
            settingVC.view.frame = CGRect(x: 0, y: 56, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height - 56)
        }
    }
    
    func configView() {
        header = ProtectHeaderView.loadFromNib()
        header.bindingData(type: type)
        header.updateState(isOn: group.getState(type: type))
        header.switchValueChange = { [weak self] isOn in
            guard let weakSelf = self else { return }
            if isOn {
                weakSelf.group.setDefault(type: weakSelf.type)
            } else {
                weakSelf.group.disable(type: weakSelf.type)
            }
            weakSelf.updateGroup()
        }
        
        // 1) Set the header
        self.headerView = header
        
        // 2) Set the subpages
        listBlockVC = GroupListLogVC(group: group, statistic: statisticModel, type: type)
        listBlockVC.title = "Quảng cáo đã chặn"
        listBlockVC.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        listBlockVC.view.backgroundColor = .white
        addChild(listBlockVC)
        subPageControllers.append(listBlockVC)
        listBlockVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        
        settingVC = GroupSettingVC(group: group, editMode: .update, parentType: type)
        settingVC.continueAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.updateGroup()
        }
        settingVC.title = "Thiết lập chặn"
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

        self.headerBackgroundColor = UIColor.white
        self.navBarColor = UIColor.white
    }
    
    func configBarItem() {
        title = type.getTitle()
    }
    
    func updateGroup() {
        showLoading()
        GroupWorker.update(group: group) { [weak self] (group, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            if error == nil {
                weakSelf.header.updateState(isOn: weakSelf.group.getState(type: weakSelf.type))
                weakSelf.settingVC.prepareData()
                weakSelf.onUpdateGroup?()
            }
        }
    }
}
