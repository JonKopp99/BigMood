//
//  MoodVC.swift
//  BigMood
//
//  Created by Jonathan Kopp on 2/4/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit


class MoodVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var greetingLabel = UILabel()
    var greetinglabelView = UIView()
    var mood = String()
    var moodTB = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        moodTB.dataSource = self
        moodTB.delegate = self
        moodTB.register(moodCell.self, forCellReuseIdentifier: "moodCell")
        greetinglabelView.backgroundColor = .clear
        self.greetinglabelView.alpha = 0.0
        greetinglabelView.frame = CGRect(x: 0, y: 30, width: self.view.bounds.width, height: 60)
        greetingLabel.frame = CGRect(x: 10, y: 0, width: self.view.bounds.width - 20, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-Heavy", size: 40)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        greetingLabel.text = "Here's something to help."
        self.greetinglabelView.addSubview(greetingLabel)
        self.view.addSubview(self.greetinglabelView)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        moodTB.frame = CGRect(x: 10, y: self.view.bounds.height, width: self.view.bounds.width - 20, height: self.view.bounds.height - greetinglabelView.frame.maxY - 5)
        moodTB.separatorStyle = .none
        moodTB.backgroundColor = .clear
        self.view.addSubview(moodTB)
        moodTB.reloadData()
    }
    
    func moveLabels()
    {
        UIView.animate(withDuration: 0.7, animations: {
            self.greetinglabelView.alpha = 1.0
            
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 0.5, animations: {
                self.moodTB.frame = CGRect(x: 10, y: self.greetinglabelView.frame.maxY, width: self.view.bounds.width - 20, height: self.view.bounds.height - self.greetinglabelView.frame.maxY - 5)
                })
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        moveLabels()
    }
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moodCell") as! moodCell
        if(indexPath.row == 0)
        {
            cell.video = true
        }else{
            cell.video = false
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0)
        cell.layoutMargins = UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row >= 1 )
        {
            return self.view.bounds.height * 0.6
        }
        return self.view.bounds.height * 0.3
    }
}
