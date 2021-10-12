//
//  ScanVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/27/21.
//

import UIKit
import ObjectMapper
import LocalAuthentication
import DeviceKit
public enum ScanDescriptionEnum: String {
    case about = "KIỂM TRA BẢO MẬT"
    case protect = "CHẾ ĐỘ BẢO VỆ"
    case wifi = "BẢO VỆ WI-FI"
    case protocoll = "PHƯƠNG THỨC BẢO VỆ"
    case system = "HỆ ĐIỀU HÀNH"
    case done = "Kiểm tra hoàn tất"
    
    func getDescription() -> String {
        switch self {
        case .about:
            return "Visafe giúp bạn kiểm tra toàn diện về nguy hại, mã độc, quảng cáo & theo dõi."
        case .protect:
            return "Đang bật chế độ bảo vệ Visafe"
        case .wifi:
            return "Đang kiểm tra wifi"
        case .protocoll:
            return "Đang thiết lập các phương thức bảo vệ"
        case .system:
            return "Đang kiểm tra phiên bản hệ điều hành"
        case .done:
            guard let lastScan = CacheManager.shared.getLastScan() else {
                return "Lần quét gần nhất vừa mới xong"
            }
            return "Lần quét gần nhất \(DateFormatter.timeAgoSinceDate(date: lastScan, currentDate: Date()))"
        }
    }
    
    func getIcon() -> UIImage? {
        switch self {
        case .about:
            return UIImage(named: "ic_scan_visafe")
        case .protect:
            return UIImage(named: "ic_scan_device")
        case .wifi:
            return UIImage(named: "ic_scan_wifi")
        case .protocoll:
            return UIImage(named: "ic_scan_ads")
        case .system:
            return UIImage(named: "ic_scan_tracking")
        case .done:
            return UIImage(named: "check_icon")
        }
    }
    
    static func getAll() -> [ScanDescriptionEnum] {
        return [.about, .protect, .wifi, .protocoll, .system, .done]
    }
}

class ScanVC: BaseViewController {
    
    var type: ScanDescriptionEnum = .about
    
    @IBOutlet weak var contraintHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var desLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var errorStackView: UIStackView!
    @IBOutlet weak var spacingView: UIView!
    @IBOutlet weak var tableview: UITableView!

    var scanSuccess: ((Bool, ScanDescriptionEnum) -> Void)?
    var scanResult = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        tableview.registerCells(cells: [ScanResultCell.className])
        tableview.mj_footer = nil
    }
    
    init(type: ScanDescriptionEnum) {
        self.type = type
        super.init(nibName: ScanVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scan()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func configView() {
        descriptionImage.image = type.getIcon()
        titleLabel.text = type.rawValue
        descriptionLabel.text = type.getDescription()
        view.backgroundColor = UIColor.clear
        contraintHeight.constant = kScreenHeight * 0.7
        imageViewHeight.constant = type == .done ? 64: 178
        imageViewWidth.constant = type == .done ? 64: 160
    }

    func scan() {
        switch type {
        case .protect:
            scanSuccess?(DoHNative.shared.isEnabled, type)
        case .wifi:
            checkBotNet()
        case .protocoll:
            checkBiometric()
        case .system:
            getiOSVersion()
        case .done:
            CacheManager.shared.setScanIssueNumber(value: scanResult.count)
            if !scanResult.isEmpty {
                desLabelBottom.constant = 200
                errorStackView.isHidden = false
                spacingView.isHidden = false
                tableview.dataSource = self
            } else {
                desLabelBottom.constant = 100
                errorStackView.isHidden = true
            }

        default:
            break
        }
    }

    func checkBotNet() {
        GroupWorker.checkBotNet {[weak self] (response, error, responseCode) in
            guard let self = self else { return }
            let botnetDetails = response?.detail ?? []
            self.scanSuccess?(botnetDetails.isEmpty, self.type)
        }
    }

    func checkBiometric(){
        var error: NSError?
        let authenticationContext = LAContext()

        // check touch id, faceid enable
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            //touchid, faceId enable -> passcode enable
            scanSuccess?(true, type)
        } else {
            //check passcode enable
            if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                scanSuccess?(true, type)
            } else {
                scanSuccess?(false, type)
            }
        }
    }

    func getiOSVersion() {
        GroupWorker.getNewestiOSVersion(name: Device.identifier) {[weak self] (model, error, responseCode) in
            guard let self = self else { return }
            guard let version = model?.version else {
                self.scanSuccess?(false, self.type)
                return
            }
            let compare = UIDevice.current.systemVersion.versionCompare(version)
            self.scanSuccess?(compare == .orderedSame || compare == .orderedDescending, self.type)
        }
    }
}

extension ScanVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scanResult.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScanResultCell.className) as? ScanResultCell else {
            return UITableViewCell()
        }
        cell.bindingData(value: scanResult[indexPath.row])
        return cell
    }
}

extension String {
    func versionCompare(_ otherVersion: String) -> ComparisonResult {
        return self.compare(otherVersion, options: .numeric)
    }
}
