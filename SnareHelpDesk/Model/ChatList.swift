//
//  ChatList.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/05.
//

import Foundation
import RealmSwift

class ChatList: Object {
    @objc dynamic var name = ""
    @objc dynamic var imageURL = ""
    let chatHistory = List<Message>()
}
