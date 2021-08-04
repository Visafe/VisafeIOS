//
//  ProtectHomeType.swift
//  visafe
//
//  Created by QuocNV on 8/3/21.
//

import Foundation
import UIKit
public enum ProtectHomeType {
    case device
    case wifi

    func getImage() -> UIImage? {
        switch self {
        case .device:
            return UIImage(named: "dp_device_item")
        case .wifi:
            return UIImage(named: "dp_wifi_item")
        }
    }

    func getTitle() -> String {
        switch self {
        case .device:
            return "Bảo vệ thiết bị"
        case .wifi:
            return "Bảo vệ Wi-Fi"
        }
    }

    func getContent() -> String {
        switch self {
        case .device:
            return "Nếu phát hiện trang web nguy hại hay giả mạo, chúng tôi sẽ chặn những website đó"
        case .wifi:
            return "Nếu phát hiện mã độc nào trong Wi-Fi bạn sử dụng, chúng tôi sẽ cảnh báo"
        }
    }

    func getTitleNavi() -> String {
        switch self {
        case .device:
            return "Bảo vệ thiết bị"
        case .wifi:
            return "Bảo vệ Wi-Fi"
        }
    }

    func getTitleContentView() -> String {
        switch self {
        case .device:
            return "Các nguy hại đã chặn"
        case .wifi:
            return "Các mã độc đã phát hiện"
        }
    }

    func getTopImage() -> UIImage? {
        switch self {
        case .device:
            return UIImage(named: "dp_device")
        case .wifi:
            return UIImage(named: "dp_wifi")
        }
    }

    func getTopImagePositive() -> UIImage? {
        switch self {
        case .device:
            return UIImage(named: "dp_device_error")
        case .wifi:
            return UIImage(named: "dp_wifi_error")
        }
    }

    func getTopTitle() -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let highlightColor: UIColor = .systemGreen
        var text = "Thiết bị này đã được bảo vệ"
        var highlightText = "được bảo vệ"
        switch self {
        case .device: break
        case .wifi:
            text = "Wi-Fi đang sử dụng an toàn"
            highlightText = "an toàn"
        }
        let attributedText = NSMutableAttributedString(string: text,
                                                       attributes: [.font : font,
                                                                    .foregroundColor: highlightColor])
        attributedText.addAttributes([.font : font,
                                      .foregroundColor: UIColor(hexString: "222222")!],
                                     range: NSRange(location: 0,
                                                    length: text.count - highlightText.count))
        return attributedText
    }

    func getTopTitlePositive() -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let highlightColor: UIColor = .systemRed
        var text = "Thiết bị này không được bảo vệ"
        var highlightText = "không được bảo vệ"
        switch self {
        case .device: break
        case .wifi:
            text = "Wi-Fi đang sử dụng không được bảo vệ"
            highlightText = "không được bảo vệ"
        }
        let attributedText = NSMutableAttributedString(string: text,
                                                       attributes: [.font : font,
                                                                    .foregroundColor: highlightColor])
        attributedText.addAttributes([.font : font,
                                      .foregroundColor: UIColor(hexString: "222222")!],
                                     range: NSRange(location: 0,
                                                    length: text.count - highlightText.count))
        return attributedText
    }

    func getTopContent() -> String {
        switch self {
        case .device:
            return "iPhone của Bao Ngoc"
        case .wifi:
            return "Pit Studio 5GHz"
        }
    }

    // Todo:
    func getTypeQueryLog() -> QueryLogTypeEnum {
        switch self {
        case .wifi:
            return .ads_blocked
        case .device:
            return .native_tracking
        }
    }
}
