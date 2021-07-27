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
    var listBlockVC: GroupListBlockVC!
    var settingVC: GroupSettingVC!
    
    var onUpdateGroup:(() -> Void)?
    
    init(group: GroupModel, type: GroupSettingParentEnum) {
        self.group = group
        self.type = type
        super.init(nibName: GroupDetailVC.className, bundle: nil)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        listBlockVC = GroupListBlockVC(group: group, type: type)
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
        self.addPageMenu(menu: CAPSPageMenu(viewControllers: subPageControllers, frame: CGRect(x: 0, y: 0, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height), pageMenuOptions: parameters))
        self.pageMenuController!.delegate = self

        self.headerBackgroundColor = UIColor.white
        self.navBarColor = UIColor.white
    }
    
    func configBarItem() {
        title = type.getTitle()
    }
    
    func updateGroup() {
        showLoading()
        GroupWorker.update(group: group) { [weak self] (group, error) in
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
