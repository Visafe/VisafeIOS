//
//  ScanGroupVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 8/5/21.
//

import UIKit
import AVFoundation
import Toast_Swift
import FirebaseDynamicLinks

class ScanGroupVC: BaseViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var captureView: UIView!
    var qrScannerView: QRScannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrScannerView = QRScannerView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        qrScannerView.focusImage = UIImage(named: "ic_bg_qr")
        qrScannerView.isBlurEffectEnabled = true
        captureView.addSubview(qrScannerView)
        qrScannerView.configure(delegate: self)
        qrScannerView.startRunning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension ScanGroupVC: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        //Todo: apply dynamic link handle
        guard let url = URL(string: code) else { return }
        DynamicLinks.dynamicLinks().handleUniversalLink(url) {[weak self] dynamiclink, error in
            self?.handleInvite(dynamiclink?.url?.absoluteString ?? "")
        }
    }

    func handleInvite(_ code: String) {
        guard let link = code.checkInviteDevicelink() else {
            self.view.makeToast("Link không đúng định dạng", duration: 2, position: .bottom)
            Timer.scheduledTimer(timeInterval: 2, target: self, selector:#selector(self.reScan), userInfo: nil , repeats:false)
            return
        }
        let param = Common.getDeviceInfo()
        param.updateGroupInfo(link: link)
        let vc = JoinGroupVC(param: param)
        vc.dismissJoinGroup = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.reScan()
        }
        let nav = BaseNavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @objc func reScan() {
        qrScannerView.rescan()
    }
}
