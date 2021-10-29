//
//  ProtectVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit
import SwifterSwift
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
    @IBOutlet weak var lastScanLabel: UILabel!
    @IBOutlet weak var timeTypeLabel: UILabel!
    @IBOutlet weak var protectDeviceImageView: UIImageView!

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
                protectDeviceImageView.image = UIImage(named: isProtectDevice ? "p_device": "p_no_device")
            }
        }
    }

    var isSetupPin = false {
        didSet {
            if oldValue != isSetupPin {
                securityView.isHidden = isSetupPin
            }
        }
    }

    lazy var dispatchGroup = DispatchGroup()
    var timeType: ChooseTimeEnum = .day {
        didSet {
            timeTypeLabel.text = timeType.getTitle()
        }
    }

    var isPreparingData = false
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess),
                                               name: NSNotification.Name(rawValue: kLoginSuccess),
                                               object: nil)
        setupUI()
        // Do any additional setup after loading the view.
        prepareData()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateProtectDevice),
                                               name: NSNotification.Name(rawValue: updateDnsStatus),
                                               object: nil)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.isNavigationBarHidden = true
        isSetupPin = CacheManager.shared.getPin() != nil
        isProtectWifi = CacheManager.shared.getProtectWifiStatus()
        isProtectDevice = DoHNative.shared.isEnabled
        setSafeMode()
        if !isPreparingData {
            prepareData(false)
        }
        guard let lastScan = CacheManager.shared.getLastScan() else {
            lastScanLabel.text = ""
            return
        }
        lastScanLabel.text = "Lần quét gần nhất \(DateFormatter.timeAgoSinceDate(date: lastScan, currentDate: Date()))"
        
    }

    private func setupUI() {
        timeTypeLabel.text = timeType.getTitle()
        contentView.dropShadowEdge()
        overView.dropShadowEdge()
        vpnView.dropShadowEdge()
        pakeWebView.dropShadowEdge()
        protectFamilyView.dropShadowEdge()
        securityView.dropShadowEdge()
        registerInfoView.dropShadowEdge()
        otherView.dropShadowEdge()
        let isLogin = CacheManager.shared.getIsLogined()
        protectAdAndFollowStackView.isHidden = true//!isLogin
        overView.isHidden = !isLogin
        protectFamilyView.isHidden = !isLogin
        registerInfoView.isHidden = true//!isLogin
    }

    private func setSafeMode() {
        let font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        guard let scanNumberIssue = CacheManager.shared.getScanIssueNumber() else {
            titleLB.text = "Thiết bị của bạn có an toàn?"
            return
        }
        let isTrue = scanNumberIssue == 0
        let highlightColor: UIColor = isTrue ? .systemGreen : .systemRed
        let text = isTrue ? "Bạn đang an toàn" : "Đã phát hiện \(scanNumberIssue) sự cố"
        let highlightText = isTrue ? "an toàn" : "\(scanNumberIssue) sự cố"

        let attributedText = NSMutableAttributedString(string: text, attributes: [.font : font,
                                                                                  .foregroundColor: highlightColor])
        attributedText.addAttributes([.font : font,
                                      .foregroundColor: UIColor.white],
                                     range: NSRange(location: 0,
                                                    length: text.count - highlightText.count))
        titleLB.attributedText = attributedText
    }

    @objc func prepareData(_ isShowLoading: Bool = true) {
        guard isViewLoaded else { return }
        guard let groupId = CacheManager.shared.getCurrentUser()?.defaultGroup else { return }
        isPreparingData = true
        if isShowLoading {
            showLoading()
        }
        dispatchGroup.enter()
        dispatchGroup.enter()
        GroupWorker.getGroup(id: groupId) { [weak self] (group, error, responseCode) in
            guard let self = self else { return }
            self.groupModel = group
            self.dispatchGroup.leave()
        }

        getStatistic()

        dispatchGroup.notify(queue: .main) {
            self.isPreparingData = false
            self.hideLoading()
        }
    }

    func getStatistic(_ leaveDispatchGroup: Bool = true, _ isShowLoading: Bool = false) {
        if isShowLoading {
            showLoading()
        }
        guard let groupId = CacheManager.shared.getCurrentUser()?.defaultGroup else {
            if leaveDispatchGroup {
                dispatchGroup.leave()
            }
            if isShowLoading {
                hideLoading()
            }
            return
        }
        GroupWorker.getStatistic(grId: groupId,
                                 limit: timeType.rawValue) { [weak self] (statistic, error, responseCode) in
            guard let self = self else { return }
            self.statisticModel = statistic
            if leaveDispatchGroup {
                self.dispatchGroup.leave()
            }
            if isShowLoading {
                self.hideLoading()
            }
        }
    }

    @objc func loginSuccess() {
        prepareData()
        let isLogin = CacheManager.shared.getIsLogined()
        protectAdAndFollowStackView.isHidden = true//!isLogin
        overView.isHidden = !isLogin
        protectFamilyView.isHidden = !isLogin
        registerInfoView.isHidden = !isLogin
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

    private func updateGroup(_ isShowloading: Bool = true) {
        guard let group = groupModel else {
            return
        }
        if isShowloading {
            showLoading()
        }
        GroupWorker.update(group: group) { [weak self] (group, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            if error == nil {
                weakSelf.bindingProtectStatus()
            }
        }
    }
    //MARK: DoH
    override func showAnimationConnectLoading() {
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
//        vc.onSuccess = {
//            self.prepareData()
//        }
        present(vc, animated: true)
    }
}

// MARK: Action
extension ProtectVC {
    @IBAction func reportWebsiteAction(_ sender: Any) {
        let vc = ReportWebsiteVC()
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @IBAction func scanAction(_ sender: Any) {
        let vc = ScanOverviewVC()
        present(vc, animated: true)
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
        let vc = ReportWebsiteVC()
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true)
    }

    @IBAction func createGroup(_ sender: Any) {
        showFormAddGroup()
    }
    
    func showFormAddGroup() {
        let vc = PostGroupAboutVC()
        vc.startAction = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.postGroup()
        }
        present(vc, animated: true, completion: nil)
    }
    func postGroup() {
        let postVC = PostGroupVC()
        postVC.onDone = { [weak self] in
            guard let weakSelf = self else { return }
//            weakSelf.refreshData()
            weakSelf.tabBarController?.selectedIndex = 1
        }
        let nav = BaseNavigationController(rootViewController: postVC)
        present(nav, animated: true, completion: nil)
    }

    @IBAction func createSecurity(_ sender: Any) {
        let vc = EnterPinVC()
        vc.hidesBottomBarWhenPushed = true
        vc.isFromProtect = true
        navigationController?.pushViewController(vc)
    }
    
    @IBAction func upgradeNow(_ sender: Any) {

    }

    @IBAction func chooseTime(_ sender: Any) {
        guard let view = ChooseTimeView.loadFromNib() else { return }
        view.chooseTimeAction = { [weak self] type in
            guard let weakSelf = self else { return }
            guard weakSelf.timeType != type else { return }
            weakSelf.timeType = type
            weakSelf.getStatistic(false, true)
        }
        view.binding()
        showPopup(view: view)
    }

    @IBAction func newFeeds(_ sender: Any) {
        gotoWebview("https://congcu.khonggianmang.vn/news-feed")
    }

    @IBAction func checkIpma(_ sender: Any) {
        gotoWebview("https://congcu.khonggianmang.vn/check-ipma")
    }

    @IBAction func checkPhishing(_ sender: Any) {
        gotoWebview("https://congcu.khonggianmang.vn/check-phishing")
    }

    @IBAction func checkRansomware(_ sender: Any) {
        gotoWebview("https://congcu.khonggianmang.vn/ransomware")
    }

    @IBAction func checkLead(_ sender: Any) {
        gotoWebview("https://congcu.khonggianmang.vn/check-data-leak")
    }

    private func gotoWebview(_ url: String) {
        let vc = WebViewVC()
        vc.url = url
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }

}
