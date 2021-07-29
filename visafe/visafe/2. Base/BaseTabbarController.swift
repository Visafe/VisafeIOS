//
//  BaseTabbarController.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit
import ESTabBarController_swift

class BaseTabbarController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func present(_ viewControllerToPresent: UIViewController,
                            animated flag: Bool,
                            completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
