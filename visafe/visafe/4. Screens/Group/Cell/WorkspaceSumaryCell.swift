//
//  WorkspaceSumaryCell.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/25/21.
//

import UIKit

class WorkspaceSumaryCell: BaseTableCell {
    
    var actionChooseTime:(() -> Void)?
    var actionChangeWorkspace:(() -> Void)?
    var actionCreateGroup:(() -> Void)?
    
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var workspaceNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var blockedLabel: UILabel!
    @IBOutlet weak var violationLabel: UILabel!
    @IBOutlet weak var dangerousLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindingData(statistic: StatisticModel, timeType: ChooseTimeEnum) {
        blockedLabel.text = "\(statistic.num_ads_blocked ?? 0)"
        violationLabel.text = "\(statistic.num_violation ?? 0)"
        dangerousLabel.text = "\(statistic.num_dangerous_domain ?? 0)"
        timeLabel.text = timeType.getTitle()
        workspaceNameLabel.text = CacheManager.shared.getCurrentWorkspace()?.name
        summaryView.dropShadow(color: .lightGray, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 24, scale: true)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    @IBAction func chooseTimeAction(_ sender: Any) {
        actionChooseTime?()
    }
    
    @IBAction func changeWorkspaceAction(_ sender: Any) {
        actionChangeWorkspace?()
    }
    
    @IBAction func createGroupAction(_ sender: Any) {
        actionCreateGroup?()
    }
}
