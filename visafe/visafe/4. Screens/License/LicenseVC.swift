//
//  LicenseVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/27/21.
//

import UIKit

public enum LicensePackageEnum: Int {
    case month = 1
    case year = 2
    
    func getTitle() -> String {
        switch self {
        case .month:
            return "Gói 1 tháng"
        case .year:
            return "Gói 12 tháng"
        }
    }
    
    func getContent() -> String {
        switch self {
        case .month:
            return "+7 NGÀY DÙNG THỬ"
        case .year:
            return "+90 NGÀY DÙNG THỬ"
        }
    }
}

class LicenseVC: BaseViewController {
    var type: LicenseTypeEnum
    var sources: [String] = []
    
    var prices: [LicensePackageEnum] = [.year, .month]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageLicense: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    init(type: LicenseTypeEnum) {
        self.type = type
        self.sources = type.getListSource()
        super.init(nibName: LicenseVC.className, bundle: nil)
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
            cell.bindingData(value: sources[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LicensePackageCell.className) as? LicensePackageCell else {
                return UITableViewCell()
            }
            cell.bindingData(type: type, package: prices[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
}
