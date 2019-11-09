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
    
    override var inputAccessoryView: UIView? {return inputBar}
    
    override var canResignFirstResponder: Bool {return false}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate  = self
        messagesCollectionView.messageCellDelegate = self
        inputBar.delegate = self
        
        let testMessage = Message(user: User(senderId: "Austin", displayName: "Austin"), content: "Hi")
        insertNewMessage(testMessage)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
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
    
}
