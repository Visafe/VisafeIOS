//
//  DashboardVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit

class DashboardVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func refreshData() {
        if isViewLoaded {
        }
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        let vc = LoginVC()
        present(vc, animated: true)
    }
}
