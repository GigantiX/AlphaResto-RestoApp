//
//  AuthDataResultModel.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 14/06/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
}

extension AuthDataResultModel {
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}
