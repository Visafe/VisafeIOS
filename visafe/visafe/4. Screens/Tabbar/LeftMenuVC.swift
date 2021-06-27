//
//  LeftMenuVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit

class LeftMenuVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var workspaces: [WorkspaceModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        prepareData()
    }
    
    func configView() {
        // tableview
        tableView.registerCells(cells: [WorkspaceCell.className])
        
        
    }
    
    func prepareData() {
        workspaces = CacheManager.shared.getWorkspacesResult() ?? []
        tableView.reloadData()
    }
}

extension LeftMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workspaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkspaceCell.className) as? WorkspaceCell else {
            return UITableViewCell()
        }
        cell.binding(workspace: workspaces[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = WorkspaceFooterView.loadFromNib()
        footerView?.actionAddWorkspace = { [weak self] in
            guard let weakSelf = self else { return }
            let vc = PostWorkspaceVC()
            let nav = BaseNavigationController(rootViewController: vc)
            weakSelf.sideMenuController?.hideMenu()
            weakSelf.present(nav, animated: true, completion: nil)
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 230
    }
}
