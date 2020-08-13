//
//  generalViewController.swift
//  E-nounce
//
//  Created by austin huang on 7/18/20.
//  Copyright © 2020 Yu WenLiao. All rights reserved.
//

import UIKit

class generalViewController: UIViewController {
    let backgroundImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground_general()
        // Do any additional setup after loading the view.
    }
    func setBackground_general() {
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
