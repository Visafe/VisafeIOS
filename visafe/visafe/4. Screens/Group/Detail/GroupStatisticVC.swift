//
//  GroupStatisticVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/21/21.
//

import UIKit

class GroupStatisticVC: BaseViewController {
        
    @IBOutlet weak var tableView: UITableView!
    
    var group: GroupModel
    
    var statisticModel: StatisticModel = StatisticModel()
    var statisticCategory: [StatisticCategory] = []
    var statisticCategoryApp: [StatisticCategoryApp] = []
    
    init(group: GroupModel) {
        self.group = group
        super.init(nibName: GroupStatisticVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        prepareData()
    }
    
    func configUI() {
        tableView.registerCells(cells: [StatisticCategoryCell.className])
    }
    
    func prepareData() {
//        guard let grId = group.groupid else { return }
        let grId = "58b0559e-9159-473c-a4d8-56651ad4b22b"
        showLoading()
        GroupWorker.getStatistic(grId: grId, limit: 24) { [weak self] (statistic, error) in
            guard let weakSelf = self else { return }
            if let model = statistic {
                weakSelf.statisticModel = model
            }
            weakSelf.bindingData()
            weakSelf.tableView.reloadData()
            weakSelf.hideLoading()
        }
    }
    
    func bindingData() {
        statisticCategory = statisticModel.top_categories?.sorted(by: { (model, model2) -> Bool in
            return model.count < model2.count
        }) ?? []
        
        for item in statisticCategory {
            statisticCategoryApp += item.apps ?? []
        }
        statisticCategoryApp = statisticCategoryApp.sorted { (app1, app2) -> Bool in
            return app1.count < app2.count
        }
    }
}

extension GroupStatisticVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return statisticCategory.count
        } else {
            return statisticCategoryApp.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticCategoryCell.className) as? StatisticCategoryCell else {
            return UITableViewCell()
        }
        if indexPath.section == 0 {
            cell.bindingData(category: statisticCategory[indexPath.row])
        } else {
            cell.bindingData(app: statisticCategoryApp[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 48))
        viewHeader.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: kScreenWidth - 32, height: 48))
        if section == 0 {
            label.text = "Nội dung dùng nhiều"
        } else {
            label.text = "Ứng dụng dùng nhiều"
        }
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        viewHeader.addSubview(label)
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
}
