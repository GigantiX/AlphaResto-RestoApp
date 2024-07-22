//
//  String+extensions.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 24/06/24.
//

import Foundation

extension String {
    func isEmptyContainsWhitespace() -> Bool {
        self.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func isNumberOnly() -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: self)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func stringToDate(format: FormatType) -> Date {
        let df = DateFormatter()
        df.dateFormat = format.rawValue
        return df.date(from: self) ?? Date()
    }
}
