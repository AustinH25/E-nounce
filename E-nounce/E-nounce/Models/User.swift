import Foundation
import Firebase
import MessageKit

struct User:SenderType{
    
    var senderId: String
    var displayName: String
    var email: String
    
    init(authData: Firebase.User){
        senderId = authData.uid
        displayName = authData.email!
        email = authData.email!
    }
    init(senderId: String, displayName: String)
    {
        self.senderId = senderId
        self.displayName = displayName
        self.email = displayName
        
    }
}
