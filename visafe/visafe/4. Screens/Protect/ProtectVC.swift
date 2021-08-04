//
//  ProtectVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit

class ProtectVC: BaseViewController {
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
    private func checkLoginState() -> Bool {
        let isLogin = CacheManager.shared.getIsLogined()
        if !isLogin  {
            showFormLogin()
            return false
        } else {
            return true
        }
    }

    private func showFormLogin() {
        let vc = LoginVC()
        present(vc, animated: true)
    }

    private func getProtectData() -> (group: GroupModel,
                                      statistic: StatisticModel)? {
        guard let wsp = CacheManager.shared.getCurrentWorkspace() else { return nil }
        guard let groupId = wsp.groupIds?[safe: 0] else { return nil }
        let group = GroupModel()
        group.groupid = groupId
        return (group, statisticModel)
    }

    @IBAction func scanAction(_ sender: Any) {
        guard checkLoginState() else { return }
        setSafeMode(isTrue: false)
    }

    @IBAction func showProtectDevice(_ sender: Any) {
        guard checkLoginState() else { return }
        guard let data = getProtectData() else { return }
        let vc = ProtectDeviceVC(group: data.group,
                                 statistic: data.statistic,
                                 type: .device)
        self.navigationController?.pushViewController(vc)
    }

    @IBAction func showProtectWifi(_ sender: Any) {
        guard checkLoginState() else { return }
        guard let data = getProtectData() else { return }
        let vc = ProtectDeviceVC(group: data.group,
                                 statistic: data.statistic,
                                 type: .wifi)
        self.navigationController?.pushViewController(vc)
    }

    @IBAction func showProtectAds(_ sender: Any) {
        guard checkLoginState() else { return }
        guard let data = getProtectData() else { return }
        let vc = GroupProtectVC(group: data.group, type: .ads_blocked)
        vc.statisticModel = data.statistic
        self.navigationController?.pushViewController(vc)
    }

    @IBAction func showProtectFolow(_ sender: Any) {
        guard checkLoginState() else { return }
        guard let data = getProtectData() else { return }
        let vc = GroupProtectVC(group: data.group, type: .native_tracking)
        vc.statisticModel = data.statistic
        self.navigationController?.pushViewController(vc)
    }
}


// MARK: Action
extension ProtectVC {
    // layout subview when hide/unhide item in detail view
    private func updateOverViewLayout() {
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
