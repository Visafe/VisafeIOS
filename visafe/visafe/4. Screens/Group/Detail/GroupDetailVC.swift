//
//  GroupDetailVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/19/21.
//

import UIKit
import PageMenu

class GroupDetailVC: HeaderedPageMenuScrollViewController, CAPSPageMenuDelegate {
    
    var subPageControllers: [UIViewController] = []
    var header: GroupDetailHeader!
    var group: GroupModel
    var timeType: ChooseTimeEnum = .day
    let vc1: GroupStatisticVC!
    let vc2: GroupSettingDetailVC!
    
    init(group: GroupModel) {
        self.group = group
        self.vc1 = GroupStatisticVC(group: group)
        self.vc2 = GroupSettingDetailVC(group: group)
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
        header = GroupDetailHeader.loadFromNib()
        header.bindingData(group: group)
        header.viewMemberAction = { [weak self] in
            guard let weakSelf = self else { return }
            let vc = GroupListUserVC(group: weakSelf.group)
            weakSelf.navigationController?.pushViewController(vc)
        }
        // 1) Set the header
        self.headerView = header
        
        // 2) Set the subpages
        let vc = GroupStatisticVC(group: group)
        vc.timeType = timeType
        vc.title = "Thống kê"
        vc.view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: self.view.bounds.height)
        vc.view.backgroundColor = .white
        addChild(vc)
        subPageControllers.append(vc)
        vc.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        
        let vc2 = GroupSettingDetailVC(group: group)
        vc2.parentVC = self
        vc2.title = "Thiết lập bảo vệ"
        vc2.view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: self.view.bounds.height)
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
        self.addPageMenu(menu: CAPSPageMenu(viewControllers: subPageControllers, frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: pageMenuContainer.frame.height), pageMenuOptions: parameters))
        self.pageMenuController!.delegate = self

        self.headerBackgroundColor = UIColor.white
        self.navBarItemsColor = UIColor.black
        self.navBarTransparancy = 1.0
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
        dismiss(animated: true, completion: nil)
    }
}
