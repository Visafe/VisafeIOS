//
//  AddGroupVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/23/21.
//

import UIKit

class AddGroupVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configBarButtonItem()
    }
    
    func configBarButtonItem() {
        // left
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "cancel_icon"), style: .done, target: self, action: #selector(onClickLeftButton))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func onClickLeftButton() {
        dismiss(animated: true, completion: nil)
    }
}
