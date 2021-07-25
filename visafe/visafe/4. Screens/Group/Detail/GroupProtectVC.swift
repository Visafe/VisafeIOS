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
    var vc1: GroupListBlockVC!
    var vc2: GroupSettingVC!
    
    init(group: GroupModel, type: GroupSettingParentEnum) {
        self.group = group
        self.type = type
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func configView() {
        header = ProtectHeaderView.loadFromNib()
        header.bindingData(type: type)
        // 1) Set the header
        self.headerView = header
        
        // 2) Set the subpages
        let vc = GroupListBlockVC(group: group, type: type)
        vc.title = "Quảng cáo đã chặn"
        vc.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        vc.view.backgroundColor = .white
        addChild(vc)
        subPageControllers.append(vc)
        vc.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        
        let vc2 = GroupSettingVC(group: group, editMode: .update, parentType: type)
        vc2.title = "Thiết lập chặn"
        vc2.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        vc2.view.backgroundColor = .white
        addChild(vc2)
        subPageControllers.append(vc2)
        vc2.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        
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
}
