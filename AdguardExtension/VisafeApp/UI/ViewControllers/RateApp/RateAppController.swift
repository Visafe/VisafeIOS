/**
      This file is part of Visafe for iOS (https://github.com/VisafeTeam/VisafeForiOS).
      Copyright © Visafe Software Limited. All rights reserved.

      Visafe for iOS is free software: you can redistribute it and/or modify
      it under the terms of the GNU General Public License as published by
      the Free Software Foundation, either version 3 of the License, or
      (at your option) any later version.

      Visafe for iOS is distributed in the hope that it will be useful,
      but WITHOUT ANY WARRANTY; without even the implied warranty of
      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
      GNU General Public License for more details.

      You should have received a copy of the GNU General Public License
      along with Visafe for iOS.  If not, see <http://www.gnu.org/licenses/>.
*/

import UIKit

class RateAppController: BottomAlertController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var rateAppButton: UIButton!
    @IBOutlet weak var haveAProblemButton: UIButton!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    // Services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = String.localizedString("rate_app_description")
        
        rateAppButton.makeTitleTextUppercased()
        rateAppButton.applyStandardGreenStyle()
        
        haveAProblemButton.makeTitleTextUppercased()
        haveAProblemButton.applyStandardOpaqueStyle()
        
        updateTheme()
    }
    
    // MARK: - Actions
    
    @IBAction func rateAppTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            UIApplication.shared.openAppStoreToRateApp()
        }
    }
    
    @IBAction func haveAProblemTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            AppDelegate.shared.presentRateAppProblemController()
        }
    }
}

extension RateAppController: ThemableProtocol {
    func updateTheme() {
        titleLabel.textColor = theme.popupTitleTextColor
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupLabels(themableLabels)
    }
}
