//
//  ChooseTimeView.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit
import SwiftMessages

public enum ChooseTimeEnum: Int {
    case day = 24
    case week = 168
    case month = 744
    
    func getTitle() -> String {
        switch self {
        case .day:
            return "Trong ngày"
        case .week:
            return "Trong tuần"
        case .month:
            return "Trong tháng"
        }
    }
    
    func getSubTitle() -> String {
        switch self {
        case .day:
            return "Hôm nay"
        case .week:
            return "Tuần này"
        case .month:
            return "Tháng này"
        }
    }
}

class ChooseTimeView: MessageView {

    @IBOutlet weak var tableView: UITableView!
    var chooseTimeAction:((_ type: ChooseTimeEnum) -> Void)?
    
    var sources = [ChooseTimeEnum.day, ChooseTimeEnum.week, ChooseTimeEnum.month]
    
    class func loadFromNib() -> ChooseTimeView? {
        return self.loadFromNib(withName: ChooseTimeView.className)
    }
    
    func binding() {
        tableView.registerCells(cells: [ChooseTimeCell.className])
        tableView.reloadData()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        SwiftMessages.hide()
    }
}

extension ChooseTimeView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChooseTimeCell.className) as? ChooseTimeCell else {
            return UITableViewCell()
        }
        cell.bindingData(type: sources[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        SwiftMessages.hide()
        chooseTimeAction?(sources[indexPath.row])
    }
    
}
