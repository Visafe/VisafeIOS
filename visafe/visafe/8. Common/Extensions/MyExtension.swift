//
//  MyExtension.swift
//  TripTracker
//
//  Created by Hung NV on 5/24/19.
//  Copyright © 2019 triptracker. All rights reserved.
//

import UIKit

extension String {
    static func nilOrEmpty(_ str:String?) -> Bool{
        if let str = str{
            return str.length == 0
        }
        return true
    }
    func toAttributeString(font:UIFont,color:UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString.init(string: self, attributes: [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor:color])
    }
    func toColor() -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

extension Int{
    func isCurrentUser() -> Bool {
        return self == UserManager.shared.current?.id
    }
    
    func isCurrentBusiness() -> Bool {
        return self == UserManager.shared.currentBusiness?.id
    }
}

extension UIColor{
    func toImage() -> UIImage? {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIView{
    func setBorder(_  borderColor:UIColor = UIColor.clear,cornerRadius:CGFloat = 0,borderWith:CGFloat = 0){
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWith
    }
}

extension UITableView{
    func setupTableView() {
        self.backgroundColor = AppColor.lightBlue
        self.estimatedRowHeight = 100
        self.rowHeight = UITableView.automaticDimension
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 50))
        footerView.backgroundColor = UIColor.clear
        self.tableFooterView = footerView
    }
}

extension UIImageView{
    func loadImage(urlString: String?) {
        if let avatarURL = urlString,let url = URL(string: avatarURL){
            self.sd_setImage(with:url)}
    }
}
extension Date{
    func toString(_ stringDateFormat:String) -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = stringDateFormat
        
        return formatter.string(from: self)
    }
}

extension Double {
    func toMoneyString(_ maxFrag: Int = 0) -> String {
//        let fm = NumberFormatter()
//        fm.groupingSeparator = ","
//        fm.groupingSize = 3
//        fm.groupingSeparator = "."
//        fm.maximumFractionDigits = maxFrag
//        fm.minimumIntegerDigits = 1
//        return fm.string(from: NSNumber(value: self)) ?? ""
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.maximumFractionDigits = maxFrag
        formatter.minimumFractionDigits = 0
        return formatter.string(from: self as NSNumber)!
    }
}

extension Array{
    func objectAt(_ index:Int) -> Element?{
        if index < count && index >= 0{
            return self[index]
        }
        return nil
    }
}

extension Int{
    func toDate()->Date{
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
    func toDateString() -> String {
        return toDate().toString("yyyy-MM-dd")
    }
}
extension TimeInterval{
    func toDate()->Date{
        return Date(timeIntervalSince1970: self)
    }
    func toDateString() -> String {
        return toDate().toString("yyyy-MM-dd")
    }
}

extension NSMutableAttributedString{
    func addAtribute(font:UIFont,color:UIColor, forString:String) {
        let range = NSString(string: self.string).range(of: forString)
        self.addAttributes([NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor:color], range: range)
    }
}
