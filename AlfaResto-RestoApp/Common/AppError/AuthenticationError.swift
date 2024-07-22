//
//  AuthenticationError.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 14/06/24.
//

import Foundation

enum AuthenticationError: Error {
    case invalidData
    case userAlreadyExists
    case logoutError
}
