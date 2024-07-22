//
//  AppError.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 18/06/24.
//

import Foundation

enum AppError: Error {
    case texiFieldIsEmpty
    case networkDisconnected
    case unexpectedError
    case outOfRange
    case errorUploadImage
    case errorFetchData
}
