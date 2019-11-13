//
//  ChatViewController.swift
//  E-nounce
//
//  Created by austin huang on 11/1/19.
//  Copyright © 2019 Yu WenLiao. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseDatabase


class ChatViewController: MessagesViewController {
    private var messages: [Message] = []
    private let inputBar = InputBarAccessoryView()
    private var chatRef = Database.database().reference(withPath: "chat")
    private var user = LoginViewController.user
    
    public var ChatID: String?
    
    override var inputAccessoryView: UIView? {return inputBar}
        
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate  = self
        messagesCollectionView.messageCellDelegate = self
        inputBar.delegate = self
        
        let testMessage = Message(user: User(senderId: "Austin", displayName: "Austin"), content: "Hi")
        save(testMessage)
        insertNewMessage(testMessage)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
        chatRef.queryOrderedByPriority().observe(.childAdded, with:{snapshot in
            let dbMessageDict = snapshot.value as? [String: Any] ?? [:]
            let messageID = snapshot.key
            let message = Message(messageId: messageID, dbStyledMessage: dbMessageDict)
            self.insertNewMessage(message)
        })
    }
    
    
    // MARK: Helpers
    private func insertNewMessage(_ message: Message){
        guard !messages.contains(message) else{
            return
        }
        
        messages.append(message)
        messages.sort()
        
        messagesCollectionView.reloadData()
    }
    
    private func save(_ message:Message){
        chatRef.childByAutoId().setValue(message.toAnyObject(), andPriority: 0-Date().timeIntervalSince1970)
        self.messagesCollectionView.scrollToBottom()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ChatViewController: MessagesDataSource{
    func currentSender() -> SenderType {
        return Sender(id: "Austin", displayName: "Austin")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}

extension ChatViewController:MessagesDisplayDelegate{
    
}

extension ChatViewController:MessagesLayoutDelegate{
    
}
extension ChatViewController:MessageCellDelegate{
    
}
extension ChatViewController:InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(user: LoginViewController.user, content: text)
        save(message)
        
        inputBar.inputTextView.text = ""
    }
    
}
