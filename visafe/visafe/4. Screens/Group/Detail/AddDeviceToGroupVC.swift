//
//  AddDeviceToGroupVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 8/2/21.
//

import UIKit

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
        let link = "https://app.visafe.vn/control/invite/device?groupId=\(group.groupid ?? "")&groupName=\(group.name?.urlEncoded ?? "")"
        guard let qrURLImage = URL(string: link)?.qrImage(using: UIColor(hexString: "021C5C")!, logo: UIImage(named: "ic_logo_qr")) else { return }
        qrCodeImageView.image = qrURLImage
        groupNameLabel.text = "Nhóm: \(group.name ?? "")"
        linkButton.setTitle("https://app.visafe.vn/\(group.groupid ?? "")", for: .normal)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let link = "https://app.visafe.vn/control/invite/device?groupId=\(group.groupid ?? "")&groupName=\(group.name?.urlEncoded ?? "")"
        if let link = NSURL(string: link) {
            let objectsToShare = ["Chia sẻ",link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func addCurrentDeviceAction(_ sender: Any) {
        addDeviceToGroup()
    }
    
    func addDeviceToGroup() {
        let param = Common.getDeviceInfo()
        param.groupId = group.groupid
        param.groupName = group.name
        showLoading()
        GroupWorker.addDevice(param: param) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            if result?.status_code == .success {
                weakSelf.showMessage(title: "Thêm thiết bị thành công", content: InviteDeviceStatus.success.getDescription())
                weakSelf.addDevice?(param.toDeviceModel())
                
            } else {
                weakSelf.showError(title: "Thêm thiết bị thất bại", content: InviteDeviceStatus.defaultStatus.getDescription())
            }
        }
    }
    
    @IBAction func copyLinkAction(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        let link = "https://app.visafe.vn/control/invite/device?groupId=\(group.groupid ?? "")&groupName=\(group.name?.urlEncoded ?? "")"
        pasteboard.string = link
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(qrCodeImageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            
            showError(title: "Lưu ảnh thất bại", content: "Có lỗi xảy ra. Vui lòng thử lại")
        } else {
            
            showMessage(title: "Lưu ảnh thành công", content: "Mã QR code đã được lưu vào thư viện ảnh")
        }
    }
    
    @IBAction func linkAction(_ sender: Any) {
        let link = "https://app.visafe.vn/control/invite/device?groupId=\(group.groupid ?? "")&groupName=\(group.name?.urlEncoded ?? "")"
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
