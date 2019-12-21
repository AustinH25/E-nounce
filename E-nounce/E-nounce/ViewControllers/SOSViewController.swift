//
//  SOSViewController.swift
//  E-nounce
//
//  Created by austin huang on 11/22/19.
//  Copyright © 2019 Yu WenLiao. All rights reserved.
//

import UIKit
import Firebase

class SOSViewController: UIViewController {
    @IBOutlet public weak var userLabel: UILabel!
    public static var instanceRef: SOSViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLabel.text = LoginViewController.user.displayName
        SOSViewController.instanceRef = self

        // Do any additional setup after loading the view.
    }
    

    @IBAction func SOSButtonClicked(_ sender: UIButton) {
        let user = MainMenuViewController.instanceRef?.user
        let location = MainMenuViewController.instanceRef?.currentLocation
        
        Database.database().reference(withPath: "Chats").observe(.childAdded, with:{ snapshot in
            let ChatId = snapshot.key
            let emergencyMessageLocation = Message(location: location!, user: user!, chatId: ChatId)
            ChatViewController.save(message: emergencyMessageLocation, ChatID: ChatId)
            let emergencyMessage = Message(user:user!, content: user!.displayName + " sent an SOS!", chatId: ChatId)
            ChatViewController.save(message: emergencyMessage, ChatID: ChatId)
        })
        
        let alert = UIAlertController(title: "SOS Sent", message: "Your SOS message has been sent", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true)
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
