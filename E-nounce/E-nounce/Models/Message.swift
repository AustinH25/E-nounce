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
    
    init(messageId: String, dbStyledMessage: [String: Any ]){
        self.messageId = messageId
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
        let origDateStr = dbStyledMessage["created"] as! String
        sentDate = formatter.date(from: origDateStr)!
        sender = User(senderId: dbStyledMessage["senderId"] as! String, displayName: dbStyledMessage["senderName"] as! String)
        content = dbStyledMessage["content"] as! String
        kind = MessageKind.text(content)
        
    }
    
    func toAnyObject() -> Any{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let sentDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyy HH:mm:ss"
        let myStringafd = formatter.string(from: sentDate!)
        
        var toReturn:[String:Any] = [
            "created": myStringafd,
            "senderId": sender.senderId,
            "senderName": sender.displayName
            
        ]
        toReturn["content"] = content
        return toReturn
        
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
