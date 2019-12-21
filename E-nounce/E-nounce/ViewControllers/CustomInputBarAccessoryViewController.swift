//
//  CustomInputBarAccessoryViewController.swift
//  E-nounce
//
//  Created by austin huang on 11/19/19.
//  Copyright © 2019 Yu WenLiao. All rights reserved.
//

import UIKit
import InputBarAccessoryView

class customInputBarAccessoryViewController: InputBarAccessoryView {
    
    let locationButton: InputBarButtonItem
    
    var customDelegate: customInputAccessoryViewDelegate?
    
    override init(frame: CGRect){
        locationButton = InputBarButtonItem()
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        locationButton.onKeyboardEditingBegins({item in
            item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 0, animated: true)
        })
        
        locationButton.onKeyboardEditingEnds({item in
            item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 36, animated: true)
        })
        locationButton.onTouchUpInside({item in
            self.customDelegate?.locationButtonPressed()
        })
        
        locationButton.setSize(CGSize(width: 36, height: 36), animated: false)
        locationButton.tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        locationButton.image = UIImage(named: "AppIcon")
        setStackViewItems([locationButton], forStack: .left, animated: false)
        locationButton.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 36, animated: false)
    }
    
}

protocol customInputAccessoryViewDelegate {
    func locationButtonPressed()
}
