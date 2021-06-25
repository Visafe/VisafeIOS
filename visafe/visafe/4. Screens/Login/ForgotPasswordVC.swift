//
//  ForgotPasswordVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/25/21.
//

import UIKit

class ForgotPasswordVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationItem()
    }

    func configNavigationItem() {
        // left
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "back_icon"), style: .done, target: self, action: #selector(onClickLeftButton))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func onClickLeftButton() {
        dismiss(animated: true, completion: nil)
    }
}
