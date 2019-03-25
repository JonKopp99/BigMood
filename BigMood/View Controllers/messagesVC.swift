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

class messagesVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource{
   
    
    var chatID = String()
    var backgroundImage = UIImageView()
    var greetingLabel = UILabel()
    var testView = UITextView()
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
        //Setting default values to come back to the chat!
        let userDefaults = Foundation.UserDefaults.standard
        userDefaults.set(chatID, forKey: "chatRoom")
        userDefaults.set(id, forKey: "myID")
        getSavedMessages()
        var ref = Database.database().reference().child("Queue").child(id)
        ref.setValue([])
        ref = Database.database().reference().child("Chats").child(chatID).child(id).child("id")
        ref.setValue(id)
        backgroundImage.image = #imageLiteral(resourceName: "blurredBackground")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 1.0
        self.view.addSubview(backgroundImage)
        let backgroundView = UIView(frame: backgroundImage.frame)
        backgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.4)
        self.view.addSubview(backgroundView)
        greetingLabel.frame = CGRect(x: 50, y: 25, width: self.view.bounds.width - 100, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        greetingLabel.text = "Anonymous Chat"
        greetingLabel.shadowColor = .black
        greetingLabel.shadowOffset = CGSize(width: -2, height: 2)
        self.view.addSubview(greetingLabel)
        let doneButton = UIButton()
        doneButton.frame = CGRect(x: self.greetingLabel.frame.maxX - 5, y: 30, width: 50, height: 40)
        doneButton.setTitle("Leave", for: .normal)
        doneButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        doneButton.addTarget(self, action: #selector(leavePressed), for: .touchUpInside)
        self.view.addSubview(doneButton)
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
        noMessagesFooterView()
        scheduledTimerWithTimeInterval()
    }
    
    func noMessagesFooterView()
    {
        if(messages.isEmpty)
        {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
            let label = UILabel()
            label.frame = CGRect(x: 45, y: 10, width: self.view.bounds.width - 90, height: 50)
            label.textAlignment = .center
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
            //label.adjustsFontSizeToFitWidth = true
            label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            label.text = "Say hello😁"
            //label.shadowColor = .black
            //label.shadowOffset = CGSize(width: -2, height: 2)
            footerView.addSubview(label)
            moodTB.tableFooterView = footerView
        }else{
            moodTB.tableFooterView?.isHidden = true
        }
    }
    
    func getSavedMessages()
    {
        let userDefaults = Foundation.UserDefaults.standard
        let myMessages = (userDefaults.stringArray(forKey: "myMessages") ?? [String]())
        if(!myMessages.isEmpty)
        {
            for i in myMessages
            {
                self.myMSGCount += 1
                messages.append(message(sender: true, msg: i))
            }
        }
        let theirMessages = (userDefaults.stringArray(forKey: "theirMessages") ?? [String]())
        if(!theirMessages.isEmpty)
        {
            for i in theirMessages
            {
                self.thereMSGCount += 1
                messages.append(message(sender: false, msg: i))
            }
        }
    }
    func saveMessageToPhone(msg: message)
    {
        let userDefaults = Foundation.UserDefaults.standard
        var myMessages = (userDefaults.stringArray(forKey: "myMessages") ?? [String]())
        var theirMessages = (userDefaults.stringArray(forKey: "theirMessages") ?? [String]())
        if(msg.sender)
        {
            myMessages.append(msg.msg)
            userDefaults.set(myMessages, forKey: "myMessages")
        }else{
            theirMessages.append(msg.msg)
            userDefaults.set(theirMessages, forKey: "theirMessages")
        }
    }
    @objc func leavePressed()
    {
        timer.invalidate()
        let ref = Database.database().reference().child("Chats").child(chatID).child(id)
        ref.setValue([])
        let userDefaults = Foundation.UserDefaults.standard
        userDefaults.removeObject(forKey: "chatRoom")
        userDefaults.removeObject(forKey: "myID")
        userDefaults.removeObject(forKey: "theirMessages")
        userDefaults.removeObject(forKey: "myMessages")
        //self.dismiss(animated: false, completion: nil)
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.4
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
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
        //print(height)
        return height
    }
    
    
    func setUpKeyboardView()
    {
        keyboardView.frame = CGRect(x: 0, y: self.view.bounds.height - 60, width: self.view.bounds.width, height: 60)
        
        testView.frame = CGRect(x: 15, y: 5, width: self.view.bounds.width - 55, height: 40)
        testView.textAlignment = .left
        testView.textColor = .black
        testView.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        //testView.placeholder = "Type here"
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
    
    func textViewDidChange(_ textView: UITextView) {
        let msg = UITextView()
        msg.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        msg.frame = CGRect(x: 15, y: 5, width: self.view.bounds.width - 55, height: 40)
        msg.text = textView.text!
        msg.textAlignment = .left
        //msg.sizeToFit()
        
        var height = msg.sizeThatFits(CGSize(width: msg.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
        //print(height)
        if(height >= 250)
        {
            height = 250
        }
        keyboardView.frame = CGRect(x: 0, y: self.view.bounds.height - (height + self.heightOfKeyboard + 15), width: self.view.bounds.width, height: 60 + height)
        
        testView.frame = CGRect(x: 15, y: 5, width: self.view.bounds.width - 55, height: height)
        moodTB.frame = CGRect(x: 0, y: self.greetingLabel.frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height - (self.greetingLabel.frame.maxY + 60 + self.heightOfKeyboard + height))
        self.scrollToBottom()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        //keyboardView.frame = CGRect(x: 0, y: self.view.bounds.height - 60, width: self.view.bounds.width, height: 60)
        
        testView.frame = CGRect(x: 15, y: 5, width: self.view.bounds.width - 55, height: 40)
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
        saveMessageToPhone(msg: message(sender: true, msg: testView.text!))
        DispatchQueue.main.async {
            self.moodTB.beginUpdates()
            self.moodTB.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .fade)
            self.moodTB.endUpdates()
            self.scrollToBottom()
        }
        
        uploadMsg(msg: testView.text!)
        testView.text = ""
        bringKeyBoardDown()
    }
    func scheduledTimerWithTimeInterval(){
        // Should stop at certain interval
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: {_ in
        self.getNewMessages()
            self.noMessagesFooterView()
        })
        
    }
    func leftTheChat()
    {
        //print("Left the chat")
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100))
        let label = UILabel()
        label.frame = CGRect(x: 45, y: 10, width: self.view.bounds.width - 90, height: 50)
        keyboardView.removeFromSuperview()
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.text = "Anonymous user left the chat."
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: -2, height: 2)
       footerView.addSubview(label)
        let chatButton = UIButton()
        chatButton.frame = CGRect(x: self.view.bounds.width / 2  - 100, y: 60, width: 200, height: 40.0)
        chatButton.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        chatButton.setTitle("Leave", for: .normal)
        chatButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        chatButton.titleLabel?.adjustsFontSizeToFitWidth = true
        chatButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        chatButton.layer.cornerRadius = 20
        chatButton.layer.borderWidth = 2
        chatButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        chatButton.addTarget(self, action:#selector(self.leavePressed), for: .touchUpInside)
        footerView.addSubview(chatButton)
        moodTB.tableFooterView?.isHidden = false
        moodTB.tableFooterView = footerView
        self.scrollToBottom()
    }
    
    func getNewMessages()
    {
        //print("Checking for new messages!")
        
        let ref = Database.database().reference().child("Chats").child(chatID)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return }
            let value = snapshot.value as! [String : AnyObject]
           // print("amount of chaters: ", value.count)
            if(value.count <= 1)
            {
                self.timer.invalidate()
                self.leftTheChat()
                return
            }else{
            for(_, newvalue) in value
            {
                let theValue = newvalue as! [String : String]
                let theID = theValue["id"]!
                if(theID != self.id)
                {
                    if let newMessage = newvalue["\(self.thereMSGCount)"]!
                    {
                        self.thereMSGCount += 1
                        self.saveMessageToPhone(msg: message(sender: false, msg: newMessage as! String))
                        self.messages.append(message(sender: false, msg: newMessage as! String))
                        self.moodTB.beginUpdates()
                        self.moodTB.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .fade)
                        self.moodTB.endUpdates()
                        self.scrollToBottom()
                        
                    }
                    return
                }
            }
            }
        })
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            if(self.messages.count >= 1)
            {
                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                self.moodTB.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    @objc func backButtonPressed()
    {
        timer.invalidate()
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.4
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        self.timer.invalidate()
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer){
        timer.invalidate()
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
        cell.theMsg = messages[indexPath.row].msg
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
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
