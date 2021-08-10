//
//  ProtectVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit

class ProtectVC: BaseDoHVC {
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
    @IBOutlet weak var protectAdAndFollowStackView: UIStackView!
    @IBOutlet weak var protectAdStatusButton: UIButton!
    @IBOutlet weak var protectFollowStatusButton: UIButton!
    @IBOutlet weak var protectDeviceStatusButton: UIButton!
    @IBOutlet weak var protectWifiStatusButton: UIButton!
    var statisticModel: StatisticModel? {
        didSet {
            bindingStatistic()
        }
    }
    var groupModel: GroupModel? {
        didSet {
            bindingProtectStatus()
        }
    }

    var isProtectAd = false {
        didSet {
            if oldValue != isProtectAd {
                let image = isProtectAd ? UIImage(named: "Switch_on"): UIImage(named: "Switch_off")
                protectAdStatusButton.setImage(image, for: .normal)
            }
        }
    }

    var isProtectFollow = false {
        didSet {
            if oldValue != isProtectFollow {
                let image = isProtectFollow ? UIImage(named: "Switch_on"): UIImage(named: "Switch_off")
                protectFollowStatusButton.setImage(image, for: .normal)
            }
        }
    }

    var isProtectWifi = false {
        didSet {
            if oldValue != isProtectWifi {
                CacheManager.shared.setProtectWifiStatus(value: isProtectWifi)
                let image = isProtectWifi ? UIImage(named: "Switch_on"): UIImage(named: "Switch_off")
                protectWifiStatusButton.setImage(image, for: .normal)
            }
        }
    }

    var isProtectDevice = false {
        didSet {
            if oldValue != isProtectDevice {

                let image = isProtectDevice ? UIImage(named: "Switch_on"): UIImage(named: "Switch_off")
                protectDeviceStatusButton.setImage(image, for: .normal)
            }
        }
    }

    lazy var dispatchGroup = DispatchGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
        prepareData()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateProtectDevice),
                                               name: NSNotification.Name(rawValue: updateDnsStatus),
                                               object: nil)
        isProtectWifi = CacheManager.shared.getProtectWifiStatus()
        isProtectDevice = DoHNative.shared.isEnabled
        
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
        let isLogin = CacheManager.shared.getIsLogined()
        protectAdAndFollowStackView.isHidden = !isLogin
        overView.isHidden = !isLogin
        protectFamilyView.isHidden = !isLogin
        registerInfoView.isHidden = !isLogin
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
        dispatchGroup.enter()
        dispatchGroup.enter()
        GroupWorker.getGroup(id: groupId) { [weak self] (group, error) in
            guard let self = self else { return }
            self.groupModel = group
            self.dispatchGroup.leave()
        }

        GroupWorker.getStatistic(grId: groupId,
                                 limit: timeType.rawValue) { [weak self] (statistic, error) in
            guard let self = self else { return }
            self.statisticModel = statistic
            self.dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.hideLoading()
        }
    }

    private func bindingStatistic() {
        blockedLabel.text = "\(statisticModel?.num_ads_blocked ?? 0)"
        violationLabel.text = "\(statisticModel?.num_violation ?? 0)"
        dangerousLabel.text = "\(statisticModel?.num_dangerous_domain ?? 0)"
    }

    private func bindingProtectStatus() {
        isProtectAd = groupModel?.getState(type: .ads_blocked) ?? false
        isProtectFollow = groupModel?.getState(type: .native_tracking) ?? false
    }

    @objc private func updateProtectDevice() {
        isProtectDevice = DoHNative.shared.isEnabled
    }

    private func updateGroup() {
        guard let group = groupModel else {
            return
        }
        showLoading()
        GroupWorker.update(group: group) { [weak self] (group, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            if error == nil {
                weakSelf.bindingProtectStatus()
            }
        }
    }

    override func showAnimationLoading() {
        showLoading()
    }

    override func hideAnimationLoading() {
        hideLoading()
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
}

// MARK: Action
extension ProtectVC {
    @IBAction func scanAction(_ sender: Any) {
        guard checkLoginState() else { return }
        setSafeMode(isTrue: false)
    }

    @IBAction func showProtectDevice(_ sender: Any) {
        guard checkLoginState() else { return }
        guard let statistic = statisticModel,
              let group = groupModel else { return }
        let vc = ProtectDeviceVC(group: group,
                                 statistic: statistic,
                                 type: .device)
        self.navigationController?.pushViewController(vc)
    }

    @IBAction func showProtectWifi(_ sender: Any) {
        guard checkLoginState() else { return }
        guard let statistic = statisticModel,
              let group = groupModel else { return }
        let vc = ProtectDeviceVC(group: group,
                                 statistic: statistic,
                                 type: .wifi)
        self.navigationController?.pushViewController(vc)
    }

    @IBAction func showProtectAds(_ sender: Any) {
        gotoGroupProtect(.ads_blocked)
    }

    @IBAction func showProtectFolow(_ sender: Any) {
        gotoGroupProtect(.native_tracking)
    }

    private func gotoGroupProtect(_ type: GroupSettingParentEnum) {
        guard let statistic = statisticModel,
              let group = groupModel else { return }
        let vc = GroupProtectVC(group: group, type: type)
        vc.statisticModel = statistic
        vc.onUpdateGroup = bindingProtectStatus
        self.navigationController?.pushViewController(vc)
    }

    @IBAction func onOffProtectDevice(_ sender: Any) {
        onOffDoH()
    }

    @IBAction func onOffProtectWifi(_ sender: Any) {
        isProtectWifi = !isProtectWifi
    }

    @IBAction func onOffProtectAd(_ sender: Any) {
        let status = !isProtectAd

        if status {
            groupModel?.setDefault(type: .ads_blocked)
        } else {
            groupModel?.disable(type: .ads_blocked)
        }
        updateGroup()
    }

    @IBAction func onOffProtectTracking(_ sender: Any) {
        let status = !isProtectFollow

        if status {
            groupModel?.setDefault(type: .native_tracking)
        } else {
            groupModel?.disable(type: .native_tracking)
        }
        updateGroup()
    }

    @IBAction func addVPN(_ sender: Any) {

    }

    @IBAction func reportFake(_ sender: Any) {

    }

    @IBAction func createGroup(_ sender: Any) {

    }

    @IBAction func createSecurity(_ sender: Any) {

    }
    
    @IBAction func upgradeNow(_ sender: Any) {

    }
}
