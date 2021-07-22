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
            let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
            return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
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
}

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}

