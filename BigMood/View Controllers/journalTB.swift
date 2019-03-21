//
//  journalTB.swift
//  BigMood
//
//  Created by Jonathan Kopp on 3/19/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit

class journalTB: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var backgroundImage = UIImageView()
    var greetingLabel = UILabel()
    var pages = [customDate]()
    var moodTB = UITableView()
    var addButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.image = #imageLiteral(resourceName: "blurredBackground")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.7
        self.view.addSubview(backgroundImage)
        let backgroundView = UIView(frame: backgroundImage.frame)
        backgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.8)
        self.view.addSubview(backgroundView)
        greetingLabel.frame = CGRect(x: 45, y: 25, width: self.view.bounds.width - 90, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        greetingLabel.text = "Your Journal"
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
        
        addButton = UIButton()
        addButton.frame = CGRect(x: self.view.bounds.width - 30, y: greetingLabel.frame.minY + 12.5, width: 25, height: 25)
        addButton.setImage(#imageLiteral(resourceName: "icons8-plus-50 (1)"), for: .normal)
        addButton.alpha = 0.0
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        self.view.addSubview(addButton)
        
        moodTB.dataSource = self
        moodTB.delegate = self
        moodTB.register(journalCell.self, forCellReuseIdentifier: "pages")
        
        moodTB.frame = CGRect(x: 0, y: greetingLabel.frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height - greetingLabel.frame.maxY)
        moodTB.separatorStyle = .none
        moodTB.backgroundColor = .clear
        self.view.addSubview(moodTB)
        //clearDefaults()
        getTheDates()
        insertDummyData()
        moodTB.reloadData()
        if(!pages.isEmpty){
        if(!(stripDate(theDate: pages[0]) == stripDate(theDate: getCurrentDate())))
        {
            addButton.alpha = 1.0
        }
        }else{
            addButton.alpha = 1.0
        }
    }
    func clearDefaults()
    {
        let userDefaults = Foundation.UserDefaults.standard
        userDefaults.set([], forKey: "pages")
    }
    @objc func addButtonPressed()
    {
        addButton.removeFromSuperview()
        let stringDate = stripDate(theDate: getCurrentDate())
        let userDefaults = Foundation.UserDefaults.standard
        var theDates = (userDefaults.stringArray(forKey: "pages") ?? [String]())
        theDates.append(stringDate)
        userDefaults.set(theDates, forKey: "pages")
        addNewPage(stringDate: stringDate)
    }
    func addNewPage(stringDate: String)
    {
        let values = stringDate.components(separatedBy: "-")
        let newDate = customDate(day: values[1], month: values[0], year: values[2])
        pages.insert(newDate, at: 0)
        moodTB.beginUpdates()
        moodTB.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        moodTB.endUpdates()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pages") as! journalCell
        cell.month = pages[indexPath.row].month
        cell.date = pages[indexPath.row].day
        cell.year = pages[indexPath.row].year
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = pages[indexPath.row]
        let vc = pageView()
        vc.currentDate = date
        vc.dateAsString = stripDate(theDate: date)
        let animation = CATransition()
        animation.type = .fade
        animation.subtype = .fromBottom
        animation.duration = 0.6
        self.view.window!.layer.add(animation, forKey: nil)
        self.present(vc, animated: false, completion: nil)
    }
    func getCurrentDate()->customDate
    {
        let now = NSDate()
        var currDate = customDate()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat = "YYYY"
        currDate.year = (dateFormatter.string(from: now as Date))
        dateFormatter.dateFormat = "MMMM"
        currDate.month = (dateFormatter.string(from: now as Date))
        dateFormatter.dateFormat = "d"
        currDate.day = (dateFormatter.string(from: now as Date))
        return currDate
    }
    
    func stripDate(theDate: customDate)-> String
    {
        //Save date in x - x - x format so we can later strip them apart
        let dateAsString = (theDate.month + "-" + theDate.day + "-" + theDate.year)
        return dateAsString
    }
    
    func getTheDates()
    {
        let userDefaults = Foundation.UserDefaults.standard
        let theDates = (userDefaults.stringArray(forKey: "pages") ?? [String]())
        
        if(theDates.isEmpty)
        {
            return
        }else{
            for i in theDates
            {
                let values = i.components(separatedBy: "-")
                let newDate = customDate(day: values[1], month: values[0], year: values[2])
                print(newDate)
                pages.append(newDate)
            }
        }
    
    }
    
    func insertDummyData()
    {
        var ctr = 19
        while(ctr > 0)
        {
            pages.append(customDate(day: "\(ctr)", month: "March", year: "2019"))
            ctr -= 1
        }
    }
}
struct customDate{
    var day = String()
    var month = String()
    var year = String()
}
