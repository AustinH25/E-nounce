//
//  ViewController.swift
//  E-nounce
//
//  Created by Yu WenLiao on 10/4/19.
//  Copyright © 2019 Yu WenLiao. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func LogoutButtonPress(_ sender: UIButton) {
        let user = Auth.auth().currentUser!
        do{
            try Auth.auth().signOut()
            //self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "mainMenuLogoutSegue", sender: nil)
        } catch(let error){
            print("Sign out failed: \(error)")
        }
    }
}
    


@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
