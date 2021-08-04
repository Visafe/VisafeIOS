//
//  ProtectVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit

class ProtectVC: BaseViewController {
    @IBOutlet weak var heightViewConstant: NSLayoutConstraint!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var blockedLabel: UILabel!
    @IBOutlet weak var violationLabel: UILabel!
    @IBOutlet weak var dangerousLabel: UILabel!
    // item of detail view
    @IBOutlet weak var detailView: UIStackView!
    @IBOutlet weak var vpnView: UIView!
    @IBOutlet weak var pakeWebView: UIView!
    @IBOutlet weak var protectFamilyView: UIView!
    @IBOutlet weak var securityView: UIView!
    @IBOutlet weak var registerInfoView: UIView!
    @IBOutlet weak var otherView: UIView!
    var statisticModel = StatisticModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
        prepareData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    private func setupUI() {
        setSafeMode()
        contentView.dropShadowEdge()
        overView.dropShadowEdge()
        vpnView.dropShadowEdge()
        pakeWebView.dropShadowEdge()
        protectFamilyView.dropShadowEdge()
        securityView.dropShadowEdge()
        registerInfoView.dropShadowEdge()
        otherView.dropShadowEdge()
    }

    private func setSafeMode(isTrue: Bool = true) {
        let font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let highlightColor: UIColor = isTrue ? .systemGreen : .systemRed
        let text = isTrue ? "Bạn đang an toàn" : "Đã phát hiện 1 sự cố"
        let highlightText = isTrue ? "an toàn" : "1 sự cố"

        let attributedText = NSMutableAttributedString(string: text, attributes: [.font : font,
                                                                                  .foregroundColor: highlightColor])
        attributedText.addAttributes([.font : font,
                                      .foregroundColor: UIColor.white],
                                     range: NSRange(location: 0,
                                                    length: text.count - highlightText.count))
        titleLB.attributedText = attributedText
    }

    func prepareData() {
        let timeType: ChooseTimeEnum = .day
        guard let wsp = CacheManager.shared.getCurrentWorkspace() else { return }
        guard let groupId = wsp.groupIds?[safe: 0] else { return }
        showLoading()
        GroupWorker.getStatistic(grId: groupId,
                                 limit: timeType.rawValue) { [weak self] (statistic, error) in
            guard let self = self else { return }
            self.hideLoading()
            if let model = statistic {
                self.bindingData(model)
            }
        }
    }

    private func bindingData(_ statistic: StatisticModel) {
        statisticModel = statistic
        blockedLabel.text = "\(statistic.num_ads_blocked)"
        violationLabel.text = "\(statistic.num_violation)"
        dangerousLabel.text = "\(statistic.num_dangerous_domain)"
    }

}
// MARK: Action in content
extension ProtectVC {

    @IBAction func scanAction(_ sender: Any) {
        setSafeMode(isTrue: false)
    }

    @IBAction func switchProtectDevice(_ sender: Any) {
        let vc = ProtectDeviceVC(type: .device)
        self.navigationController?.pushViewController(vc)
    }

    @IBAction func switchProtectWifi(_ sender: Any) {
        let vc = ProtectDeviceVC(type: .wifi)
        self.navigationController?.pushViewController(vc)
    }

    @IBAction func switchProtectAds(_ sender: Any) {
        guard let wsp = CacheManager.shared.getCurrentWorkspace() else { return }
        guard let groupId = wsp.groupIds?[safe: 0] else { return }
        let group = GroupModel()
        group.groupid = groupId
        let vc = GroupProtectVC(group: group, type: .ads_blocked)
        vc.statisticModel = statisticModel
        self.navigationController?.pushViewController(vc)
    }

    @IBAction func switchProtectFolow(_ sender: Any) {
        guard let wsp = CacheManager.shared.getCurrentWorkspace() else { return }
        guard let groupId = wsp.groupIds?[safe: 0] else { return }
        let group = GroupModel()
        group.groupid = groupId
        let vc = GroupProtectVC(group: group, type: .native_tracking)
        vc.statisticModel = statisticModel
        self.navigationController?.pushViewController(vc)
    }
}


// MARK: Action
extension ProtectVC {
    // layout subview when hide/unhide item in detail view
    private func updateOverViewLayout() {
        var heightDetailView: CGFloat = 30 // space bottom
        //header view
        heightDetailView += 175
        heightDetailView += 20
        //Content view
        heightDetailView += 300
        heightDetailView += 20

        //Over view
        heightDetailView += 200
        heightDetailView += 20

        //Detail view
        heightDetailView += 20
        let unHidenViews = [vpnView,
         pakeWebView,
         protectFamilyView,
         securityView
        ].filter { $0.isHidden == false }
        let count = unHidenViews.count
        heightDetailView += CGFloat(count * 150 + (count - 1)  * 20)
        heightDetailView += 275
        heightDetailView += 300 + 20
        heightViewConstant.constant = heightDetailView
        detailView.layoutIfNeeded()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    @IBAction func addVPN(_ sender: Any) {
        updateOverViewLayout()
    }

    @IBAction func reportFake(_ sender: Any) {
        updateOverViewLayout()
    }

    @IBAction func createGroup(_ sender: Any) {

    }

    @IBAction func createSecurity(_ sender: Any) {

    }
    
    @IBAction func upgradeNow(_ sender: Any) {

    }

    @IBAction func registerNow(_ sender: Any) {

    }
}
