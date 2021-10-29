//
//  PostGroupAboutVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit

public enum PostGroupIntroEnum: Int {
    case cheat = 0
    case attach = 1
    case log = 2
    
    func getTitle() -> String {
        switch self {
        case .cheat:
            return "Chống lừa đảo mạng"
        case .attach:
            return "Chống mã độc & tấn công mạng"
        case .log:
            return "Thống kê thời gian sử dụng mạng"
        }
    }
}

class PostGroupAboutVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var descriptionImageView: UIImageView!
    
    var sources: [PostGroupIntroEnum] = [.cheat, .attach, .log]
    
    var startAction:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindingData()
    }
    
    func configView() {
        tableView.registerCells(cells: [PostGroupAboutCell.className])
    }
    
    func bindingData() {
        let type = CacheManager.shared.getCurrentWorkspace()?.type ?? .family
        titleLabel.text = type.getTitleIntro()
        contentLabel.text = type.getContentIntro()
        descriptionImageView.image = type.getImageIntro()
        tableView.reloadData()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.startAction?()
        }
    }
}

extension PostGroupAboutVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = sources[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostGroupAboutCell.className) as? PostGroupAboutCell else {
            return UITableViewCell()
        }
        cell.bindingData(type: type)
        return cell
    }
}


