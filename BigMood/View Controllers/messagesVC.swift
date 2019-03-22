//
//  messagesVC.swift
//  BigMood
//
//  Created by Jonathan Kopp on 3/21/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class messagesVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
   
    
    var chatID = String()
    var backgroundImage = UIImageView()
    var greetingLabel = UILabel()
    var testView = UITextField()
    var messages = [message]()
    var moodTB = UITableView()
    var id = String()
    var myMSGCount = 0//keep track of the message counts!!!
    var thereMSGCount = 0
    var timer = Timer()
    var heightOfKeyboard = CGFloat()
    var keyboardView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        var ref = Database.database().reference().child("Queue").child(id)
        ref.removeValue()
        ref = Database.database().reference().child("Chats").child(chatID).child(id).child("id")
        ref.setValue(id)
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
        
        greetingLabel.text = "Anonymous Chat"
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        setUpKeyboardView()
        
        moodTB.dataSource = self
        moodTB.delegate = self
        moodTB.register(messageCell.self, forCellReuseIdentifier: "msg")
        
        moodTB.frame = CGRect(x: 0, y: greetingLabel.frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height - (greetingLabel.frame.maxY + 60))
        moodTB.separatorStyle = .none
        moodTB.backgroundColor = .clear
        self.view.addSubview(moodTB)
        
        scheduledTimerWithTimeInterval()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.heightOfKeyboard = keyboardRectangle.height
            self.bringKeyBoardUp()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat(40)
        if(indexPath.row < messages.count)
        {

            let msg = UITextView()
            msg.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
            msg.frame = CGRect(x: 10, y: 0, width: self.view.bounds.width - self.view.bounds.width * 0.4 - 10, height: 40)
            msg.text = messages[indexPath.row].msg
            msg.textAlignment = .left
            //msg.sizeToFit()
            height = msg.sizeThatFits(CGSize(width: msg.frame.width, height: CGFloat.greatestFiniteMagnitude)).height + 10
        }
        print(height)
        return height
    }
    
    
    func setUpKeyboardView()
    {
        keyboardView.frame = CGRect(x: 0, y: self.view.bounds.height - 60, width: self.view.bounds.width, height: 60)
        
        testView.frame = CGRect(x: 15, y: 5, width: self.view.bounds.width - 55, height: 40)
        testView.textAlignment = .center
        testView.textColor = .black
        testView.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        testView.placeholder = "Type here"
        //testView.returnKeyType = UIReturnKeyType.done
        testView.autocorrectionType = .no
        testView.delegate = self
        testView.backgroundColor = .white
        testView.layer.cornerRadius = 10
        testView.textColor = .black
        self.keyboardView.addSubview(testView)
        
        let send = UIButton()
        send.frame = CGRect(x: testView.frame.maxX + 5, y: 10, width: 30, height: 30)
        send.setImage(#imageLiteral(resourceName: "icons8-sent-50"), for: .normal)
        send.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        keyboardView.addSubview(send)
        
        self.view.addSubview(keyboardView)
    }
    func bringKeyBoardUp()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.keyboardView.frame = CGRect(x: 0, y: self.view.bounds.height - (60 + self.heightOfKeyboard), width: self.view.bounds.width, height: 60)
            
            self.moodTB.frame = CGRect(x: 0, y: self.greetingLabel.frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height - (self.greetingLabel.frame.maxY + 60 + self.heightOfKeyboard))
            })
    }
    func bringKeyBoardDown()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.keyboardView.frame = CGRect(x: 0, y: self.view.bounds.height - 60, width: self.view.bounds.width, height: 60)
            
            self.moodTB.frame = CGRect(x: 0, y: self.greetingLabel.frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height - (self.greetingLabel.frame.maxY + 60))
        })
    }
    @objc func donePressed()
    {
        testView.resignFirstResponder()
        messages.append(message(sender: true, msg: testView.text!))
        DispatchQueue.main.async {
            self.moodTB.beginUpdates()
            self.moodTB.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .fade)
            self.moodTB.endUpdates()
        }
        
        uploadMsg(msg: testView.text!)
        testView.text = ""
        bringKeyBoardDown()
    }
    func scheduledTimerWithTimeInterval(){
        // Should stop at certain interval
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: {_ in
        self.getNewMessages()
        })
        
    }
    func getNewMessages()
    {
        print("Checking for new messages!")
        
        let ref = Database.database().reference().child("Chats").child(chatID)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return }
            let value = snapshot.value as! [String : AnyObject]
            for(_, newvalue) in value
            {
                let theValue = newvalue as! [String : String]
                let theID = theValue["id"]!
                if(theID != self.id)
                {
                    if let newMessage = newvalue["\(self.thereMSGCount)"]!
                    {
                        self.thereMSGCount += 1
                        self.messages.append(message(sender: false, msg: newMessage as! String))
                        self.moodTB.beginUpdates()
                        self.moodTB.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .fade)
                        self.moodTB.endUpdates()
                    }
                    return
                }
            }
        })
    }
    @objc func backButtonPressed()
    {
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.4
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        self.timer.invalidate()
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer){
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.4
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        self.timer.invalidate()
        self.dismiss(animated: false, completion: nil)
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        testView.resignFirstResponder()
//        messages.append(message(sender: true, msg: testView.text!))
//        moodTB.beginUpdates()
//        moodTB.insertRows(at: [IndexPath(row: messages.count - 1, section: 0)], with: .fade)
//        moodTB.endUpdates()
//        uploadMsg(msg: testView.text!)
//        testView.text = ""
//        return true
//    }
    func uploadMsg(msg: String)
    {
        let ref = Database.database().reference().child("Chats").child(chatID).child(id).child("\(myMSGCount)")
        ref.setValue(msg)
        myMSGCount += 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageCell()
        cell.sender = messages[indexPath.row].sender
        cell.msg.text = messages[indexPath.row].msg
        cell.backgroundColor = .clear
        return cell
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
}
struct message{
    var sender = Bool()
    var msg = String()
}
