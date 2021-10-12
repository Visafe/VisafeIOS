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
    var scrollDelegateFunc: ((UIScrollView)->Void)?
    var statisticModel: StatisticModel = StatisticModel()
    var statisticCategory: [StatisticCategory] = []
    var statisticCategoryApp: [StatisticCategoryApp] = []
    var timeType: ChooseTimeEnum = .day
    
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
        tableView.registerCells(cells: [StatisticCategoryCell.className, StatisticSumaryCell.className])
    }
    
    func prepareData() {
        guard let grId = group.groupid else { return }
        showLoading()
        GroupWorker.getStatistic(grId: grId, limit: timeType.rawValue) { [weak self] (statistic, error, responseCode) in
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
            return model.count > model2.count
        }).filter({ (cate) -> Bool in
            return cate.count > 0
        }) ?? []
        
        for item in statisticCategory {
            statisticCategoryApp += item.apps ?? []
        }
        statisticCategoryApp = statisticCategoryApp.sorted { (app1, app2) -> Bool in
            return app1.count > app2.count
        }.filter({ (app) -> Bool in
            return app.count > 0
        })
        
        let numTotalCate: CGFloat = CGFloat(statisticCategory.map({$0.count}).reduce(0, +))
        for item in statisticCategory {
            item.percent = item.count * 100 / Float(numTotalCate)
        }
        
        let numTotalCateApp: CGFloat = CGFloat(statisticCategoryApp.map({$0.count}).reduce(0, +))
        for item in statisticCategoryApp {
            item.percent = item.count * 100 / Float(numTotalCateApp)
        }
    }
}

extension GroupStatisticVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return statisticCategory.count
        } else {
            return statisticCategoryApp.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticSumaryCell.className) as? StatisticSumaryCell else {
                return UITableViewCell()
            }
            cell.bindingData(statit: statisticModel)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticCategoryCell.className) as? StatisticCategoryCell else {
                return UITableViewCell()
            }
            if indexPath.section == 1 {
                cell.bindingData(category: statisticCategory[indexPath.row])
            } else if indexPath.section == 2 {
                cell.bindingData(app: statisticCategoryApp[indexPath.row])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        } else {
            if section == 1 && statisticCategory.count == 0 { return UIView() }
            if section == 2 && statisticCategoryApp.count == 0 { return UIView() }
            let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 54))
            viewHeader.backgroundColor = UIColor.white
            let lineView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 6))
            lineView.backgroundColor = UIColor(hexString: "F7F8FA")
            viewHeader.addSubview(lineView)
            let label = UILabel(frame: CGRect(x: 16, y: 6, width: kScreenWidth - 32, height: 54))
            if section == 1 {
                label.text = "Nội dung dùng nhiều"
            } else if section == 2 {
                label.text = "Ứng dụng dùng nhiều"
            }
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            viewHeader.addSubview(label)
            return viewHeader
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0001
        } else {
            if section == 1 && statisticCategory.count == 0 { return 0.001 }
            if section == 2 && statisticCategoryApp.count == 0 { return 0.001 }
            return 54
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}

extension GroupStatisticVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollDelegateFunc != nil {
            self.scrollDelegateFunc!(scrollView)
        }
    }
}
