//
//  ActionViewController.swift
//  Report
//
//  Created by Nguyễn Tuấn Vũ on 12/10/2021.
//

import UIKit
import MobileCoreServices
//import Alamofire
//import SwifterSwift

class ActionViewController: UIViewController {

    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var nameInfoLabel: UILabel!
    var convertedString: String?
    var isReporting = false
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStateButtonContinue()

        guard let item: NSExtensionItem = self.extensionContext?.inputItems.first as? NSExtensionItem else { return }
        guard let itemProvider = item.attachments?.first else { return }
        if !itemProvider.hasItemConformingToTypeIdentifier("public.url") {
            return
        }

        itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) {[weak self] (results, error) in
            guard let self = self, let url = results as? URL else { return }
            var text = url.absoluteString
            if text.last == "/" {
                text.removeLast()
            }
            DispatchQueue.main.async {
                self.nameTextfield.text = text
                self.updateStateButtonContinue()
            }
        }

    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

    @IBAction func reportAction(_ sender: Any) {
        if validateInfo() && !isReporting {
            isReporting = true
            CommonWorker.reportWebsite(url: nameTextfield.text!) { [weak self] (result, error, _) in
                guard let weakSelf = self else { return }
                weakSelf.isReporting = false
                weakSelf.done()
            }
        }
    }

    func validateInfo() -> Bool {
        var success = true
        let name = nameTextfield.text ?? ""
        if name.isEmpty {
            DispatchQueue.main.async {
                self.nameInfoLabel.text = "Link website không được để trống"
            }
            success = false
        } else if !name.isValidUrl {
            DispatchQueue.main.async {
                self.nameInfoLabel.text = "Link website không đúng định dạng"
            }
            success = false
        }
        return success
    }

    func updateStateButtonContinue() {
        DispatchQueue.main.async {
            if (self.nameTextfield.text?.count ?? 0) == 0 {
                self.reportButton.backgroundColor = UIColor(hexString: "F8F8F8")
                self.reportButton.setTitleColor(UIColor(hexString: "111111"), for: .normal)
                self.reportButton.isUserInteractionEnabled = false
            } else {
                self.reportButton.backgroundColor = UIColor(hexString: "FFB31F")
                self.reportButton.setTitleColor(UIColor.white, for: .normal)
                self.reportButton.isUserInteractionEnabled = true
            }
        }
    }

    @IBAction func valueChanged(_ sender: UITextField) {
        updateStateButtonContinue()
    }

}
extension String {
    var isValidUrl: Bool {
        var string: String
        if self.hasPrefix("http") {
            string = self
        } else {
            string = "http://\(self)"
        }
        let regex = "http[s]?://(([^/:.[:space:]]+(.[^/:.[:space:]]+)*)|([0-9](.[0-9]{3})))(:[0-9]+)?((/[^?#[:space:]]+)([^#[:space:]]+)?(#.+)?)?"
        return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: string)
    }
}

extension UIColor {
    convenience init?(hexString: String, transparency: CGFloat = 1) {
        var string = ""
        if hexString.lowercased().hasPrefix("0x") {
            string =  hexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.hasPrefix("#") {
            string = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            string = hexString
        }

        if string.count == 3 { // convert hex to 6 digit format if in short format
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }

        guard let hexValue = Int(string, radix: 16) else { return nil }

        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }

        let red = (hexValue >> 16) & 0xff
        let green = (hexValue >> 8) & 0xff
        let blue = hexValue & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }

    convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        guard red >= 0 && red <= 255 else { return nil }
        guard green >= 0 && green <= 255 else { return nil }
        guard blue >= 0 && blue <= 255 else { return nil }

        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
}
