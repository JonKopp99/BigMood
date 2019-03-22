//
//  immediateHelpVC.swift
//  BigMood
//
//  Created by Jonathan Kopp on 3/21/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit

class immediateHelpVC: UIViewController{
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
        
        greetingLabel.frame = CGRect(x: 45, y: 25, width: self.view.bounds.width - 90, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        greetingLabel.text = "Immediate Help."
        greetingLabel.shadowColor = .black
        greetingLabel.shadowOffset = CGSize(width: -2, height: 2)
        self.view.addSubview(greetingLabel)
        loadData()
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: 5, y: greetingLabel.frame.minY + 12.5, width: 25, height: 25)
        backButton.setImage(#imageLiteral(resourceName: "icons8-undo-52"), for: .normal)
        backButton.alpha = 1.0
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
    }
    func loadData()
    {
        let ssh = UITextView()
        ssh.frame = CGRect(x: 10, y: 80, width: self.view.bounds.width, height: 60)
        ssh.isEditable = false
        ssh.backgroundColor = .clear
        ssh.textColor = .white
        ssh.dataDetectorTypes = UIDataDetectorTypes.all
        ssh.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        ssh.text = "Suicide Prevention Hotline \n800-273-8255"
        ssh.adjustsFontForContentSizeCategory = true
        self.view.addSubview(ssh)
        
        let nami = UITextView()
        nami.frame = CGRect(x: 10, y: 150, width: self.view.bounds.width, height: 60)
        nami.isEditable = false
        nami.backgroundColor = .clear
        nami.textColor = .white
        nami.dataDetectorTypes = UIDataDetectorTypes.all
        nami.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        nami.text = "National Alliance on Mental Illness \n800-950-6264"
        nami.adjustsFontForContentSizeCategory = true
        self.view.addSubview(nami)
        
        let tl = UITextView()
        tl.frame = CGRect(x: 10, y: 210, width: self.view.bounds.width, height: 60)
        tl.isEditable = false
        tl.backgroundColor = .clear
        tl.textColor = .white
        tl.dataDetectorTypes = UIDataDetectorTypes.all
        tl.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        tl.text = "Teens Helping Teens \n800-852-8336"
        tl.adjustsFontForContentSizeCategory = true
        self.view.addSubview(tl)
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
    
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer){
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.4
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        
        self.dismiss(animated: false, completion: nil)
    }
}
