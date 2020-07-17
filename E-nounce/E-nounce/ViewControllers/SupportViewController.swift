//
//  SupportViewController.swift
//  E-nounce
//
//  Created by austin huang on 2/9/20.
//  Copyright © 2020 Yu WenLiao. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController {

    
    @IBOutlet var languageButton: [UIButton]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//    @IBAction func handleSelection(_ sender: UIButton) {
//        languageButton.forEach { (button) in
//            UIView.animate(withDuration: 0.3, animations: {
//                button.isHidden = !button.isHidden //make the hidden button appears
//                self.view.layoutIfNeeded()
//                //helps the animation looks smoother
//            })
//        }
//    }
//    
//    enum languages: String {
//        case english = "English-(Defualt) ►"
//        case chinese = "Chinese ►"
//    }
//    @IBAction func languageChoosen(_ sender: UIButton) {
//        guard let title = sender.currentTitle, let language = languages(rawValue: title) else{
//            return
//        }
//        
//        switch language {
//        case .english:
//            print("English-(Defualt) ►")
//            let alert = UIAlertController(title: "Change Language", message: "Language changed to English", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
//            self.present(alert, animated: true)
//        case .chinese:
//            print("Chinese ►")
//            
//        }
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
