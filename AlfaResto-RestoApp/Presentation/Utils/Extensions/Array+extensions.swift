//
//  Array+extensions.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 18/06/24.
//

import Foundation

extension Array {
    func item(at index: Int) throws -> Element {
        guard index >= 0 && index < count else {
            throw AppError.outOfRange
        }
        return self[index]
    }
}
