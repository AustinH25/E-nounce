//
//  ChatListTableViewController.swift
//  E-nounce
//
//  Created by austin huang on 11/12/19.
//  Copyright © 2019 Yu WenLiao. All rights reserved.
//

import UIKit
import Firebase

class ChatListTableViewController: UITableViewController {
    
    //MARK: Properties
    var Chats: [Chat] = []
    var user = LoginViewController.user
    let chatListRef = Database.database().reference(withPath: "Chats")
    var ref = Database.database().reference().childByAutoId()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsMultipleSelectionDuringEditing = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        chatListRef.queryOrderedByPriority().observe(.childAdded, with: { snapshot in
            let dbChatDict = snapshot.value as? [String: Any] ?? [:]
            let ChatID = snapshot.key
            
            let chat = Chat(ChatID: ChatID, dbStyleChat: dbChatDict)
            if !self.Chats.contains(chat){
                self.Chats.insert(chat, at: 0)
            }
            else {
                let oldChatIndex = self.Chats.firstIndex(of: chat)
                self.Chats.remove(at: oldChatIndex!)
                self.Chats.insert(chat, at: 0)
            }
            
            self.tableView.reloadData()
        })
        
        chatListRef.queryOrderedByPriority().observe(.childChanged, with: { snapshot in
            let dbChatDict = snapshot.value as? [String: Any] ?? [:]
            let ChatID = snapshot.key
            
            let chat = Chat(ChatID: ChatID, dbStyleChat: dbChatDict)
            if !self.Chats.contains(chat){
                self.Chats.insert(chat, at: 0)
            }
            else {
                let oldChatIndex = self.Chats.firstIndex(of: chat)
                self.Chats.remove(at: oldChatIndex!)
                self.Chats.insert(chat, at: 0)
            }
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatSegue"{
            let chatViewController = segue.destination as! ChatViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow!
            let chat = Chats [myIndexPath.row]
            chatViewController.ChatID = chat.ChatID
            chatViewController.title = chat.ChatName
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Chats.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        let chat = Chats[indexPath.row]
        

        // Configure the cell...
        cell.textLabel?.text = chat.ChatName
        guard let message = chat.lastMessage else {
            cell.detailTextLabel?.text = ""
            return cell
        }
        let senderName = message.sender.displayName
        switch message.kind {
        case .text:
            cell.detailTextLabel?.text = senderName + ": " + message.content
        case .location:
            cell.detailTextLabel?.text = senderName + " sent a location"
        default:
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    @IBAction func addButtonDidTouch(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Chat", message: "Name the new chat", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Create", style: .default) {_ in
            guard let textField = alert.textFields?.first, let chatName = textField.text else {return}
            
            let newChat = Chat(ChatID: "123", ChatName: chatName)
            //Add the new chat to the database
            let newChatRef = self.chatListRef.childByAutoId()
            newChatRef.setValue(newChat.toAnyObject(), andPriority: 0 + Date().timeIntervalSince1970)
           
            
            self.ref.child("users")
            
           
            // Add the id of the new chat to the user's chat
            let userChatListRef = Database.database().reference(withPath: "users/\(LoginViewController.user.displayName)/chats")
            userChatListRef.setValue(newChatRef.key!)
        
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

/*
// Override to support editing the table view.
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        // Delete the row from the data source
        tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

}
*/

/*
// Override to support conditional rearranging of the table view.
override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
}
*/

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/

