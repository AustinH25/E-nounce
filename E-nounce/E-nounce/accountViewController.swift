//
//  accountViewController.swift
//  E-nounce
//
//  Created by austin huang on 11/12/19.
//  Copyright © 2019 Yu WenLiao. All rights reserved.
//

import UIKit

class accountViewController: UIViewController {

    
    @IBOutlet weak var UserIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserIDLabel.text = LoginViewController.user.email

        // Do any additional setup after loading the view.
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
