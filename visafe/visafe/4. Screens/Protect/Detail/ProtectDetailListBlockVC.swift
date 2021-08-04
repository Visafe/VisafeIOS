//
//  ProtectDetailListBlockVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/24/21.
//

import UIKit

class ProtectDetailListBlockVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var scrollDelegateFunc: ((UIScrollView)->Void)?
    var type: ProtectHomeType
    var blockId: String?
    var sources: [QueryLogModel] = []
    var oldest: String?
    var canLoadMore: Bool = true
    
    init(type: ProtectHomeType) {
        self.type = type
        super.init(nibName: ProtectDetailListBlockVC.className, bundle: nil)
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
        tableView.registerCells(cells: [GroupLogCell.className])
    }
    
    func configRefreshData() {
        tableView.addPullToRefresh { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.refreshData()
        }
    }
    
    func refreshData() {
        if isViewLoaded {
            // Todo: get data
            guard let groupId = blockId else { return }
            self.oldest = nil
            let param = QueryLogParam()
            param.group_id = groupId
            param.limit = 20
            param.response_status = type.getTypeQueryLog()
            GroupWorker.getLog(param: param) { [weak self] (result, error) in
                guard let weakSelf = self else { return }
                weakSelf.sources = result?.data ?? []
                weakSelf.canLoadMore = ((result?.data?.count ?? 0) >= 0)
                if weakSelf.canLoadMore {
                    weakSelf.oldest = result?.oldest
                    weakSelf.addLoadMore()
                } else {
                    weakSelf.tableView.mj_footer = nil
                }
                weakSelf.tableView.endRefreshing()
                weakSelf.tableView.reloadData()
            }
        }
    }
    
    func prepareData() {
        guard let groupId = blockId else { return }
        showLoading()
        let param = QueryLogParam()
        param.group_id = groupId
        param.limit = 20
        param.response_status = type.getTypeQueryLog()
        GroupWorker.getLog(param: param) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.sources = result?.data ?? []
            weakSelf.canLoadMore = ((result?.data?.count ?? 0) >= 0)
            if weakSelf.canLoadMore {
                weakSelf.oldest = result?.oldest
                weakSelf.addLoadMore()
            } else {
                weakSelf.tableView.mj_footer = nil
            }
            weakSelf.tableView.reloadData()
        }
    }
    
    func loadLogs() {
        if canLoadMore == false { return }
        guard let groupId = blockId else { return }
        let param = QueryLogParam()
        param.group_id = groupId
        param.limit = 20
        param.response_status = type.getTypeQueryLog()
        param.older_than = oldest
        GroupWorker.getLog(param: param) { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.tableView.endRefreshing()
            weakSelf.sources += (result?.data ?? [])
            weakSelf.canLoadMore = ((result?.data?.count ?? 0) >= 0)
            if weakSelf.canLoadMore {
                weakSelf.oldest = result?.oldest
                weakSelf.addLoadMore()
            } else {
                weakSelf.tableView.mj_footer = nil
            }
            weakSelf.tableView.reloadData()
        }
    }
    
    private func addLoadMore() {
        tableView.addLoadmore(canLoadMore: true) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.loadLogs()
        }
    }
}

extension ProtectDetailListBlockVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupLogCell.className) as? GroupLogCell else {
            return UITableViewCell()
        }
        let model = sources[indexPath.row]
        cell.moreAction = { [weak self] in
            guard let weakSelf = self else { return }
            guard let view = MoreActionLinkView.loadFromNib() else { return }
            view.binding(groupName: "QuocNV.name", time: "Đã chặn \(model.time?.getTimeOnFeed().lowercased() ?? "")")
            view.unBlockedAction = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.addToWhileList(domain: strongSelf.sources[indexPath.row])
            }
            view.deleteAction = { [weak self] in
                guard let strongSelf = self else { return }
                Timer.scheduledTimer(timeInterval: 0.3, target: strongSelf, selector:#selector(strongSelf.deleteLog(sender:)), userInfo: strongSelf.sources[indexPath.row] , repeats:false)
            }
            weakSelf.showPopup(view: view)
        }
        cell.bindingData(model: model)
        return cell
    }
    
    func addToWhileList(domain: QueryLogModel) {
//        guard let link = domain.question?.host else { return }
//        var whitelist = group.whitelist
//        whitelist.append(link)
//        let param = GroupUpdateWhitelistParam()
//        param.white_list = whitelist
//        param.group_id = group.groupid
//        showLoading()
//        GroupWorker.updateWhitelist(param: param) { [weak self] (result, error) in
//            guard let weakSelf = self else { return }
//            weakSelf.hideLoading()
//            if let _ = result {
//                weakSelf.group.whitelist = whitelist
//            }
//        }
    }
    
    @objc func deleteLog(sender: Timer) {
        guard let domain = sender.userInfo as? QueryLogModel else { return }
        showConfirmDelete(title: "Bạn có chắc chắn muốn xoá cảnh báo không?") { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.actionDeleteLog(domain: domain)
        }
    }
    
    func actionDeleteLog(domain: QueryLogModel) {
//        showLoading()
//        GroupWorker.deleteLog(groupId: group.groupid, logId: domain.doc_id) { [weak self] (result, error) in
//            guard let weakSelf = self else { return }
//            weakSelf.hideLoading()
//            weakSelf.refreshData()
//        }
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

extension ProtectDetailListBlockVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollDelegateFunc != nil {
            self.scrollDelegateFunc!(scrollView)
        }
    }
}

