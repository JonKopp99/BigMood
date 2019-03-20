//
//  contactVC.swift
//  BigMood
//
//  Created by Jonathan Kopp on 3/3/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit

class contactVC: UIViewController, UITextViewDelegate{
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
        desctextView.text = "Contact us in regards to anything app related. We want this app to be perfect for every user. If you find any bugs or want any new features, press the contact button below!"
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
        
        
        let contactButton = UIButton()
        contactButton.frame = CGRect(x: self.view.bounds.width/2 - 90, y: desctextView.frame.maxY + 5, width: 180, height: 50)
        contactButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        contactButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 20.0)
        contactButton.titleLabel?.adjustsFontSizeToFitWidth = true
        contactButton.setTitle("Contact", for: .normal)
        contactButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        contactButton.addTarget(self, action:#selector(self.contactPressed), for: .touchUpInside)
        contactButton.layer.cornerRadius = 20
        contactButton.layer.borderWidth = 2
        contactButton.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.view.addSubview(contactButton)
        
        greetingLabel.frame = CGRect(x: 45, y: 25, width: self.view.bounds.width - 90, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        greetingLabel.text = "Contact us"
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
    @objc func contactPressed()
    {
            let url = NSURL(string: "mailto:jonathan.kopp@students.makeschool.com")
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url! as URL)
            }
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
