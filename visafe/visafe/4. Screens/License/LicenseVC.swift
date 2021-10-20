//
//  LicenseVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/27/21.
//

import UIKit
import ObjectMapper

public enum LicenseDescriptionEnum: String {
    case device = "Bảo vệ thiết bị"
    case wifi = "Bảo vệ Wi-Fi"
    case protect = "Chặn theo dõi, quảng cáo không giới hạn"
    case statis = "Phân tích & Báo cáo"
    case maxdevice = "Tối đa %ld thiết bị"
    case maxgroup = "Quản lý tối đa %ld nhóm"
    case maxworkspace = "Quản lý tối đa %ld workspace"
    case help = "Hỗ trợ qua Chat/Call"
    
    func getDescription(package: PackageModel) -> String {
        switch self {
        case .device:
            return "Bảo vệ thiết bị"
        case .wifi:
            return "Bảo vệ Wi-Fi"
        case .protect:
            return "Chặn theo dõi, quảng cáo không giới hạn"
        case .statis:
            return "Phân tích & Báo cáo"
        case .maxdevice:
            return "Tối đa \(package.max_device) thiết bị"
        case .maxgroup:
            return "Quản lý tối đa \(package.max_group) nhóm"
        case .maxworkspace:
            return "Quản lý tối đa \(package.max_workspace) workspace"
        case .help:
            return "Hỗ trợ qua Chat/Call"
        }
    }
    
    func getDescription() -> String {
        guard let user = CacheManager.shared.getCurrentUser() else { return "" }
        switch self {
        case .device:
            return "Bảo vệ thiết bị"
        case .wifi:
            return "Bảo vệ Wi-Fi"
        case .protect:
            return "Chặn theo dõi, quảng cáo không giới hạn"
        case .statis:
            return "Phân tích & Báo cáo"
        case .maxdevice:
            return "Tối đa \(user.maxDevice) thiết bị"
        case .maxgroup:
            return "Quản lý tối đa \(user.maxGroup) nhóm"
        case .maxworkspace:
            return "Quản lý tối đa \(user.maxWorkspace) workspace"
        case .help:
            return "Hỗ trợ qua Chat/Call"
        }
    }
    
    static func getSource() -> [LicenseDescriptionEnum] {
        return [.device, .wifi, .protect, .statis, .maxdevice, .maxgroup, .maxworkspace, .help]
    }
}

class LicenseVC: BaseViewController {
    var package: PackageModel
    var type: PakageNameEnum = .family
    var sources: [LicenseDescriptionEnum] = []
    var paymentSuccess:(() -> Void)?
    var prices: [PackagePriceModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageLicense: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    init(package: PackageModel) {
        self.package = package
        self.type = package.name ?? .family
        self.sources = LicenseDescriptionEnum.getSource()
        self.prices = package.prices.sorted(by: { (p1, p2) -> Bool in
            return p1.duration < p2.duration
        })
        if self.prices.count == 0 { self.prices.append(PackagePriceModel.getPriceBusiness()) }
        super.init(nibName: LicenseVC.className, bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView() {
        imageLicense.image = type.getLogo()
        contentLabel.text = type.getDesciption()
        view.backgroundColor = UIColor.clear
        tableView.registerCells(cells: [LicenseCell.className, LicensePackageCell.className])
    }
}

extension LicenseVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return sources.count
        } else {
            return prices.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LicenseCell.className) as? LicenseCell else {
                return UITableViewCell()
            }
            cell.bindingData(value: sources[indexPath.row], package: package)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LicensePackageCell.className) as? LicensePackageCell else {
                return UITableViewCell()
            }
            cell.bindingData(price: prices[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let price = prices[indexPath.row]
            if let id = price.id {
                showLoading()
                PaymentWorker.order(id: id) { [weak self] (result, error, responseCode) in
                    guard let weakSelf = self else { return }
                    weakSelf.hideLoading()
                    if let string = result?.payUrl, let url = URL(string: string) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            } else {
                showPhoneTell(tel: "02432091616")
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 8.001
        }
        return 0.0001
    }
    
    func showPhoneTell(tel: String) {
        if let url = URL(string: "tel:\(tel)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
