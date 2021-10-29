//
//  OnboardingChildVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/6/21.
//

import UIKit

class OnboardingChildVC: BaseViewController {

    var type: OnboardingEnum
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    init(type: OnboardingEnum) {
        self.type = type
        super.init(nibName: OnboardingChildVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        iconImageView.image = type.getIconImage()
        titleLabel.text = type.getTitle()
        contentLabel.text = type.getContent()
    }
}
