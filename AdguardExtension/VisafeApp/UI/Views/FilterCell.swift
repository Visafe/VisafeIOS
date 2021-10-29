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

import Foundation
import UIKit

class FilterCellUISwitch: UISwitch {
    var section: Int?
    var row: Int?
}

class FilterCell: UITableViewCell {
    
    var filter: Filter? {
        didSet{
            filterTagsView.filter = filter
            if filter?.searchAttributedString != nil {
                name.attributedText = filter?.searchAttributedString
            } else {
                name.text = filter?.name
            }
            if let versionString = filter?.version {
                version.text = String(format: ACLocalizedString("filter_version_format", nil), versionString)
            }
            let dateString = filter?.updateDate?.formatedStringWithHoursAndMinutes()
            updateDate.text = dateString == nil ? "" : String(format: ACLocalizedString("filter_date_format", nil), dateString ?? "")
            enableSwitch.isOn = filter?.enabled ?? false
            
        }
    }
    
    var group: Group? {
        didSet{
            let groupEnabled = group?.enabled ?? false
            contentView.isUserInteractionEnabled = groupEnabled
            contentView.alpha = groupEnabled ? 1.0 : 0.5
        }
    }
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var updateDate: UILabel!
    @IBOutlet weak var enableSwitch: FilterCellUISwitch!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
}
