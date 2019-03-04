//
//  aboutVC.swift
//  BigMood
//
//  Created by Jonathan Kopp on 3/3/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit

class aboutVC: UIViewController, UITextViewDelegate{
    var backgroundImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = #imageLiteral(resourceName: "blurredBackground")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.7
        self.view.addSubview(backgroundImage)
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let desctextView = UITextView()
        desctextView.frame = CGRect(x: 10, y: 70, width: self.view.bounds.width - 20, height: 180)
        desctextView.delegate = self
        desctextView.textAlignment = .justified
        desctextView.textColor = .white
        desctextView.text = "Big Mood's mission is to bring balance to every user through its mood-based content generation."
        desctextView.font = UIFont(name: "Avenir-Book", size: 20)
        desctextView.isSelectable = true
        desctextView.layer.cornerRadius = 10
        desctextView.autocorrectionType = .yes
        desctextView.spellCheckingType = UITextSpellCheckingType.yes
        desctextView.isEditable = false
        desctextView.keyboardType = UIKeyboardType.default
        desctextView.returnKeyType = .done
        desctextView.backgroundColor = .clear
        desctextView.sizeToFit()
        self.view.addSubview(desctextView)
    }
    
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer){
        let animation = CATransition()
        animation.type = .push
        animation.duration = 0.6
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        
        self.dismiss(animated: false, completion: nil)
    }
}
