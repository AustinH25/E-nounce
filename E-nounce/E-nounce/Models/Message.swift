//
//  Message.swift
//  E-nounce
//
//  Created by austin huang on 11/1/19.
//  Copyright © 2019 Yu WenLiao. All rights reserved.
//
import Foundation
import FirebaseDatabase
import MessageKit
import CoreLocation

struct Message:MessageType {
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var downloadURL: URL? = nil
    
    var kind: MessageKind
    let content: String
    
    init(user: User, content: String) {
        sender = User(senderId: user.senderId, displayName: user.displayName)
        self.content = content
        sentDate = Date()
        kind = MessageKind.text(content)
        messageId = "1"
    }
    
}

extension Message:Comparable{
    static func == (lhs: Message, rhs: Message) -> Bool{
        return lhs.messageId == rhs.messageId
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool{
        return lhs.sentDate < rhs.sentDate
    }
}
