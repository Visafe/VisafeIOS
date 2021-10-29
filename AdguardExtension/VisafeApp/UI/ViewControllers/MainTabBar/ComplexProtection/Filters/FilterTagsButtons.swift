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

protocol TagButtonTappedDelegate: class {
    func tagButtonTapped(_ sender: TagButton)
}

protocol FilterTagsViewModel: class {
    var delegate: TagButtonTappedDelegate? { get set }
}

protocol SendTagNameButtonProtocol: FilterTagsViewModel {
    var name: String? { get set }
    func sendName(_ sender: TagButton)
}

class TagButton: RoundRectButton, SendTagNameButtonProtocol{
    
    init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(self.sendName(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    weak var delegate: TagButtonTappedDelegate?
    
    var name: String?
    
    @objc func sendName(_ sender: TagButton) {
        delegate?.tagButtonTapped(sender)
    }
}
