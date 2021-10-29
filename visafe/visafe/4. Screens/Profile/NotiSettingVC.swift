//
//  ProfileVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/8/21.
//

import UIKit

class NotiSettingVC: BaseViewController {

    @IBOutlet weak var dailyReportButton: UIButton!
    @IBOutlet weak var ncscReportButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func configView() {
        title = "Cấu hình thông báo"
    }
}
