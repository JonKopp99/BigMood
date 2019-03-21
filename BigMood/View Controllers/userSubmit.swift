//
//  userSubmit.swift
//  BigMood
//
//  Created by Jonathan Kopp on 3/19/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//
import Foundation
import Firebase
import UIKit

class userSubmit: UIViewController, UIPickerViewDelegate, UITextFieldDelegate{
    var video = Bool()
    var inputText = UITextField()
    var greetingLabel = UILabel()
    var backgroundImage = UIImageView()
    var mood = String()
    var b1 = UIButton()//video
    var b2 = UIButton()//article
    var b3 = UIButton()//done
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = #imageLiteral(resourceName: "blurredBackground")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        greetingLabel.frame = CGRect(x: 45, y: 25, width: self.view.bounds.width - 90, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 35)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        greetingLabel.text = "Submit content for: \(mood)"
        greetingLabel.shadowColor = .black
        greetingLabel.shadowOffset = CGSize(width: -2, height: 2)
        self.view.addSubview(greetingLabel)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: 5, y: greetingLabel.frame.minY + 12.5, width: 25, height: 25)
        backButton.setImage(#imageLiteral(resourceName: "icons8-undo-52"), for: .normal)
        backButton.alpha = 1.0
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
        showButtons()
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

    func showButtons()
    {
        b1 = UIButton()
        b1.frame = CGRect(x: self.view.bounds.width / 2  - 152.5, y: 140, width: 150, height: 40.0)
        b1.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b1.setTitle("Video", for: .normal)
        b1.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b1.titleLabel?.adjustsFontSizeToFitWidth = true
        b1.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b1.layer.cornerRadius = 20
        b1.layer.borderWidth = 2
        b1.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b1.addTarget(self, action:#selector(self.videoPressed(_:)), for: .touchUpInside)
        
        
        b2 = UIButton()
        b2.frame = CGRect(x: self.view.bounds.width / 2 + 2.5, y: 140, width: 150, height: 40.0)
        b2.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b2.setTitle("Article", for: .normal)
        b2.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b2.titleLabel?.adjustsFontSizeToFitWidth = true
        b2.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b2.layer.cornerRadius = 20
        b2.layer.borderWidth = 2
        b2.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b2.addTarget(self, action:#selector(self.articlePressed(_:)), for: .touchUpInside)
        
        self.view.addSubview(b1)
        self.view.addSubview(b2)
    }
    
    @objc func videoPressed(_ sender: UIButton)
    {
        sender.backgroundColor = #colorLiteral(red: 0.2392156863, green: 0.6745098039, blue: 0.968627451, alpha: 1).withAlphaComponent(0.5)
        b2.backgroundColor = .clear
        video = true
        inputText.frame = CGRect(x: 10, y: 210, width: self.view.bounds.width - 20, height: 50)
        inputText.textAlignment = .center
        inputText.textColor = .black
        inputText.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        inputText.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.4)
        inputText.placeholder = "Enter video link"
        inputText.returnKeyType = UIReturnKeyType.done
        self.view.addSubview(inputText)
        
        b3.removeFromSuperview()
        b3.frame = CGRect(x: self.view.bounds.width / 2  - 75, y: 270, width: 150, height: 40.0)
        b3.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b3.setTitle("Done", for: .normal)
        b3.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b3.titleLabel?.adjustsFontSizeToFitWidth = true
        b3.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b3.layer.cornerRadius = 20
        b3.layer.borderWidth = 2
        b3.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b3.addTarget(self, action:#selector(self.donePressed), for: .touchUpInside)
        self.view.addSubview(b3)
    }
    @objc func articlePressed(_ sender: UIButton)
    {
        video = false
        sender.backgroundColor = #colorLiteral(red: 0.2392156863, green: 0.6745098039, blue: 0.968627451, alpha: 1).withAlphaComponent(0.5)
        b1.backgroundColor = .clear
        inputText.frame = CGRect(x: 10, y: 210, width: self.view.bounds.width - 20, height: 50)
        inputText.textAlignment = .center
        inputText.textColor = .black
        inputText.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        inputText.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.4)
        inputText.placeholder = "Enter article link"
        inputText.adjustsFontSizeToFitWidth = false
        inputText.returnKeyType = UIReturnKeyType.done
        self.view.addSubview(inputText)
        
        b3.removeFromSuperview()
        b3 = UIButton()
        b3.frame = CGRect(x: self.view.bounds.width / 2  - 75, y: 270, width: 150, height: 40.0)
        b3.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b3.setTitle("Done", for: .normal)
        b3.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b3.titleLabel?.adjustsFontSizeToFitWidth = true
        b3.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b3.layer.cornerRadius = 20
        b3.layer.borderWidth = 2
        b3.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b3.addTarget(self, action:#selector(self.donePressed), for: .touchUpInside)
        self.view.addSubview(b3)
    }
    @objc func donePressed()
    {
        let resource = inputText.text!
        print(mood)
        print(resource)
        var type = "videos"
        if(video == false)
        {
            type = "articles"
        }
        let ref = Database.database().reference().child("Submitted").child(mood).child(type)
        ref.childByAutoId().setValue(resource)
        //ref.setValue(resource)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //inputText.resignFirstResponder()
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return true
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
