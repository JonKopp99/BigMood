//
//  ViewController.swift
//  BigMood
//
//  Created by Jonathan Kopp on 2/4/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import UIKit
import Firebase


class LaunchVC: UIViewController{
    
    var greetingLabel = UILabel()
    var greetinglabelView = UIView()
    var feelingLabel = UILabel()
    var feelinglabelView = UIView()
    var moods = [UIButton()]
    var byAmount = CGFloat()
    var menuStatus = Bool()
    var menuView = UIView()
    var menuHeight = CGFloat()
    var swipeAlpha = 0.0
    var timer = Timer()
    var swipeButton = UIButton()
    var upDownAlpha = Bool()
    var backgroundImage = UIImageView()
        override func viewDidLoad() {
    super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = #colorLiteral(red: 0.4196078431, green: 0.3764705882, blue: 1, alpha: 1)
        backgroundImage.image = #imageLiteral(resourceName: "pexels-photo-392586")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
        greetinglabelView.backgroundColor = .clear
        greetinglabelView.frame = CGRect(x: 0, y: self.view.bounds.height + 60, width: self.view.bounds.width, height: 60)
        greetingLabel.frame = CGRect(x: 10, y: 0, width: self.greetinglabelView.bounds.width - 20, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "Arial-BoldMT", size: 40)
        greetingLabel.numberOfLines = 1
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        greetingLabel.text = "How are you feeling today?"
        self.greetinglabelView.addSubview(greetingLabel)
        self.view.addSubview(greetinglabelView)
        
        feelinglabelView.backgroundColor = .clear
        feelinglabelView.frame = CGRect(x: 0, y: self.view.bounds.height / 4 + 60, width: self.view.bounds.width, height: 60)
        feelingLabel.frame = CGRect(x: 10, y: 0, width: self.feelinglabelView.bounds.width - 20, height: 50)
        feelingLabel.textAlignment = .center
        feelingLabel.text = "I feel..."
        feelingLabel.numberOfLines = 1
        feelingLabel.font = UIFont(name: "Arial-BoldMT", size: 30)
        feelingLabel.adjustsFontSizeToFitWidth = true
        feelingLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        feelinglabelView.alpha = 0.0
        self.feelinglabelView.addSubview(feelingLabel)
        self.view.addSubview(feelinglabelView)
        menuStatus = false
        let swipeUp = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeUp(_:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeDown(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
        menuHeight = self.view.bounds.height * 0.1
        menuView.frame = CGRect(x: 2.5, y: self.view.bounds.height, width: self.view.bounds.width - 5, height: menuHeight)
        menuView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.1)
        menuView.layer.cornerRadius = 20
        self.view.addSubview(menuView)
        menuView.alpha = 0.0
        setUpMenu()
        scheduledTimerWithTimeInterval()
        moveLabels()
            
    //uploadTempMoods()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func moveLabels()
    {
        UIView.animate(withDuration: 1.0, animations: {
            self.greetinglabelView.frame = CGRect(x: 0, y: self.view.bounds.height / 4, width: self.view.bounds.width, height: 60)

        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 0.5, animations: {
                self.feelinglabelView.alpha = 1
                }, completion: { (finished: Bool) in
                    self.setUpButtons()
            })
        })
    }
    func setUpMenu()
    {
        let startX = self.menuView.bounds.width / 2 - 25
        
        
        let moodTrackerButton = UIButton()
        moodTrackerButton.frame = CGRect(x: startX + 65, y: 15, width: 35, height: 35)
        moodTrackerButton.setImage(#imageLiteral(resourceName: "icons8-stones-50"), for: .normal)
        menuView.addSubview(moodTrackerButton)
        
        let savedResources = UIButton()
        savedResources.frame = CGRect(x: startX, y: 15, width: 35, height: 35)
        savedResources.setImage(#imageLiteral(resourceName: "icons8-spiral-bound-booklet-50"), for: .normal)
        savedResources.addTarget(self, action: #selector(savedResourcesPressed), for: .touchUpInside)
        menuView.addSubview(savedResources)
        
        let logInButton = UIButton()
        logInButton.frame = CGRect(x: startX - 65, y: 15, width: 35, height: 35)
        logInButton.setImage(#imageLiteral(resourceName: "icons8-shutdown-50"), for: .normal)
        menuView.addSubview(logInButton)
        
        
        
        swipeButton.frame = CGRect(x: self.view.bounds.width / 2 - 25, y: self.view.bounds.height - 65, width: 50, height: 50)
        swipeButton.setImage(#imageLiteral(resourceName: "icons8-chevron-up-50"), for: .normal)
        self.view.addSubview(swipeButton)
    }
    
    @objc func savedResourcesPressed()
    {
        print("Saved Resources Pressed")
        let vc = SavedResources()
        let animation = CATransition()
        animation.type = .push
        animation.subtype = .fromBottom
        animation.duration = 0.6
        self.view.window!.layer.add(animation, forKey: nil)
        self.present(vc, animated: false, completion: nil)
    }
    func scheduledTimerWithTimeInterval(){
        if(menuStatus == false)
        {
            timer = Timer.scheduledTimer(withTimeInterval: 0.015, repeats: true, block: {_ in self.changeAlpha()})
        }
    }
    func changeAlpha()
    {
        if(swipeAlpha >= 1.0)
        {
            upDownAlpha = true
        }
        if(swipeAlpha <= 0.0)
        {
            upDownAlpha = false
        }
        if(upDownAlpha)
        {
            swipeAlpha -= 0.01
        }else{
            swipeAlpha += 0.01
        }
        if(menuStatus == false)
        {
            swipeButton.alpha = CGFloat(swipeAlpha)
        }else{
            swipeButton.alpha = 0.0
        }
    }
    func setUpButtons()
    {
        let moodString = ["Lonely","Sad","Angry","Unsure","Frustrated","Bored"]
        var ctr = 0
        let theWidth = self.view.bounds.width / 2
        while(ctr<6)
        {
            let b = UIButton()
            b.frame = CGRect(x: theWidth / 2, y: (greetinglabelView.frame.maxY + 80) + CGFloat(45 * ctr), width: theWidth, height: 40.0)
            b.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
            b.setTitle(moodString[ctr], for: .normal)
            b.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            //b.titleLabel?.sizeToFit()
            b.titleLabel?.adjustsFontSizeToFitWidth = true
            b.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
            b.layer.cornerRadius = 20
            b.layer.borderWidth = 2
            b.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            b.alpha = 0.0
            b.addTarget(self, action:#selector(self.moodPressed(_:)), for: .touchUpInside)
            self.moods.append(b)
            self.view.addSubview(b)
            ctr += 1
        }
        let unsure = UIButton()
        
        unsure.frame = CGRect(x: (theWidth / 2) - 20, y: moods[5].frame.maxY + 100, width: theWidth + 40, height: 40.0)
        unsure.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        unsure.setTitle("I'm unsure", for: .normal)
        unsure.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        unsure.titleLabel?.adjustsFontSizeToFitWidth = true
        unsure.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        unsure.layer.cornerRadius = 20
        unsure.layer.borderWidth = 2
        unsure.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        unsure.alpha = 0.0
        self.moods.append(unsure)
        self.view.addSubview(unsure)
        animateButtons(ctr: 0)
        
       
    }
    func animateButtons(ctr: Int)
    {
        if(ctr <= 7){
            UIView.animate(withDuration: 0.2, animations: {
                self.moods[ctr].alpha = 1.0
                }, completion: { (finished: Bool) in
                    self.animateButtons(ctr: ctr + 1)
            })
        }else{
            
        }
    }
    @objc func moodPressed(_ sender: UIButton)
    {
        let theMood = sender.titleLabel?.text
        var stringMood = ""
        //["Lonely","Sad","Angry","Unsure","Frustrated","Bored"]
        if(theMood == "Lonely")
        {
            print("Lonely")
            stringMood = "Lonely"
        }else if(theMood == "Sad")
        {
            print("Sad")
            stringMood = "Sad"
        }else if(theMood == "Angry")
        {
            print("Angry")
            stringMood = "Angry"
        }else if(theMood == "Unsure")
        {
            print("Unsure")
            stringMood = "Unsure"
        }else if(theMood == "Frustrated")
        {
            print("Frustrated")
            stringMood = "Frustrated"
        }else if(theMood == "Bored")
        {
            print("Bored")
            stringMood = "Bored"
        }
        let vc = MoodVC()
        vc.mood = stringMood
        let animation = CATransition()
        animation.type = .fade
        animation.subtype = .fromTop
        animation.duration = 0.6
        self.view.window!.layer.add(animation, forKey: nil)
        self.present(vc, animated: false, completion: nil)
    }
    
    func uploadTempMoods()
    {
        let moodString = ["Lonely","Sad","Angry","Unsure","Frustrated","Bored"]
       
        for i in moodString{
             let ref = Database.database().reference().child("Moods").child(i)
            ref.child("videoID").setValue("ZXsQAXx_ao0")
            ref.child("articleLink").setValue("https://medium.com/thrive-global/how-you-do-anything-is-how-you-do-everything-bc6e264e40ee")
        }
       
        
    }
    
     @objc func swipeUp(_ sender: UISwipeGestureRecognizer){
        if(menuStatus == false)
        {
        byAmount = greetinglabelView.frame.minY - 20
        UIView.animate(withDuration: 0.7, animations: {
            self.greetinglabelView.slideYUp(offSet: self.byAmount)
            self.feelinglabelView.slideYUp(offSet: self.byAmount)
            self.menuView.frame = CGRect(x: 2.5, y: self.view.bounds.height - self.menuHeight, width: self.view.bounds.width - 5, height: self.menuHeight)
            for i in self.moods{
                i.slideYUp(offSet: self.byAmount)
            }
            self.menuView.alpha = 1.0
            })
            menuStatus = true
            
        }
     }
    
    @objc func swipeDown(_ sender: UISwipeGestureRecognizer){
        
        if(menuStatus)
        {
            byAmount = -byAmount
            UIView.animate(withDuration: 0.7, animations: {
                self.greetinglabelView.slideYUp(offSet: self.byAmount)
                self.feelinglabelView.slideYUp(offSet: self.byAmount)
                self.menuView.frame = CGRect(x: 2.5, y: self.view.bounds.height, width: self.view.bounds.width - 5, height: self.menuHeight)
                for i in self.moods{
                    i.slideYUp(offSet: self.byAmount)
                }
                self.menuView.alpha = 0.0
            }, completion: { (finished: Bool) in
                self.menuStatus = false
            })
            
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    
}


