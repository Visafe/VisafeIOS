//
//  GroupListBlockVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/24/21.
//

import UIKit

class GroupListBlockVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var group: GroupModel
    var scrollDelegateFunc: ((UIScrollView)->Void)?
    var type: GroupSettingParentEnum
    var sources: [QueryLogModel] = []
    
    init(group: GroupModel, type: GroupSettingParentEnum) {
        self.group = group
        self.type = type
        super.init(nibName: GroupListBlockVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configRefreshData()
        configUI()
        prepareData()
    }
    
    func configUI() {
        tableView.registerCells(cells: [GroupBlockCell.className])
    }
    
    func configRefreshData() {
        tableView.addPullToRefresh { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.refreshData()
        }
    }
    
    func refreshData() {
        if isViewLoaded {
            guard let wsId = CacheManager.shared.getCurrentWorkspace()?.id else { return }
            let param = QueryLogParam()
            param.workspace_id = wsId
            param.limit = 20
            param.response_status = type.getTypeQueryLog()
            WorkspaceWorker.getLog(param: param) { [weak self] (result, error) in
                guard let weakSelf = self else { return }
                weakSelf.sources = result?.data ?? []
                weakSelf.tableView.endRefreshing()
                weakSelf.tableView.reloadData()
            }
        }
    }
    
    func prepareData() {
        guard let wsId = CacheManager.shared.getCurrentWorkspace()?.id else { return }
        showLoading()
        let param = QueryLogParam()
        param.workspace_id = wsId
        param.limit = 20
        param.response_status = type.getTypeQueryLog()
        WorkspaceWorker.getLog(param: param) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.sources = result?.data ?? []
            weakSelf.tableView.reloadData()
        }
    }
}

extension GroupListBlockVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupBlockCell.className) as? GroupBlockCell else {
            return UITableViewCell()
        }
        cell.moreAction = { [weak self] in
            guard let weakSelf = self else { return }
            guard let view = MoreActionLinkView.loadFromNib() else { return }
            view.unBlockedAction = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.unBlockedDomain(domain: strongSelf.sources[indexPath.row])
            }
            weakSelf.showPopup(view: view)
        }
        cell.bindingData(model: sources[indexPath.row])
        return cell
    }
    
    func unBlockedDomain(domain: QueryLogModel) {
        guard let link = domain.question?.host else { return }
        var whitelist = group.white_list
        whitelist.append(link)
        let param = GroupUpdateWhitelistParam()
        param.white_list = whitelist
        param.group_id = group.groupid
        showLoading()
        GroupWorker.updateWhitelist(param: param) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.refreshData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}


extension GroupListBlockVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollDelegateFunc != nil {
            self.scrollDelegateFunc!(scrollView)
        }
    }
}

