//
//  ViewController.swift
//  BigMood
//
//  Created by Jonathan Kopp on 2/4/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import UIKit
import Firebase


class NewLaunchVC: UIViewController{
    
    var greetingLabel = UILabel()
    var greetinglabelView = UIView()
    var feelinglabelView = UIView()
    var feelingLabel = UILabel()
    var byAmount = CGFloat()
    var menuStatus = Bool()
    var menuView = UIView()
    var menuHeight = CGFloat()
    var swipeAlpha = 0.0
    var timer = Timer()
    var swipeButton = UIButton()
    var upDownAlpha = Bool()
    var slider = CustomSlider()
    var currentMood = String()
    var b = UIButton()
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
        greetingLabel.shadowColor = .black
        greetingLabel.shadowOffset = CGSize(width: -2, height: 2)
        self.greetinglabelView.addSubview(greetingLabel)
        self.view.addSubview(greetinglabelView)
        
        feelinglabelView.backgroundColor = .clear
        feelinglabelView.frame = CGRect(x: 0, y: self.view.bounds.height + 260, width: self.view.bounds.width, height: 200)
        feelingLabel.frame = CGRect(x: 10, y: 90, width: self.feelinglabelView.bounds.width - 20, height: 50)
        feelingLabel.textAlignment = .center
        feelingLabel.text = "I feel happy!"
        feelingLabel.shadowColor = .black
        feelingLabel.shadowOffset = CGSize(width: -2, height: 2)
        currentMood = "Happy"
        feelingLabel.numberOfLines = 1
        feelingLabel.font = UIFont(name: "Arial-BoldMT", size: 30)
        feelingLabel.adjustsFontSizeToFitWidth = true
        feelingLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        slider = CustomSlider(frame:CGRect(x: 20, y: 40, width: self.view.bounds.width - 40, height: 50))
        slider.trackWidth = 10
        slider.minimumValue = 0
        slider.maximumValue = 6
        slider.isContinuous = true
        slider.tintColor = UIColor.white
        slider.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        slider.layer.shadowOffset = CGSize(width: -2, height: 2)
        slider.setThumbImage(#imageLiteral(resourceName: "Very Happy Emoji ").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
        slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        
        b = UIButton()
        b.frame = CGRect(x: self.view.bounds.width / 2  - 75, y: 160, width: 150, height: 40.0)
        b.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b.setTitle("Ready!", for: .normal)
        b.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b.titleLabel?.adjustsFontSizeToFitWidth = true
        b.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b.layer.cornerRadius = 20
        b.layer.borderWidth = 2
        b.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b.addTarget(self, action:#selector(self.moodPressed(_:)), for: .touchUpInside)
        feelinglabelView.alpha = 0.0
        self.feelinglabelView.addSubview(b)
        
        self.feelinglabelView.addSubview(slider)
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
        menuView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.3)
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
    
    @objc func sliderValueDidChange(_ sender: UISlider!)
    {
        let theValue = (sender.value)
       // ["Lonely","Sad","Angry","Happy","Frustrated","Bored"]["Lonely","Sad","Angry","Happy","Frustrated","Bored", "Tired"]
        if(theValue < 1)
        {
            slider.setThumbImage(#imageLiteral(resourceName: "Very Happy Emoji ").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
            feelingLabel.text = "I feel happy!"
            currentMood = "Happy"
        }else if(theValue < 2)
        {
            slider.setThumbImage(#imageLiteral(resourceName: "Unamused Emoji ").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
            feelingLabel.text = "I feel bored."
            currentMood = "Bored"
        }else if(theValue < 3)
        {
            slider.setThumbImage(#imageLiteral(resourceName: "Sleeping Emoji ").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
            feelingLabel.text = "I feel frustrated."
            currentMood = "Frustrated"
        }else if(theValue < 4)
        {
            slider.setThumbImage(#imageLiteral(resourceName: "Angry Emoji ").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
            feelingLabel.text = "I feel angry."
            currentMood = "Angry"
        }else if(theValue < 5)
        {
            slider.setThumbImage(#imageLiteral(resourceName: "Crying Emoji ").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
            feelingLabel.text = "I feel lonely."
            currentMood = "Lonely"
        }
        else
        {
            slider.setThumbImage(#imageLiteral(resourceName: "Loudly Crying Emoji ").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
            feelingLabel.text = "I feel Sad..."
            currentMood = "Sad"
        }
        
    }
    func moveLabels()
    {
        UIView.animate(withDuration: 1.0, animations: {
            self.greetinglabelView.frame = CGRect(x: 0, y: self.view.bounds.height / 4, width: self.view.bounds.width, height: 60)
            
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 1.0, animations: {
                self.feelinglabelView.alpha = 1
                self.feelinglabelView.frame = CGRect(x: 0, y: self.view.bounds.height / 4 + 60, width: self.view.bounds.width, height: 200)
                
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
        logInButton.addTarget(self, action: #selector(adminButtonPressed), for: .touchUpInside)
        menuView.addSubview(logInButton)
        
        
        
        swipeButton.frame = CGRect(x: self.view.bounds.width / 2 - 25, y: self.view.bounds.height - 65, width: 50, height: 50)
        swipeButton.setImage(#imageLiteral(resourceName: "icons8-chevron-up-50"), for: .normal)
        swipeButton.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        swipeButton.layer.shadowOffset = CGSize(width: -2, height: 2)
        self.view.addSubview(swipeButton)
    }
    
    @objc func adminButtonPressed()
    {
        let vc = adminAddResource()
        let animation = CATransition()
        animation.type = .push
        animation.subtype = .fromBottom
        animation.duration = 0.6
        self.view.window!.layer.add(animation, forKey: nil)
        self.present(vc, animated: false, completion: nil)
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
        
        animateButtons(ctr: 0)
        
        
    }
    func animateButtons(ctr: Int)
    {
    }
    @objc func moodPressed(_ sender: UIButton)
    {
        
        let vc = MoodVC()
        vc.mood = currentMood
        let animation = CATransition()
        animation.type = .fade
        animation.subtype = .fromTop
        animation.duration = 0.6
        self.view.window!.layer.add(animation, forKey: nil)
        self.present(vc, animated: false, completion: nil)
    }
    
    func uploadTempMoods()
    {
        let moodString = ["Lonely","Sad","Angry","Happy","Frustrated","Bored", "Tired"]
        
        for i in moodString{
            let ref = Database.database().reference().child("Moods").child(i)
            ref.child("videoID").setValue("ZXsQAXx_ao0")
            ref.child("articleLink").setValue("https://medium.com/thrive-global/how-you-do-anything-is-how-you-do-everything-bc6e264e40ee")
        }
        
        
    }
    
    @objc func swipeUp(_ sender: UISwipeGestureRecognizer){
        if(menuStatus == false)
        {
            byAmount = menuView.frame.height
            UIView.animate(withDuration: 0.7, animations: {
                self.greetinglabelView.slideYUp(offSet: self.byAmount)
                self.feelinglabelView.slideYUp(offSet: self.byAmount)
                self.menuView.frame = CGRect(x: 2.5, y: self.view.bounds.height - self.menuHeight, width: self.view.bounds.width - 5, height: self.menuHeight)
                self.menuView.alpha = 1.0
            })
            menuStatus = true
            
        }
    }
    func uplaodTemp()
    {
    let moodString = ["Lonely","Sad","Angry","Unsure","Frustrated","Bored"]
    
    for i in moodString{
    let ref = Database.database().reference().child("Moods").child(i)
    ref.child("videoID").setValue("ZXsQAXx_ao0")
    ref.child("articleLink").setValue("https://medium.com/thrive-global/how-you-do-anything-is-how-you-do-everything-bc6e264e40ee")
        
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
                self.menuView.alpha = 0.0
            }, completion: { (finished: Bool) in
                self.menuStatus = false
            })
            
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
}


open class CustomSlider : UISlider {
    @IBInspectable open var trackWidth:CGFloat = 2 {
        didSet {setNeedsDisplay()}
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        return CGRect(
            x: defaultBounds.origin.x,
            y: defaultBounds.origin.y + defaultBounds.size.height/2 - trackWidth/2,
            width: defaultBounds.size.width,
            height: trackWidth
        )
    }
}
