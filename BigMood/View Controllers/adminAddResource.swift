//
//  adminAddResource.swift
//  BigMood
//
//  Created by Jonathan Kopp on 2/26/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class adminAddResource: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    var moods = ["Lonely","Sad","Angry","Happy","Frustrated","Bored"]
    var moodTextField = UITextField()
    var dropDown = UIPickerView()
    var video = Bool()
    var inputText = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4196078431, green: 0.3764705882, blue: 1, alpha: 1)
        
        dropDown.delegate = self
        dropDown.dataSource = self
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        moodTextField.frame = CGRect(x: 10, y: 100, width: self.view.bounds.width - 20, height: 50)
        moodTextField.textAlignment = .center
        moodTextField.textColor = .white
        moodTextField.font = UIFont(name: "AvenirNext-DemiBold", size: 50)
        dropDown.frame = CGRect(x: 10, y: 150, width: self.view.bounds.width - 20, height: 300)
        
        self.view.addSubview(moodTextField)
        self.view.addSubview(dropDown)
    }
    
    
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer){
        let animation = CATransition()
        animation.type = .push
        animation.duration = 0.6
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        
        self.dismiss(animated: false, completion: nil)
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return moods.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return moods[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.moodTextField.text = self.moods[row]
        self.dropDown.isHidden = true
        showButtons()
    }
    
    func showButtons()
    {
        let b = UIButton()
        b.frame = CGRect(x: self.view.bounds.width / 2  - 150, y: 160, width: 150, height: 40.0)
        b.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b.setTitle("Video", for: .normal)
        b.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b.titleLabel?.adjustsFontSizeToFitWidth = true
        b.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b.layer.cornerRadius = 20
        b.layer.borderWidth = 2
        b.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b.addTarget(self, action:#selector(self.videoPressed(_:)), for: .touchUpInside)
        
        
        let b2 = UIButton()
        b2.frame = CGRect(x: self.view.bounds.width / 2, y: 160, width: 150, height: 40.0)
        b2.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b2.setTitle("Article", for: .normal)
        b2.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b2.titleLabel?.adjustsFontSizeToFitWidth = true
        b2.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b2.layer.cornerRadius = 20
        b2.layer.borderWidth = 2
        b2.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b2.addTarget(self, action:#selector(self.articlePressed(_:)), for: .touchUpInside)
        
        self.view.addSubview(b)
        self.view.addSubview(b2)
    }
    
    @objc func videoPressed(_ sender: UIButton)
    {
        sender.backgroundColor = #colorLiteral(red: 0.2392156863, green: 0.6745098039, blue: 0.968627451, alpha: 1).withAlphaComponent(0.5)
        video = true
        inputText.frame = CGRect(x: 10, y: 210, width: self.view.bounds.width - 20, height: 50)
        inputText.textAlignment = .center
        inputText.textColor = .black
        inputText.font = UIFont(name: "AvenirNext-DemiBold", size: 10)
        inputText.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.4)
        inputText.placeholder = "Enter video Link"
        inputText.returnKeyType = UIReturnKeyType.done
        self.view.addSubview(inputText)
        
        let b = UIButton()
        b.frame = CGRect(x: self.view.bounds.width / 2  - 75, y: 270, width: 150, height: 40.0)
        b.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b.setTitle("Done", for: .normal)
        b.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b.titleLabel?.adjustsFontSizeToFitWidth = true
        b.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b.layer.cornerRadius = 20
        b.layer.borderWidth = 2
        b.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b.addTarget(self, action:#selector(self.donePressed), for: .touchUpInside)
        self.view.addSubview(b)
    }
    @objc func articlePressed(_ sender: UIButton)
    {
        video = false
        sender.backgroundColor = #colorLiteral(red: 0.2392156863, green: 0.6745098039, blue: 0.968627451, alpha: 1).withAlphaComponent(0.5)
        inputText.frame = CGRect(x: 10, y: 210, width: self.view.bounds.width - 20, height: 50)
        inputText.textAlignment = .center
        inputText.textColor = .black
        inputText.font = UIFont(name: "AvenirNext-DemiBold", size: 10)
        inputText.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.4)
        inputText.placeholder = "Enter article Link"
        inputText.adjustsFontSizeToFitWidth = false
        inputText.returnKeyType = UIReturnKeyType.done
        self.view.addSubview(inputText)
        
        let b = UIButton()
        b.frame = CGRect(x: self.view.bounds.width / 2  - 75, y: 270, width: 150, height: 40.0)
        b.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b.setTitle("Done", for: .normal)
        b.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b.titleLabel?.adjustsFontSizeToFitWidth = true
        b.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b.layer.cornerRadius = 20
        b.layer.borderWidth = 2
        b.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b.addTarget(self, action:#selector(self.donePressed), for: .touchUpInside)
        self.view.addSubview(b)
    }
    @objc func donePressed()
    {
        let resource = inputText.text!
        let mood = moodTextField.text!
        print(mood)
        print(resource)
        var type = "videoID"
        if(video == false)
        {
            type = "articleLink"
        }
        let ref = Database.database().reference().child("Moods").child(mood).child(type)
        ref.setValue(resource)
    } 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.moodTextField {
            self.dropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
        
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
