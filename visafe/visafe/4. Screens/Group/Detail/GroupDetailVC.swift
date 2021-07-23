//
//  GroupDetailVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/19/21.
//

import UIKit
import MXParallaxHeader
import MXSegmentedPager

class GroupDetailVC: MXSegmentedPagerController {

    var headerView: GroupDetailHeader!
    var group: GroupModel
    
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
        configHeader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func configHeader() {
        headerView = GroupDetailHeader.loadFromNib()
        headerView.bindingData()
        segmentedPager.parallaxHeader.view = headerView
        segmentedPager.parallaxHeader.height = 410
        segmentedPager.parallaxHeader.mode = .top
        segmentedPager.parallaxHeader.minimumHeight = view.safeAreaInsets.top + 64
        
        // Segmented Control customization
        segmentedPager.segmentedControl.indicator.linePosition = .bottom
        segmentedPager.segmentedControl.textColor = UIColor(hexString: "222222")!
        segmentedPager.segmentedControl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        segmentedPager.segmentedControl.selectedTextColor = UIColor.black
        segmentedPager.segmentedControl.indicator.lineView.backgroundColor = UIColor.mainColorOrange()
        segmentedPager.backgroundColor = UIColor.white
        segmentedPager.segmentedControl.backgroundColor = UIColor.white
    }
    
    override func viewSafeAreaInsetsDidChange() {
        segmentedPager.parallaxHeader.minimumHeight = view.safeAreaInsets.top + 64
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
    
    override func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return 2
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["Thống kê", "Thiết lập bảo vệ"][index]
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        print(1)
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, viewControllerForPageAt index: Int) -> UIViewController {
        if index == 0 {
            return vc1
        } else {
            return vc2
        }
    }
    
    override func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 48
    }
}
