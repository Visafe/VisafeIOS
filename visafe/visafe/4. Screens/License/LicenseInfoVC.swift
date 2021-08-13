//
//  LicenseInfoVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/27/21.
//

import UIKit
import ObjectMapper

class LicenseInfoVC: BaseViewController {
    var type: PakageNameEnum = .family
    var sources: [LicenseDescriptionEnum] = []
    var currentUser: UserModel = UserModel()
    var workspace:(() -> Void)?
    var morePackage:(() -> Void)?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageLicense: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    func configView() {
        sources = LicenseDescriptionEnum.getSource()
        currentUser = CacheManager.shared.getCurrentUser() ?? UserModel()
        imageLicense.image = currentUser.accountType.getLogo()
        contentLabel.text = currentUser.accountType.getDesciptionInfo()
        tableView.backgroundColor = UIColor.clear
        tableView.registerCells(cells: [LicenseCell.className])
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func workspaceAction(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.workspace?()
        }
    }
    
    @IBAction func morePackageAction(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.morePackage?()
        }
    }
}

extension LicenseInfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LicenseCell.className) as? LicenseCell else {
            return UITableViewCell()
        }
        cell.bindingData(value: sources[indexPath.row])
        return cell
    }
}
