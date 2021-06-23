//
//  GroupVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit

class GroupVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func configView() {
        // tableview
        tableView.registerCells(cells: [GroupCell.className])
        
        let footerView = GroupFooterView.loadFromNib()
        footerView?.configView()
        tableView.tableFooterView = footerView
    }
}

extension GroupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return workspaces.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.className) as? GroupCell else {
            return UITableViewCell()
        }
//        cell.binding(workspace: workspaces[indexPath.row])
        return cell
    }
}

