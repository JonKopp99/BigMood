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
    
    //var headerImage = UIImageView()
    var greetingLabel = UILabel()
    var greetinglabelView = UIView()
    var feelingLabel = UILabel()
    var feelinglabelView = UIView()
    var moods = [UIButton()]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        greetinglabelView.backgroundColor = .clear
        greetinglabelView.frame = CGRect(x: 0, y: self.view.bounds.height + 60, width: self.view.bounds.width, height: 60)
        greetingLabel.frame = CGRect(x: 10, y: 0, width: self.greetinglabelView.bounds.width - 20, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-Heavy", size: 40)
        greetingLabel.numberOfLines = 1
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        greetingLabel.text = "How are you feeling today?"
        self.greetinglabelView.addSubview(greetingLabel)
        self.view.addSubview(greetinglabelView)
        
        feelinglabelView.backgroundColor = .clear
        feelinglabelView.frame = CGRect(x: 0, y: self.view.bounds.height / 4 + 60, width: self.view.bounds.width, height: 60)
        feelingLabel.frame = CGRect(x: 10, y: 0, width: self.feelinglabelView.bounds.width - 20, height: 50)
        feelingLabel.textAlignment = .center
        feelingLabel.text = "I feel..."
        feelingLabel.numberOfLines = 1
        feelingLabel.font = UIFont(name: "AvenirNext-HeavyItalic", size: greetingLabel.font.pointSize)
        //feelingLabel.adjustsFontSizeToFitWidth = true
        feelingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        feelinglabelView.alpha = 0.0
        self.feelinglabelView.addSubview(feelingLabel)
        self.view.addSubview(feelinglabelView)
//        headerImage.image = #imageLiteral(resourceName: "justLogo")
//        headerImage.contentMode = .scaleAspectFill
//        headerImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 140)
//        self.view.addSubview(headerImage)
        //uploadTempMoods()
    }
    override func viewWillAppear(_ animated: Bool) {
        moveLabels()
    }
    override func viewDidAppear(_ animated: Bool) {
        //moveLabels()
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
    
    func setUpButtons()
    {
        let moodString = ["Lonely","Sad","Angry","Unsure","Frustrated","Bored"]
        var ctr = 0
        let theWidth = self.view.bounds.width / 2
        while(ctr<6)
        {
            let b = UIButton()
            b.frame = CGRect(x: theWidth / 2, y: (greetinglabelView.frame.maxY + 60) + CGFloat(45 * ctr), width: theWidth, height: 40.0)
            b.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
            b.setTitle(moodString[ctr], for: .normal)
            b.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            //b.titleLabel?.sizeToFit()
            b.titleLabel?.adjustsFontSizeToFitWidth = true
            b.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.5)
            b.layer.cornerRadius = 20
            b.layer.borderWidth = 2
            b.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            b.alpha = 0.0
            b.addTarget(self, action:#selector(self.moodPressed(_:)), for: .touchUpInside)
            self.moods.append(b)
            self.view.addSubview(b)
            ctr += 1
        }
        animateButtons(ctr: 0)
        
       
    }
    func animateButtons(ctr: Int)
    {
        if(ctr <= 6){
            UIView.animate(withDuration: 0.2, animations: {
                self.moods[ctr].alpha = 1.0
                }, completion: { (finished: Bool) in
                    self.animateButtons(ctr: ctr + 1)
            })
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
        let ref = Database.database().reference().child("Moods")
        ref.child("videoID").setValue("v1jOJ5fWmYE")
        ref.child("articleLink").setValue("https://medium.com/@jonathan.kopp/ultimate-health-fitness-e2a1271ad2d8")
        
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
}

