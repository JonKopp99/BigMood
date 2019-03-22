//
//  chatVC.swift
//  BigMood
//
//  Created by Jonathan Kopp on 3/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class chatVC: UIViewController{
    var backgroundImage = UIImageView()
    var greetingLabel = UILabel()
    var descLabel = UILabel()
    var chatButton = UIButton()
    var id = String()
    var timer = Timer()
    var koiImage = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = #imageLiteral(resourceName: "blurredBackground")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.7
        self.view.addSubview(backgroundImage)
        let backgroundView = UIView(frame: backgroundImage.frame)
        backgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.8)
        //self.view.addSubview(backgroundView)
        greetingLabel.frame = CGRect(x: 45, y: 25, width: self.view.bounds.width - 90, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        greetingLabel.text = "Chat"
        greetingLabel.shadowColor = .black
        greetingLabel.shadowOffset = CGSize(width: -2, height: 2)
        self.view.addSubview(greetingLabel)
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: 5, y: greetingLabel.frame.minY + 12.5, width: 25, height: 25)
        backButton.setImage(#imageLiteral(resourceName: "icons8-undo-52"), for: .normal)
        backButton.alpha = 1.0
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        descLabel.frame = CGRect(x: 45, y: greetingLabel.frame.maxY + 20, width: self.view.bounds.width - 90, height: 50)
        descLabel.textAlignment = .center
        descLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        descLabel.adjustsFontSizeToFitWidth = true
        descLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        descLabel.text = "Press start to search an anonymous chat!"
        descLabel.shadowColor = .black
        descLabel.shadowOffset = CGSize(width: -2, height: 2)
        self.view.addSubview(descLabel)
        
        chatButton = UIButton()
        chatButton.frame = CGRect(x: self.view.bounds.width / 2  - 100, y: descLabel.frame.maxY + 10, width: 200, height: 40.0)
        chatButton.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        chatButton.setTitle("Start!", for: .normal)
        chatButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        chatButton.titleLabel?.adjustsFontSizeToFitWidth = true
        chatButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        chatButton.layer.cornerRadius = 20
        chatButton.layer.borderWidth = 2
        chatButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        chatButton.addTarget(self, action:#selector(self.chatPressed), for: .touchUpInside)
        self.view.addSubview(chatButton)
    }
    
    func exitQueue()
    {
        timer.invalidate()
        let ref = Database.database().reference().child("Queue").child(id)
        ref.removeValue()
    }
    @objc func chatPressed()
    {
        print("Pressed")
        
        let label = UILabel()
        label.frame = CGRect(x: 45, y: self.chatButton.frame.midY, width: self.view.bounds.width - 90, height: 50)
        descLabel.removeFromSuperview()
        chatButton.removeFromSuperview()
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.text = "Searching for anonymous user..."
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: -2, height: 2)
        self.view.addSubview(label)
        
        start()
    }
    
    func start()
    {
        id = "\(Int(arc4random_uniform(UInt32(100000))))"
        
        let ref = Database.database().reference().child("Queue").child(id)
        ref.setValue(["inChat":"false", "id": id, "chatRoom": "nil"])
        let theHeight = self.view.bounds.width - 40
        koiImage.frame = CGRect(x: 20, y: self.chatButton.frame.maxY + 50, width: self.view.bounds.width - 40, height: theHeight)
        //let gifImage = UIImage.gifImageWithName("kscsscoi")
        //koiImage.image = UIImage.gifImageWithName("kscsscoi")
        koiImage.loadGif(name: "kscsscoi")
        koiImage.contentMode = .scaleAspectFit
        
        self.view.addSubview(koiImage)
        scheduledTimerWithTimeInterval()
    }
    func scheduledTimerWithTimeInterval(){
        // Should stop at certain interval
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: {_ in
        if(!self.checkIfInChat())
        {
            self.searchForUser()
        }
        })
        
        
    }
    func checkIfInChat()->Bool
    {
        print("Checking if in chat!")
        let found = false
        let ref = Database.database().reference().child("Queue").child(id)
        DispatchQueue.main.async {
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return }
            let value = snapshot.value as! [String : AnyObject]
            let theValue = value as! [String : String]
            let foundString = theValue["inChat"]!
            if(foundString == "true")
            {
                self.timer.invalidate()
                self.goToChat()
            }
        })
        }
        return found
    }
    func searchForUser()
    {
        print("Searching for user!")
        let ref = Database.database().reference().child("Queue")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return }
            let value = snapshot.value as! [String : AnyObject]
            print("Count of QUEUES: ", value.count)
            for(_, newvalue) in value
            {
                let theValue = newvalue as! [String : String]
                let theID = theValue["id"]!
                if(theID != self.id)
                {
                    print("Found new user with ID: ", theID)
                    var chatRoomID = Int(self.id)!
                    chatRoomID += Int(theID)!
                    let newRef = Database.database().reference().child("Queue").child(theID)
                    newRef.setValue(["inChat": "true", "id":theID, "chatRoom": "\(chatRoomID)"])
                    let myRef = Database.database().reference().child("Queue").child(self.id)
                    myRef.setValue(["inChat": "true", "id":self.id, "chatRoom": "\(chatRoomID)"])
                    self.goToChat()
                    return
                }
            }
        })
        
    }
    func goToChat()
    {
        timer.invalidate()
        let ref = Database.database().reference().child("Queue").child(id)
        var chatID = "nil"
        DispatchQueue.main.async {
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return }
            let value = snapshot.value as! [String : AnyObject]
            let theValue = value as! [String : String]
            chatID = theValue["chatRoom"]!
            if(chatID != "nil")
            {
                ref.setValue([])
                print("Going to chat with id: ", chatID)
                let vc = messagesVC()
                vc.chatID = chatID
                vc.id = self.id
                let animation = CATransition()
                animation.type = .fade
                animation.subtype = .fromBottom
                animation.duration = 0.6
                self.view.window!.layer.add(animation, forKey: nil)
                self.present(vc, animated: false, completion: nil)
            }
        })
        }
        
        
    }
    @objc func backButtonPressed()
    {
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.4
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        exitQueue()
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer){
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.4
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        exitQueue()
        self.dismiss(animated: false, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        exitQueue()
    }
}
