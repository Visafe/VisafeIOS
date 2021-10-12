//
//  NotificationVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit

class NotificationVC: BaseViewController {

    var canLoadMore: Bool = true
    var pageIndex: Int = 1
    
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var sources: [NotificationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: kLoginSuccess), object: nil)
        configRefreshData()
        configView()
        prepareData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    init() {
        super.init(nibName: NotificationVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configRefreshData() {
        tableView.addPullToRefresh { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.refreshData()
        }
    }
    
    func configView() {
        //title
        title = "Thông báo"
        
        // tableview
        tableView.registerCells(cells: [NotificationCell.className])
    }
    
    func prepareData() {
        showLoading()
        NotificationWorker.list(page: pageIndex) { [weak self] (result, error, responseCode)  in
            guard let weakSelf = self else { return }
            weakSelf.hideLoading()
            weakSelf.sources = weakSelf.sources + (result?.notis ?? [])
            weakSelf.tableView.endRefreshing()
            weakSelf.canLoadMore = ((result?.notis?.count ?? 0) >= 15)
            if weakSelf.canLoadMore {
                weakSelf.pageIndex += 1
                weakSelf.addLoadMore()
            } else {
                weakSelf.tableView.mj_footer = nil
            }
            weakSelf.reloadData()
        }
    }
    
    @objc func refreshData() {
        if isViewLoaded {
            pageIndex = 1
            sources = []
            tableView.reloadData()
            NotificationWorker.list(page: pageIndex) { [weak self] (result, error, responseCode) in
                guard let weakSelf = self else { return }
                weakSelf.sources = result?.notis ?? []
                weakSelf.tableView.endRefreshing()
                weakSelf.canLoadMore = ((result?.notis?.count ?? 0) >= 15)
                if weakSelf.canLoadMore {
                    weakSelf.pageIndex += 1
                    weakSelf.addLoadMore()
                } else {
                    weakSelf.tableView.mj_footer = nil
                }
                weakSelf.reloadData()
            }
        }
    }
    
    func loadNotifications() {
        if canLoadMore == false { return }
        NotificationWorker.list(page: pageIndex) { [weak self] (result, error, responseCode) in
            guard let weakSelf = self else { return }
            weakSelf.sources = weakSelf.sources + (result?.notis ?? [])
            weakSelf.tableView.endRefreshing()
            weakSelf.canLoadMore = ((result?.notis?.count ?? 0) >= 15)
            if weakSelf.canLoadMore {
                weakSelf.pageIndex += 1
                weakSelf.addLoadMore()
            } else {
                weakSelf.tableView.mj_footer = nil
            }
            weakSelf.reloadData()
        }
    }
    
    func reloadData() {
        tableView.reloadData()
        if sources.count > 0 {
            noDataLabel.isHidden = true
        } else {
            noDataLabel.isHidden = false
        }
    }
    
    private func addLoadMore() {
        tableView.addLoadmore(canLoadMore: true) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.loadNotifications()
        }
    }
}

extension NotificationVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.className) as? NotificationCell else {
            return UITableViewCell()
        }
        if let source = sources[safe: indexPath.row] {
            cell.bindingData(model: source)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        readNotification(notifi: sources[indexPath.row])
    }
    
    func readNotification(notifi: NotificationModel) {
        guard let id = notifi.id else { return }
        if notifi.isRead == false {
            notifi.isRead = true
            NotificationWorker.readNotification(id: id) { (result, error, responseCode) in }
            reloadData()
        }
    }
}
