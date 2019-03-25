//
//  pageView.swift
//  BigMood
//
//  Created by Jonathan Kopp on 3/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit

class pageView: UIViewController, UITextViewDelegate{
    var backgroundImage = UIImageView()
    var greetingLabel = UILabel()
    var currentDate = customDate()
    var dateAsString = String()
    var textView = UITextView()
    var doneButton = UIButton()
    var previewText = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        previewText = "This is your very own journal page! Write about anything you wish."
        backgroundImage.image = #imageLiteral(resourceName: "blurredBackground")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.7
        self.view.addSubview(backgroundImage)
        let backgroundView = UIView(frame: backgroundImage.frame)
        backgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.8)
        self.view.addSubview(backgroundView)
        greetingLabel.frame = CGRect(x: 50, y: 25, width: self.view.bounds.width - 100, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        greetingLabel.attributedText = getDateFormatted()
        greetingLabel.shadowColor = .black
        greetingLabel.shadowOffset = CGSize(width: -2, height: 2)
        self.view.addSubview(greetingLabel)
        
        doneButton.frame = CGRect(x: self.greetingLabel.frame.maxX - 5, y: 30, width: 50, height: 40)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: 5, y: greetingLabel.frame.minY + 12.5, width: 25, height: 25)
        backButton.setImage(#imageLiteral(resourceName: "icons8-undo-52"), for: .normal)
        backButton.alpha = 1.0
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        textView.frame = CGRect(x: 10, y: greetingLabel.frame.maxY, width: self.view.bounds.width - 20, height: self.view.bounds.height - greetingLabel.frame.maxY)
        textView.delegate = self
        textView.textAlignment = .left
        textView.textColor = UIColor.white
        
        textView.text = getText()
        textView.font = UIFont(name: "Avenir-Book", size: 20)
        textView.isSelectable = true
        textView.layer.cornerRadius = 10
        textView.autocorrectionType = .yes
        textView.spellCheckingType = UITextSpellCheckingType.yes
        textView.isEditable = true
        textView.keyboardType = UIKeyboardType.default
        textView.backgroundColor = .clear
        //textView.sizeToFit()
        self.view.addSubview(textView)
        let swipeDown = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeDown(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        textView.addGestureRecognizer(swipeDown)
        
    }
    
    @objc func donePressed()
    {
        saveText()
        doneButton.removeFromSuperview()
        textView.resignFirstResponder()
    }
    @objc func swipeDown(_ sender: UISwipeGestureRecognizer){
        saveText()
        doneButton.removeFromSuperview()
        textView.resignFirstResponder()
    }
    @objc func backButtonPressed()
    {
        saveText()
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.4
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer){
        saveText()
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.4
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        
        self.dismiss(animated: false, completion: nil)
    }
    func getText()->String
    {
        let userDefaults = Foundation.UserDefaults.standard
        let theDates = (userDefaults.string(forKey: dateAsString) ?? String())
        if(theDates.isEmpty)
        {
            return previewText
        }
        return theDates
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.view.addSubview(doneButton)
        if(textView.text == previewText)
        {
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        doneButton.removeFromSuperview()
        if(textView.text == "")
        {
            textView.text = previewText
        }
    }
    func saveText()
    {
        let theText = textView.text
        let userDefaults = Foundation.UserDefaults.standard
        userDefaults.set(theText, forKey: dateAsString)
    }
    func getDateFormatted()->NSAttributedString
    {
        let month = currentDate.month
        let date = currentDate.day
        let year = currentDate.year
        let dateString = NSMutableAttributedString(string: (month + " " + date + ", "), attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Medium", size: 30)!, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        let yearString = NSMutableAttributedString(string: (year), attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Regular", size: 27)!, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        dateString.append(yearString)
        return dateString
    }
    override func viewWillDisappear(_ animated: Bool) {
        saveText()
    }
}
