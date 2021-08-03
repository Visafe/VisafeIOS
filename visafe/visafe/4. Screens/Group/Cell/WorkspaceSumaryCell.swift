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
    @IBOutlet weak var descriptionWorkspaceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindingData(statistic: StatisticModel, timeType: ChooseTimeEnum) {
        blockedLabel.text = "\(statistic.num_ads_blocked)"
        violationLabel.text = "\(statistic.num_violation)"
        dangerousLabel.text = "\(statistic.num_dangerous_domain)"
        timeLabel.text = timeType.getTitle()
        let workspace = CacheManager.shared.getCurrentWorkspace()
        workspaceNameLabel.text = workspace?.name
        if workspace?.type == .enterprise {
            descriptionWorkspaceLabel.text = "Bảo vệ tổ chức của bạn trên môi trường mạng"
        } else {
            descriptionWorkspaceLabel.text = "Bảo vệ gia đình & người thân trên môi trường mạng"
        }
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
