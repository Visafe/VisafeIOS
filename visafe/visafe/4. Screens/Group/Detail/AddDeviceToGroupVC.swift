//
//  AddDeviceToGroupVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 8/2/21.
//

import UIKit
import Toast_Swift
import FirebaseDynamicLinks

class AddDeviceToGroupVC: BaseViewController {

    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    var group: GroupModel
    var addDevice:((_ device: DeviceGroupModel) -> Void)?
    
    init(group: GroupModel) {
        self.group = group
        super.init(nibName: AddDeviceToGroupVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func configView() {
        guard let link = group.link_invite_device else { return }
        guard let qrURLImage = URL(string: link)?.qrImage(using: UIColor(hexString: "021C5C")!, logo: UIImage(named: "ic_logo_qr")) else { return }
        qrCodeImageView.image = qrURLImage
        groupNameLabel.text = "Nhóm: \(group.name ?? "")"
        linkButton.setTitle(link, for: .normal)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        sharedLink()
    }
    
    @IBAction func addCurrentDeviceAction(_ sender: Any) {
        let param = Common.getDeviceInfo()
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
        device.groupId = group.groupid
        device.groupName = group.name
        showLoading()
        GroupWorker.addDevice(param: device) { [weak self] (result, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            if responseCode == 200 {
                weakSelf.showMessage(title: "Thêm thiết bị thành công", content: InviteDeviceStatus.success.getDescription())
                weakSelf.addDevice?(device.toDeviceModel())
                
            } else {
                let error = result?.status_code ?? .defaultStatus
                weakSelf.showError(title: "Thêm thiết bị thất bại", content: result?.local_msg ?? "")
            }
        }
    }
    
    @IBAction func copyLinkAction(_ sender: Any) {
        let shareLink = "https://app.visafe.vn/control/invite/device?groupId=\(group.groupid ?? "")&groupName=\(group.name?.urlEncoded ?? "")&d=1"
        guard let newSharelink = URL(string: shareLink) else { return }
        guard let components = DynamicLinkComponents.init(link: newSharelink, domainURIPrefix: "https://firebase.visafe.vn") else { return }
        let iOSParams = DynamicLinkIOSParameters(bundleID: "vn.visafe")
        iOSParams.appStoreID = ""
        components.iOSParameters = iOSParams
        let options = DynamicLinkComponentsOptions()
        options.pathLength = .short
        components.options = options
        components.shorten { (shortURL, warnings, error) in
            if let link = shortURL?.absoluteString {
                let pasteboard = UIPasteboard.general
                pasteboard.string = link
                // toast with a specific duration and position
                self.view.makeToast("Sao chép thành công", duration: 3.0, position: .bottom)
            }
        }
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(qrCodeImageView.asImage(), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            self.view.makeToast("Lưu ảnh thất bại", duration: 3.0, position: .bottom)
        } else {
            self.view.makeToast("Lưu ảnh thành công", duration: 3.0, position: .bottom)
        }
    }
    
    @IBAction func linkAction(_ sender: Any) {
        guard let link = group.link_invite_device else { return }
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    fileprivate func sharedLink() {
        guard let link = group.link_invite_device else { return }
        let objectsToShare = [link] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        self.present(activityVC, animated: true, completion: nil)
    }
}

extension UIView {
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
