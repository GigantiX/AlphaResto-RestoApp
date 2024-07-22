//
//  Chats.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 29/06/24.
//

import Foundation
import MessageKit

struct Chats: Codable {
    let senderID: String
    let senderName: String?
    let dateSend: Date
    let message: String
    
    enum CodingKeys: String, CodingKey{
        case senderID = "sender_id"
        case senderName = "user_name"
        case dateSend = "date_send"
        case message
    }
}
