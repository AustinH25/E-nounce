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
    
    //MARK: IBOUtlets
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PasswordTextField.delegate=self
        EmailTextField.delegate=self

        // Do any additional setup after loading the view.
    
    }
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener(){auth, user in
            if user != nil{
                self.performSegue(withIdentifier: self.transitionID, sender: nil)
                self.EmailTextField = nil
                self.PasswordTextField.text = nil
                LoginViewController.user = User(senderId: (user?.uid)!, displayName: (user?.email)!)
                
            }
        }
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
        guard let email = EmailTextField.text
            else{
                print("Error: No email entered")
                return
                }
        guard let password = PasswordTextField.text
            else{
                print("Error: No password entered")
                return
                }
        Auth.auth().createUser(withEmail: email, password: password){user,error in
            if error == nil{
                Auth.auth().signIn(withEmail: email, password: password)
                LoginViewController.user.email = email
                LoginViewController.user.displayName = email
                LoginViewController.user.senderId = email
                self.performSegue(withIdentifier: self.transitionID, sender: nil)
            }
            else {
                let alert = UIAlertController(title: "Account Creation Failed", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style:.default))
                self.present(alert,animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func LogInButtonClick(_ sender: Any) {
        guard let email = EmailTextField.text
            else{
                print("Error: No email entered")
                return
                }
        guard let password = PasswordTextField.text
            else{
                print("Error: No password entered")
                return
        }
        Auth.auth().signIn(withEmail: email, password: password){user,error in
            if let error = error, user == nil{
                let alert = UIAlertController(title: "Sign In Failed", message: error.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title:"OK", style:.default))
                
                self.present(alert,animated: true,completion: nil)
            }
            else {
                LoginViewController.user.email = email
                LoginViewController.user.displayName = email
                LoginViewController.user.senderId = email

                self.performSegue(withIdentifier: self.transitionID, sender: nil)

            }

        }
    }
}


