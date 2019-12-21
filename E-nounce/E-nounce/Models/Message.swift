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
    
    let chatId: String
    let messageId: String
    var kind: MessageKind
    let content: String
    var sentDate: Date
    var sender: SenderType
    
    var downloadURL: URL? = nil
    var location:CoordinateItem? = nil
    
    init(user: User, content: String, chatId: String) {
        sender = User(senderId: user.senderId, displayName: user.displayName)
        self.content = content
        sentDate = Date()
        kind = MessageKind.text(content)
        messageId = "1"
        self.chatId = chatId
    }
    
    init(location: CLLocation, user: User, chatId: String){
        self.location = CoordinateItem(location: location)
        sender = User(senderId: user.senderId, displayName: user.displayName)
        self.content = ""
        sentDate = Date()
        kind = MessageKind.location(self.location!)
        messageId = "1"
        self.chatId = chatId
    }
    
    init(messageId: String, dbStyledMessage: [String: Any ]){
        self.messageId = messageId
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
        let origDateStr = dbStyledMessage["created"] as! String
        sentDate = formatter.date(from: origDateStr)!
        chatId = dbStyledMessage["chatId"] as! String
        sender = User(senderId: dbStyledMessage["senderId"] as! String, displayName: dbStyledMessage["senderName"] as! String)
        guard let messageKind = dbStyledMessage["messageKind"] else{
            content = dbStyledMessage["content"] as! String
            kind = MessageKind.text(content)
            return
        }
        switch messageKind as! String {
        case "text":
            content = dbStyledMessage["content"] as! String
            kind = MessageKind.text(content)
        case "location":
            content = ""
            let lat  = dbStyledMessage["location_lat"] as! Double
            let lon = dbStyledMessage["location_lon"] as! Double
            let locationItem = CLLocation(latitude: lat, longitude: lon)
            location = CoordinateItem(location: locationItem)
            kind = MessageKind.location(location!)
        default:
            content = dbStyledMessage["content"] as! String
            kind = MessageKind.text(content)
        }
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
            "senderName": sender.displayName,
            "chatId": chatId
            
        ]
        
        switch kind{
        case .text:
            toReturn["messageKind"] = "text"
            toReturn["content"] = content
        case .location:
            toReturn["messageKind"] = "location"
            toReturn["location_lat"] = location?.location.coordinate.latitude
            toReturn["location_lon"] = location?.location.coordinate.longitude
        default:
            toReturn["content"] = content
        }
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
