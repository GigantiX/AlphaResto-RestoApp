//
//  Int+extensions.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 03/07/24.
//

import Foundation

extension Int {
    func formatToRupiah() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "IDR"
        formatter.currencySymbol = "Rp. "
        formatter.maximumFractionDigits = 0
        formatter.groupingSeparator = "."
        formatter.locale = Locale(identifier: "id_ID")
        
        return formatter.string(from: NSNumber(value: self)) ?? "Rp. 0"
    }
}
