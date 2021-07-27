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
    
    override func viewDidLoad() {
        self.headerHeight = kScreenWidth * 180 / 375
        super.viewDidLoad()
        configUI()
    }
    
    func configUI() {
        tabScrollView.tabSectionHeight = 0
        
        // 1) Header init
        let imageview = UIImageView(image: UIImage(named: "wsp_family"))
        imageview.contentMode = .scaleToFill
        self.headerView = imageview
        
        // 2) Minimal ACTabScrollView initialisation
        
        self.tabScrollView.dataSource = self
        self.tabScrollView.delegate = self
        let vc = GroupVC()
        vc.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        addChild(vc)
        subPageViews.append(vc.view)
        vc.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        
        self.navBarColor = .white
        self.navBarItemsColor = UIColor.black
        self.navBarTitleColor = UIColor.black.withAlphaComponent(0) // At first, the navbar's title is transparent (update according to scroll prosition)
//        self.setNavBarTitle(title: CacheManager.shared.getCurrentWorkspace()?.name ?? "")
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
