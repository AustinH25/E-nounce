//
//  MainMenuViewController.swift
//  E-nounce
//
//  Created by austin huang on 10/18/19.
//  Copyright © 2019 Yu WenLiao. All rights reserved.
//

import UIKit
import Firebase

class MainMenuViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var user = User(senderId: "", displayName: "")
    let usersRef = Database.database().reference(withPath: "online")
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let cur = pages.firstIndex(of: viewController)!
        
        let prev = cur - 1
        return (prev == -1) ? nil : pages[prev]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let cur = pages.firstIndex(of: viewController)!
        
        let nxt = cur + 1
        return (nxt == pages.count) ? nil: pages[nxt]
    }
    
    
    var pages = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        let sosPage: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "homeScreen1")
        let menuPage: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "homeScreen2")
        let chatPage: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "homeScreen3")

        pages.append(menuPage)
        pages.append(sosPage)
        pages.append(chatPage)


        setViewControllers([sosPage], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener{auth, user in
            guard let user = user else {return}
            // guard. set variable to something(an if statement for variable)
            self.user = User(authData: user)
            let currentUserRef = self.usersRef.child(user.uid)
            currentUserRef.setValue(user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if snapshot.value as? Bool ?? false{
                let currentUsersRef = self.usersRef.child(self.user.senderId)
                currentUsersRef.setValue(self.user.email)
                currentUsersRef.onDisconnectRemoveValue()
            }
        })
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
