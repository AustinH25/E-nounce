//
//  Chat.swift
//  E-nounce
//
//  Created by austin huang on 11/12/19.
//  Copyright © 2019 Yu WenLiao. All rights reserved.
//

import Foundation

struct Chat {
    let ChatID: String
    var ChatName: String
    var lastMessage: Message?
    
    init(ChatID:String, ChatName:String){
        self.ChatID = ChatID
        self.ChatName = ChatName
    }
    
    init(ChatID: String, dbStyleChat: [String:Any]){
        self.ChatID = ChatID
        ChatName = dbStyleChat["ChatName"] as! String
        guard dbStyleChat["lastMessage"] != nil else {
            return
        }
        lastMessage = Message(messageId: "123", dbStyledMessage: dbStyleChat["lastMessage"] as! [String:Any])
    }
    
    func toAnyObject() -> Any{
        var toReturn: [String: Any] = [
            "ChatID": ChatID,
            "ChatName": ChatName
        ]
        guard let message = lastMessage else {
            return toReturn
        }
        
        toReturn["lastMessage"] = message.toAnyObject()
        return toReturn
    }
}

extension Chat:Comparable{
    static func == (lhs: Chat, rhs: Chat) -> Bool{
        return lhs.ChatID == rhs.ChatID
    }
    
    static func < (lhs: Chat, rhs: Chat) -> Bool{
        guard let leftMessage = lhs.lastMessage else{
            return false
        }
        
        guard let rightMessage = rhs.lastMessage else{
            return false
        }
        
        return leftMessage < rightMessage
    }
}
