//
//  ViewController.swift
//  BigMood
//
//  Created by Jonathan Kopp on 2/4/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController{
    
    

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
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        greetingLabel.text = "How are you feeling today?"
        self.greetinglabelView.addSubview(greetingLabel)
        self.view.addSubview(greetinglabelView)
        
        feelinglabelView.backgroundColor = .clear
        feelinglabelView.frame = CGRect(x: 0, y: self.view.bounds.height / 4 + 90, width: self.view.bounds.width, height: 60)
        feelingLabel.frame = CGRect(x: 10, y: 0, width: self.feelinglabelView.bounds.width - 20, height: 50)
        feelingLabel.textAlignment = .center
        feelingLabel.font = UIFont(name: "AvenirNext-HeavyItalic", size: greetingLabel.font.pointSize)
        feelingLabel.adjustsFontSizeToFitWidth = true
        feelingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        feelingLabel.text = "I feel..."
        feelinglabelView.alpha = 0.0
        self.feelinglabelView.addSubview(feelingLabel)
        self.view.addSubview(feelinglabelView)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        moveLabels()
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
        let moodString = ["😄","😵","😰","😡","😴","😶"]
        var ctr = 0
        let theWidth = Int(self.view.bounds.width / 6)
        while(ctr<6)
        {
            let b = UIButton()
            b.frame = CGRect(x: 30 + (50 * ctr) + 10, y: Int(greetinglabelView.frame.maxY + 110), width: theWidth, height: theWidth)
            b.titleLabel!.font = UIFont(name: "AvenirNext-Heavy", size: 40)
            b.setTitle(moodString[ctr], for: .normal)
            //b.titleLabel?.sizeToFit()
            b.titleLabel?.adjustsFontSizeToFitWidth = true
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
        if(theMood == "😄")
        {
            print("Happy")
            stringMood = "Happy"
        }else if(theMood == "😵")
        {
            print("Suprised")
            stringMood = "Suprised"
        }else if(theMood == "😰")
        {
            print("Sad")
            stringMood = "Sad"
        }else if(theMood == "😡")
        {
            print("Frustrated")
            stringMood = "Frustrated"
        }else if(theMood == "😴")
        {
            print("Tired")
            stringMood = "Tired"
        }else if(theMood == "😶")
        {
            print("Meh")
            stringMood = "Meh"
        }
        let vc = MoodVC()
        vc.mood = stringMood
        self.present(vc, animated: true, completion: nil)
    }
}

