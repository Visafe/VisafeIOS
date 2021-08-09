//
//  ScanGroupVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 8/5/21.
//

import UIKit
import AVFoundation

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
        guard let link = code.checkDeeplink() else { return }
        let param = Common.getDeviceInfo()
        param.updateGroupInfo(link: link)
        
        guard let view = BaseEnterValueView.loadFromNib() else { return }
        view.bindingData(type: .deviceName, name: param.deviceName)
        view.enterTextfield.text = param.deviceName
        view.acceptAction = { [weak self] name in
            guard let weakSelf = self else { return }
            guard let deviceName = name else { return }
            param.deviceName = deviceName
            weakSelf.addDeviceToGroup(device: param)
        }
        showPopup(view: view)
    }
    
    func addDeviceToGroup(device: AddDeviceToGroupParam) {
        showLoading()
        GroupWorker.addDevice(param: device) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            if result?.status_code == .success {
                weakSelf.showMessage(title: "Thêm thiết bị thành công", content: InviteDeviceStatus.success.getDescription()) { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.dismiss(animated: true, completion: nil)
                }
            } else {
                weakSelf.showError(title: "Thêm thiết bị thất bại", content: InviteDeviceStatus.defaultStatus.getDescription())
            }
        }
    }
}
