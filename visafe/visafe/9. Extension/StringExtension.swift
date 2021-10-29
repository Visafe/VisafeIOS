//
//  StringExtension.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/29/21.
//

import UIKit

extension String {
    func isValidPhone() -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
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
    
    /// Returns the first element of the collection of string. If a collection
    /// is empty, returns nil.
    var first: Character? {
        if isEmpty {
            return nil
        }
        return self[index(startIndex, offsetBy: 0)]
    }
    
    
    func getLetterString() -> String {
        var letters = String()
        // Obtains an array of words by using a given username
        let components = self.components(separatedBy: " ")
        // If there are whether two words or more
        if components.count > 1 {
            for component in components.prefix(2) {
                if let letter = component.first {
                    letters.append(letter.uppercased())
                }
            }
        } else {
            // If given just one word
            if let component = components.first {
                // Process the firs name letter
                if let letter = component.first {
                    letters.append(letter.uppercased())
                }
            }
        }
        return letters
    }
    
    func getQueryStringParameter(queryParam: String) -> String? {
        if queryParam == "groupId" {
            var result: String = ""
            for i in 57...92 {
                result = result + self[i]
            }
            return result
        } else if queryParam == "groupName" {
            return self.substring(fromIndex: 104)
        }
        return nil
    }
}

extension String {
    func regex (pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0))
            let nsstr = self as NSString
            let all = NSRange(location: 0, length: nsstr.length)
            var matches : [String] = [String]()
            regex.enumerateMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: all) {
                (result : NSTextCheckingResult?, _, _) in
                if let r = result {
                    let result = nsstr.substring(with: r.range) as String
                    matches.append(result)
                }
            }
            return matches
        } catch {
            return [String]()
        }
    }
    
    func checkInviteDevicelink() -> String? {
        if !self.contains("https://app.visafe.vn/api/v1/group/invite/device") ||
            !self.contains("groupId") ||
            !self.contains("groupName") {
            return nil
        }
        return self
        
    }
    
    func checkPaymentlink() -> String? {
        if !self.contains("partnerCode") || !self.contains("accessKey") || !self.contains("requestId") || !self.contains("signature"){
            return nil
        }
        return self
    }
    
    func getGroupId(text: String) -> String {
        var result: String = ""
        for i in 57...92 {
            result = result + text[i]
        }
        return result
    }
    
    func getGroupName(text: String) -> String {
        return text.substring(fromIndex: 114)
    }

    func encodeUrl() -> String? {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    func decodeUrl() -> String? {
        return self.removingPercentEncoding
    }
}

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}

extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}

extension URL {
    public var queryParameters: [String: Any]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: Any]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
