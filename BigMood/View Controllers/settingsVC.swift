//
//  settingsVC.swift
//  BigMood
//
//  Created by Jonathan Kopp on 3/3/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit

class settingsVC: UIViewController{
    var backgroundImage = UIImageView()
    var contactButton = UIButton()
    var resetTrakerButton = UIButton()
    var aboutButton = UIButton()
    var greetingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.image = #imageLiteral(resourceName: "blurredBackground")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.7
        self.view.addSubview(backgroundImage)
        
        contactButton.frame = CGRect(x: self.view.bounds.width / 2  - 100, y: self.view.bounds.height / 2 - 90, width: 200, height: 40.0)
        contactButton.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        contactButton.setTitle("Contact", for: .normal)
        contactButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        contactButton.titleLabel?.adjustsFontSizeToFitWidth = true
        contactButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        contactButton.layer.cornerRadius = 20
        contactButton.layer.borderWidth = 2
        contactButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        contactButton.addTarget(self, action:#selector(self.contactPressed), for: .touchUpInside)
        
        
        
        aboutButton.frame = CGRect(x: self.view.bounds.width / 2  - 100, y: self.view.bounds.height / 2 - 45, width: 200, height: 40.0)
        aboutButton.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        aboutButton.setTitle("About", for: .normal)
        aboutButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        aboutButton.titleLabel?.adjustsFontSizeToFitWidth = true
        aboutButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        aboutButton.layer.cornerRadius = 20
        aboutButton.layer.borderWidth = 2
        aboutButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        aboutButton.addTarget(self, action:#selector(self.aboutPressed), for: .touchUpInside)
        
//        resetTrakerButton.frame = CGRect(x: self.view.bounds.width / 2  - 100, y: self.view.bounds.height / 2, width: 200, height: 40.0)
//        resetTrakerButton.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
//        resetTrakerButton.setTitle("How to use", for: .normal)
//        resetTrakerButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
//        resetTrakerButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        resetTrakerButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
//        resetTrakerButton.layer.cornerRadius = 20
//        resetTrakerButton.layer.borderWidth = 2
//        resetTrakerButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //resetTrakerButton.addTarget(self, action:#selector(self.resetPressed), for: .touchUpInside)
        
        self.view.addSubview(aboutButton)
        self.view.addSubview(resetTrakerButton)
        self.view.addSubview(contactButton)
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        greetingLabel.frame = CGRect(x: 45, y: 25, width: self.view.bounds.width - 90, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        greetingLabel.text = "Settings"
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
        animation.type = .fade
        animation.duration = 0.4
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        
        self.dismiss(animated: false, completion: nil)
    }
    @objc func contactPressed()
    {
        //print("Contact Pressed")
        let vc = contactVC()
        let animation = CATransition()
        animation.type = .push
        animation.subtype = .fromBottom
        animation.duration = 0.6
        self.view.window!.layer.add(animation, forKey: nil)
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func aboutPressed()
    {
        //print("About Pressed")
        let vc = aboutVC()
        let animation = CATransition()
        animation.type = .push
        animation.subtype = .fromBottom
        animation.duration = 0.6
        self.view.window!.layer.add(animation, forKey: nil)
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer){
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.4
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        
        self.dismiss(animated: false, completion: nil)
    }
}
