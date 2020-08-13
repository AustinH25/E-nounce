//
//  accountViewController.swift
//  E-nounce
//
//  Created by austin huang on 11/12/19.
//  Copyright © 2019 Yu WenLiao. All rights reserved.
//

import UIKit

class accountViewController: UIViewController {

    let backgroundImageView = UIImageView()
    @IBOutlet weak var UserIDLabel: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground_account()
        UserIDLabel.text = LoginViewController.user.email
        UsernameLabel.text = LoginViewController.user.displayName
        // Do any additional setup after loading the view.
    }
    
    func setBackground_account() {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.image = UIImage(named: "background")
        view.sendSubviewToBack(backgroundImageView)
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
