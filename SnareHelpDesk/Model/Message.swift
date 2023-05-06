//
//  Message.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/05.
//

import MessageKit
import UIKit
import InputBarAccessoryView
import RealmSwift
import OpenAISwift


enum userType {
    case me
    case you
    case system
    var data: Sender {
        switch self {
        case .me:
            return Sender(senderId: "001", displayName: "Me")
        case .you:
            return Sender(senderId: "002", displayName: "You")
        case .system:
            return Sender(senderId: "000", displayName: "system")
        }
    }
}

class Sender: Object, SenderType {
    @objc dynamic var senderId: String = ""
    @objc dynamic var displayName: String = ""

    convenience init(senderId: String, displayName: String) {
        self.init()
        self.senderId = senderId
        self.displayName = displayName
    }
}


class Message: Object, MessageType {

    @objc dynamic var messageId: String = ""
    @objc dynamic var senderObject: Sender? = nil
    @objc dynamic var sentDate: Date = Date()
    @objc dynamic var textContent: String = ""
    var parentCategory = LinkingObjects(fromType: ChatList.self, property: "chatHistory")

    var sender: SenderType {
        get {
            return senderObject!
        }
    }

    var kind: MessageKind {
        return .text(textContent)
    }

    var role: ChatRole {
        switch sender.senderId {
        case "000":
            return .system
        case "001":
            return .user
        case "002":
            return .assistant
        default:
            return .user
        }
    }


    convenience init(messageId: String, sender: Sender, sentDate: Date, kind: MessageKind) {
        self.init()
        self.messageId = messageId
        self.senderObject = sender
        self.sentDate = sentDate

        switch kind {
        case .text(let content):
            self.textContent = content
        default: break
        }
    }


    static func createMessage(text: String, user: userType) -> Message {
        return Message(messageId: UUID().uuidString, sender: user.data, sentDate: Date(), kind: .text(text))
    }

    static func convertToChatMessage(with mocks: [Message]) -> [ChatMessage]{
        let messages = mocks.map { ChatMessage(role: $0.role, content: $0.textContent) }
        return messages
    }

}
