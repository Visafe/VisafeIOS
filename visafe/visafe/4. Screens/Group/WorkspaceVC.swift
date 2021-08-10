//
//  WorkspaceVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//
import UIKit
import ACTabScrollView

class WorkspaceVC: HeaderedACTabScrollViewController, ACTabScrollViewDelegate,  ACTabScrollViewDataSource {
    
    var subPageViews: [UIView] = []
    var imageview: UIImageView!
    let groupVC = GroupVC()
    
    override func viewDidLoad() {
        self.headerHeight = kScreenWidth * 180 / 375
        super.viewDidLoad()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configUI() {
        tabScrollView.tabSectionHeight = 0
        
        // 1) Header init
        imageview = UIImageView(image: UIImage(named: "wsp_family"))
        if let workspace = CacheManager.shared.getCurrentWorkspace(), workspace.type == .enterprise {
            imageview.image = UIImage(named: "wsp_enterprise")
        } else {
            imageview.image = UIImage(named: "wsp_family")
        }
        imageview.contentMode = .scaleToFill
        self.headerView = imageview
        
        // 2) Minimal ACTabScrollView initialisation
        self.tabScrollView.dataSource = self
        self.tabScrollView.delegate = self
        groupVC.selectedWorkspace = { [weak self] workspace in
            guard let weakSelf = self else { return }
            weakSelf.updateViewWithWsp(wsp: workspace)
        }
        groupVC.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        addChild(groupVC)
        subPageViews.append(groupVC.view)
        groupVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        
        self.navBarColor = .white
        self.navBarItemsColor = UIColor.black
        self.navBarTitleColor = UIColor.black.withAlphaComponent(0)
    }
    
    func updateViewWithWsp(wsp: WorkspaceModel?) {
        if let workspace = CacheManager.shared.getCurrentWorkspace(), workspace.type == .enterprise {
            imageview.image = UIImage(named: "wsp_enterprise")
        } else {
            imageview.image = UIImage(named: "wsp_family")
        }
    }
    
    // ACTabScrollViewDelegate & ACTabScrollViewDataSource
    // ----------------------------------------------------
    
    func tabScrollView(_ tabScrollView: ACTabScrollView, didChangePageTo index: Int) {
        print("didChangePageTo \(index)")
    }
    
    func tabScrollView(_ tabScrollView: ACTabScrollView, didScrollPageTo index: Int) {
        print("didScrollPageTo \(index)")
    }
    
    func numberOfPagesInTabScrollView(_ tabScrollView: ACTabScrollView) -> Int {
        return 1
    }
    
    func tabScrollView(_ tabScrollView: ACTabScrollView, tabViewForPageAtIndex index: Int) -> UIView {
        return UIView()
    }
    
    func tabScrollView(_ tabScrollView: ACTabScrollView, contentViewForPageAtIndex index: Int) -> UIView {
        return subPageViews[index]
    }
}
