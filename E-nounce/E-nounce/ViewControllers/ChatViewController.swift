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
    private var chatRef = Database.database().reference(withPath: "Chat")
    private var chatParentRef = Database.database().reference(withPath:"Chats/") //
    private var lastMessageRef = Database.database().reference(withPath: "Chats/")
    
    private var user = LoginViewController.user
    
    public var ChatID: String?
    
    private let inputBar = customInputBarAccessoryViewController()
     
    override var inputAccessoryView: UIView? {return inputBar}
        
    override func viewDidLoad() {
        super.viewDidLoad()
        chatRef = Database.database().reference(withPath: "Chats/" + ChatID! + "/chat")
        chatParentRef = Database.database().reference(withPath: "Chats/" + ChatID!)
        lastMessageRef = Database.database().reference(withPath: "Chats/" + ChatID! + "/lastMessage")
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate  = self
        messagesCollectionView.messageCellDelegate = self
        inputBar.delegate = self
        inputBar.customDelegate = self
        
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
        
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom{
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    private func save(_ message:Message){
        let newPriority = 0 - Date().timeIntervalSince1970
        chatRef.childByAutoId().setValue(message.toAnyObject(), andPriority: newPriority)
        chatParentRef.setPriority(newPriority * -1)
        lastMessageRef.setValue(message.toAnyObject())
        self.messagesCollectionView.scrollToBottom()
    }

    public static func save(message:Message, ChatID:String){
        let newPriority = 0 - Date().timeIntervalSince1970
        Database.database().reference(withPath: "Chats/" + ChatID).setPriority(newPriority * -1)
        Database.database().reference(withPath: "Chats/" + ChatID + "/chat").childByAutoId().setValue(message.toAnyObject(), andPriority: newPriority)
        Database.database().reference(withPath: "Chats/" + ChatID + "/lastMessage").setValue(message.toAnyObject())
    }
    
    private func needsTimeStamp(at indexPath: IndexPath) ->Bool{
        if(indexPath.section == 0)
        {
            return true
        }
        return messages[indexPath.section].sentDate.timeIntervalSince(messages[indexPath.section-1].sentDate) > 60
    }
    
    private func needsSenderLabel(at indexPath: IndexPath) -> Bool{
        if(indexPath.section == 0)
        {
            return true
        }
        return messages[indexPath.section].sender.senderId != messages[indexPath.section-1].sender.senderId
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
        return user
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let messageInfo = messages[indexPath.section]
        return MessageKitDateFormatter.shared.attributedString(from: messageInfo.sentDate, with: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let messageInfo = messages[indexPath.section]
        return NSAttributedString(string: messageInfo.sender.displayName, attributes: [NSAttributedString.Key.font:UIFont.preferredFont(forTextStyle: .caption1)])
    }
}

extension ChatViewController:MessagesDisplayDelegate{
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.red : UIColor.yellow
    }
    
}

extension ChatViewController:MessagesLayoutDelegate{
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if (needsTimeStamp(at: indexPath))
        {
            return 18
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if(needsSenderLabel(at: indexPath) || needsTimeStamp(at: indexPath))
        {
            return 28
        }
        return 0
    }
    
} 
extension ChatViewController:MessageCellDelegate{
    func didTapMessage(in cell: MessageCollectionViewCell){
        inputBar.inputTextView.resignFirstResponder()
        
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else{ return }
        let messageInfo = messages[indexPath.section]
        switch messageInfo.kind {
        case .location:
            MainMenuViewController.openLocationFromCoords(messageInfo.location!.location)
        default:
            return
        }
    }
    
}

extension ChatViewController:InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(user: LoginViewController.user, content: text, chatId: ChatID!)
        save(message)
        
        inputBar.inputTextView.text = ""
    }
    
}

extension ChatViewController:customInputAccessoryViewDelegate{
    func locationButtonPressed() {
        guard let currentLocation = MainMenuViewController.instanceRef?.currentLocation else {
            return
        }
        let message = Message(location: currentLocation, user: user, chatId: ChatID!)
        save(message)
    }
}
