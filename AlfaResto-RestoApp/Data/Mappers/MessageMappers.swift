//
//  MessageMappers.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 29/06/24.
//

import Foundation
import MessageKit

class MessageMappers {
    static func mapChatToMessage(chat: Chats) -> Message {
        let user = UserMessage(senderId: chat.senderID, displayName: chat.senderName ?? "")
        let messageId = UUID().uuidString
        let sentDate = chat.dateSend
        let messageKind = MessageKind.text(chat.message)
        
        return Message(sender: user, messageId: messageId, sentDate: sentDate, kind: messageKind)
    }
}
