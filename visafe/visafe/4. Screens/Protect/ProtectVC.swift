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
    // item of detail view
    @IBOutlet weak var vpnView: UIView!
    @IBOutlet weak var pakeWebView: UIView!
    @IBOutlet weak var protectFamilyView: UIView!
    @IBOutlet weak var securityView: UIView!
    @IBOutlet weak var registerInfoView: UIView!
    @IBOutlet weak var otherView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
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

}
// MARK: Action in content
extension ProtectVC {

    @IBAction func scanAction(_ sender: Any) {
        setSafeMode(isTrue: false)
    }

    @IBAction func switchProtectDevice(_ sender: Any) {
        setSafeMode()
    }

    @IBAction func switchProtectWifi(_ sender: Any) {
        setSafeMode(isTrue: false)
    }

    @IBAction func switchProtectAds(_ sender: Any) {
    }

    @IBAction func switchProtectFolow(_ sender: Any) {
    }
}


// MARK: Action
extension ProtectVC {


    @IBAction func addVPN(_ sender: Any) {
        vpnView.isHidden = true
        view.layoutIfNeeded()
    }

    @IBAction func reportFake(_ sender: Any) {
        vpnView.isHidden = false
        view.layoutIfNeeded()
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
