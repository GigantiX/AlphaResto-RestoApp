//
//  Message.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 29/06/24.
//

import Foundation
import MessageKit

struct UserMessage: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
