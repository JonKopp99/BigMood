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
    var greetingLabel = UILabel()
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
        desctextView.frame = CGRect(x: 10, y: 100, width: self.view.bounds.width - 20, height: 180)
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
        
        greetingLabel.frame = CGRect(x: 45, y: 25, width: self.view.bounds.width - 90, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 35)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        greetingLabel.text = "About"
        greetingLabel.shadowColor = .black
        greetingLabel.shadowOffset = CGSize(width: -2, height: 2)
        self.view.addSubview(greetingLabel)
        let backButton = UIButton()
        backButton.frame = CGRect(x: 5, y: greetingLabel.frame.minY + 12.5, width: 25, height: 25)
        backButton.setImage(#imageLiteral(resourceName: "icons8-undo-52"), for: .normal)
        backButton.alpha = 1.0
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
    }
    @objc func backButtonPressed()
    {
        let animation = CATransition()
        animation.type = .push
        animation.duration = 0.6
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        
        self.dismiss(animated: false, completion: nil)
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
