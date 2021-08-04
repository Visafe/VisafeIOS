//
//  ProtectDeviceVC.swift
//  visafe
//
//  Created by QuocNV on 8/3/21.
//

import UIKit
import PageMenu

class ProtectDeviceVC: HeaderedPageMenuScrollViewController, CAPSPageMenuDelegate {
    var subPageControllers: [UIViewController] = []
    var header: ProtectHomeHeaderView!
    var type: ProtectHomeType
    var listBlockVC: ProtectDetailListBlockVC!

    var onUpdateGroup:(() -> Void)?

    init(type: ProtectHomeType) {
        self.type = type
        super.init(nibName: GroupDetailVC.className, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.headerHeight = 275
        super.viewDidLoad()
        configBarItem()
        configView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    func configView() {
        header = ProtectHomeHeaderView.loadFromNib()
        header.bindingData(type: type)
        header.switchValueChange = { [weak self] isOn in
            guard let weakSelf = self else { return }
//            if isOn {
//                weakSelf.group.setDefault(type: weakSelf.type)
//            } else {
//                weakSelf.group.disable(type: weakSelf.type)
//            }
//            weakSelf.updateGroup()
        }

        // 1) Set the header
        self.headerView = header

        // 2) Set the subpages
        listBlockVC = ProtectDetailListBlockVC(type: type)
        listBlockVC.title = type.getTitleContentView()
        listBlockVC.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        listBlockVC.view.backgroundColor = .white
        addChild(listBlockVC)
        subPageControllers.append(listBlockVC)
//        listBlockVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemWidth(kScreenWidth),
            .viewBackgroundColor(.white),
            .menuItemFont(UIFont.systemFont(ofSize: 16, weight: .semibold)),
            .menuHeight(56),
            .selectedMenuItemLabelColor(.black),
            .unselectedMenuItemLabelColor(UIColor(hexString: "222222")!),
            .menuMargin(0),
            .centerMenuItems(false),
            .scrollMenuBackgroundColor(.white)
        ]
        self.addPageMenu(menu: CAPSPageMenu(viewControllers: subPageControllers, frame: CGRect(x: 0, y: 0, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height), pageMenuOptions: parameters))
        self.pageMenuController!.delegate = self

//        self.headerBackgroundColor = UIColor.white
//        self.navBarColor = UIColor.white
    }

    func configBarItem() {
        title = type.getTitle()
        navigationController?.title = type.getTitle()
    }
}
