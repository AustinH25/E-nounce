//
//  LoginViewController.swift
//  E-nounce
//
//  Created by Austin Huang on 10/11/19.
//  Copyright © 2019 Yu WenLiao. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    let transitionID: String = "loginToMainMenu"
    public static var user = User(senderId: "", displayName: "")
    
    var userListRef: DatabaseReference?
    var usernameTaken = false
    var usernameChecked = false
    
    //MARK: IBOUtlets
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var UsernameStatusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PasswordTextField.delegate=self
        EmailTextField.delegate=self
        userListRef = Database.database().reference(withPath: "users")

        // Do any additional setup after loading the view.
    
    }
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener(){auth, user in
            
            guard let user = user else {return}
            
            LoginViewController.user = User(authData: user)
            Database.database().reference(withPath: "usernames").child(user.uid).observe(.value, with: {(snapshot) in
                if(snapshot.exists() == true){
                    LoginViewController.user.displayName = (snapshot.value as! String)
                    SOSViewController.instanceRef?.userLabel.text = LoginViewController.user.displayName
                }
                else{
                    return
                }
            })
            
            self.performSegue(withIdentifier: self.transitionID, sender: nil)
            //self.EmailTextField = nil
            self.PasswordTextField.text = nil
        }
    }
    @IBAction func logoutUnwindAction(unwindSeque: UIStoryboardSegue){
        self.loadViewIfNeeded()
        print("UnwindS eque Called")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Actions
    
    @IBAction func SignUpButtonClick(_ sender: UIButton) {
        guard let email = EmailTextField.text, !email.isEmpty
            else{
                print("Error: No email entered")
                return
                }
        guard let password = PasswordTextField.text, !password.isEmpty
            else{
                print("Error: No password entered")
                return
                }
        guard let username = UsernameTextField.text, !username.isEmpty else{
            print("Error: No username entered")
            return
        }
    
        //Check if username has already been taken
        userListRef?.child(username).observe(.value, with: {(snapshot) in
            if snapshot.exists() == true{
                self.usernameTaken = true
                self.usernameChecked = true
                
            }
            else{
                self.usernameTaken = false
                self.usernameChecked = true
            }
        })
        
        if usernameChecked == true{
            if usernameTaken == true{
                self.UsernameStatusLabel.textColor = UIColor.red
                self.UsernameStatusLabel.text = "Username taken"
                return
            }
            else{
                self.UsernameStatusLabel.textColor = UIColor.black
                self.UsernameStatusLabel.text = "Username avaliable"
            }
            
        }
        else{
            print("username not checked yet")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password){user,error in
            if error == nil{
                Auth.auth().signIn(withEmail: email, password: password)
                LoginViewController.user.email = email
                LoginViewController.user.displayName = username
                LoginViewController.user.senderId = (Auth.auth().currentUser?.uid)!
                self.performSegue(withIdentifier: self.transitionID, sender: nil)
                self.userListRef!.child(username).setValue(LoginViewController.user.toAnyObject())
                Database.database().reference(withPath: "usernames").child((Auth.auth().currentUser?.uid)!).setValue(username)
            }
            else {
                let alert = UIAlertController(title: "Account Creation Failed", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style:.default))
                self.present(alert,animated: true, completion: nil)
            }
        }
    }
    
    
    
    @IBAction func LogInButtonClick(_ sender: Any) {
        guard let email = EmailTextField.text, !email.isEmpty
            else{
                print("Error: No email entered")
                return
                }
        guard let password = PasswordTextField.text, !password.isEmpty
            else{
                print("Error: No password entered")
                return
        }
        guard let username = UsernameTextField.text, !username.isEmpty else{
            print("Error: No username entered")
            return
        }
       
        Auth.auth().signIn(withEmail: email, password: password){user,error in
            if let error = error, user == nil{
                let alert = UIAlertController(title: "Sign In Failed", message: error.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title:"OK", style:.default))
                
                self.present(alert,animated: true,completion: nil)
            }
            else {
                LoginViewController.user.email = username
                LoginViewController.user.displayName = (Auth.auth().currentUser?.uid)!
                LoginViewController.user.senderId = (Auth.auth().currentUser?.uid)!
                
                self.performSegue(withIdentifier: self.transitionID, sender: nil)

            }

        }
    }
    @IBAction func usernameEditingEnded(_ sender: UITextField) {
        if sender == UsernameTextField{
            let username = UsernameTextField.text!
            userListRef?.child(username).observe(.value, with: {(snapshot) in
                if snapshot.exists() == true{
                self.usernameTaken = true
                self.usernameChecked = true
                self.UsernameStatusLabel.textColor = UIColor.red
                self.UsernameStatusLabel.text = "Username taken!"
                }
                else{
                    self.usernameTaken = false
                    self.usernameChecked = true
                    self.UsernameStatusLabel.textColor = UIColor.black
                    self.UsernameStatusLabel.text = "Username avaliable"
                }
            })
        }
    }
}


