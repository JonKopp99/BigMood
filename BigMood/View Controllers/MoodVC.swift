//
//  MoodVC.swift
//  BigMood
//
//  Created by Jonathan Kopp on 2/4/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import WebKit
class MoodVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var greetingLabel = UILabel()
    var greetinglabelView = UIView()
    var mood = String()
    var moodTB = UITableView()
    var videoID = String()
    var articleLink = String()
    var videos = [String]()
    var articles = [String]()
    var backgroundImage = UIImageView()
    var articleFullView = UIView()
    var backButton = UIButton()
    var color = UIColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4196078431, green: 0.3764705882, blue: 1, alpha: 1)
        backgroundImage.image = #imageLiteral(resourceName: "blurredBackground")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
        
        moodTB.dataSource = self
        moodTB.delegate = self
        moodTB.register(moodCell.self, forCellReuseIdentifier: "moodCell")
        
        greetinglabelView.backgroundColor = .clear
        self.greetinglabelView.alpha = 0.0
        greetinglabelView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 90)
        greetingLabel.frame = CGRect(x: 45, y: greetinglabelView.bounds.height/2-10, width: self.greetinglabelView.bounds.width - 90, height: 50)
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 35)
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        greetingLabel.text = "Here's something to help."
        if(mood == "Happy")
        {
            greetingLabel.text = "Brighten your day a little more!"
        }
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.shadowColor = .black
        greetingLabel.shadowOffset = CGSize(width: -2, height: 2)
        greetingLabel.textAlignment = .center 
        self.greetinglabelView.addSubview(greetingLabel)
        self.view.addSubview(self.greetinglabelView)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        moodTB.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height - greetinglabelView.frame.maxY - 5)
        moodTB.separatorStyle = .none
        moodTB.backgroundColor = .clear
        
        DispatchQueue.main.async {
            self.getVideos()
            self.getArticles()
        }
        
        setUpFooterView()
        
        backButton = UIButton()
        backButton.frame = CGRect(x: 5, y: greetingLabel.frame.minY + 12.5, width: 25, height: 25)
        backButton.setImage(#imageLiteral(resourceName: "icons8-undo-52"), for: .normal)
        backButton.alpha = 1.0
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.greetinglabelView.addSubview(backButton)
    }
    
    //Changes the tableViews color based on the emotion selected
    func setScrollIndicatorColor(color: UIColor) {
        for view in self.moodTB.subviews {
            if view.isKind(of: UIImageView.self),
                let imageView = view as? UIImageView,
                let _ = imageView.image  {
                imageView.image = nil
                view.backgroundColor = color
            }
        }
        
        self.moodTB.flashScrollIndicators()
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
    
    func setUpFooterView()
    {
        let theView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        theView.backgroundColor = .clear
        
        //Load More Button
        let b = UIButton()
        b.frame = CGRect(x: self.view.bounds.width / 2  - 100, y: 0, width: 200, height: 40.0)
        b.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b.setTitle("Load More", for: .normal)
        b.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b.titleLabel?.adjustsFontSizeToFitWidth = true
        b.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b.layer.cornerRadius = 20
        b.layer.borderWidth = 2
        b.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b.addTarget(self, action:#selector(self.loadMorePressed), for: .touchUpInside)
        theView.addSubview(b)
        
        //Submit video/article button
        let b2 = UIButton()
        b2.frame = CGRect(x: self.view.bounds.width / 2  + 105, y: 0, width: 40.0, height: 40.0)
        b2.setImage(#imageLiteral(resourceName: "icons8-plus-50 (1)"), for: .normal)
        b2.addTarget(self, action:#selector(self.addButtonPressed), for: .touchUpInside)
        theView.addSubview(b2)
        self.moodTB.tableFooterView = theView
        
        //Adds hotlines if its a troublesome emotion
        if(mood == "Sad" || mood == "Depressed")
        {
            theView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100)
            
            let b3 = UIButton()
            b3.frame = CGRect(x: self.view.bounds.width / 2  - 100, y: 50, width: 200, height: 40.0)
            b3.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
            b3.setTitle("Immediate Help", for: .normal)
            b3.setTitleColor(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1), for: .normal)
            b3.titleLabel?.adjustsFontSizeToFitWidth = true
            b3.addTarget(self, action:#selector(self.immediateHelpPressed), for: .touchUpInside)
            
            theView.addSubview(b3)
            
        }
    }
    
    @objc func immediateHelpPressed()
    {
        let vc = immediateHelpVC()
        let animation = CATransition()
        animation.type = .fade
        animation.subtype = .fromBottom
        animation.duration = 0.6
        self.view.window!.layer.add(animation, forKey: nil)
        
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func addButtonPressed()
    {
        let vc = userSubmit()
        vc.mood = mood
        let animation = CATransition()
        animation.type = .fade
        animation.subtype = .fromBottom
        animation.duration = 0.6
        self.view.window!.layer.add(animation, forKey: nil)
        
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func loadMorePressed()
    {
        //Changes the cells video and article to have a new random resource
        //then it refreshed the tableView
        let cell1 = tableView(moodTB, cellForRowAt: IndexPath(row: 0, section: 0)) as! moodCell
        let cell2 = tableView(moodTB, cellForRowAt: IndexPath(row: 1, section: 0)) as! moodCell
        
        videoID = videos[Int(arc4random_uniform(UInt32(videos.count)))]
        
        cell1.videoLink = videoID
        cell1.video = true
        cell2.video = false
        
        articleLink = articles[Int(arc4random_uniform(UInt32(articles.count)))]
        cell2.articleLink = articleLink
        
        moodTB.reloadRows(at: [IndexPath(row: 0, section: 0),IndexPath(row: 1, section: 0)], with: .fade)
        moodTB.reloadData()
        moodTB.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(mood == "Sad" || mood == "Depressed")
        {
            return 100
        }
        return 50
    }
    
    func moveLabels()
    {
        UIView.animate(withDuration: 0.7, animations: {
            self.greetinglabelView.alpha = 1.0
            
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 0.5, animations: {
                self.moodTB.frame = CGRect(x: 0, y: self.greetinglabelView.frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height - self.greetinglabelView.frame.maxY - 5)
                })
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        moveLabels()
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moodCell") as! moodCell
        
        //Video Cell
        if(indexPath.row == 0)
        {
            cell.video = true
            cell.videoLink = videoID
        }else{//Article cell
            cell.video = false
            cell.articleLink = articleLink
            let fullscreenButton = UIButton(frame: CGRect(x: self.view.bounds.width - 85, y: 0, width: 35, height: 35))
            fullscreenButton.setImage(#imageLiteral(resourceName: "icons8-fit-to-width-filled-50"), for: .normal)
            fullscreenButton.contentMode = .scaleAspectFit
            fullscreenButton.addTarget(self, action: #selector(fullScreenPressed), for: .touchUpInside)
            cell.addSubview(fullscreenButton)
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 25, left: 10, bottom: 25, right: 10)
        cell.layoutMargins = UIEdgeInsets(top: 25, left: 10, bottom: 25, right: 10)
        return cell
        
    }
    
    @objc func fullScreenPressed()
    {
        //Brings article view to fullscreen
        articleFullView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        let minimizeButton = UIButton()
        minimizeButton.frame = CGRect(x: self.view.bounds.width - 50, y: 35, width: 35, height: 35)
        minimizeButton.setImage(#imageLiteral(resourceName: "icons8-compress-50"), for: .normal)
        minimizeButton.contentMode = .scaleAspectFit
        minimizeButton.addTarget(self, action: #selector(minimizeButtonPressed(_:)), for: .touchUpInside)
        
        let articleWebView = WKWebView()
        let url = NSURL(string: articleLink)
        let request = NSURLRequest(url: url! as URL)
        articleWebView.frame = CGRect(x: 0, y: 80, width: self.view.bounds.width, height: self.view.bounds.height - 80)
        articleWebView.load(request as URLRequest)
        articleWebView.backgroundColor = .clear
        articleFullView.addSubview(articleWebView)
        self.articleFullView.addSubview(minimizeButton)
        self.view.addSubview(articleFullView)
        UIView.animate(withDuration: 1, animations: {
            self.greetinglabelView.alpha = 0.0
            self.backButton.alpha = 0.0
            self.articleFullView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            })
    }
    
    @objc func minimizeButtonPressed(_ sender : UIButton)
    {
        UIView.animate(withDuration: 1, animations: {
            self.greetinglabelView.alpha = 1.0
            self.backButton.alpha = 1.0
            self.articleFullView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: { (finished: Bool) in
            sender.removeFromSuperview()
            self.articleFullView.removeFromSuperview()
            
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row >= 1 )
        {
            return self.view.bounds.height / 1.2
        }
        return self.view.bounds.height / 2.5
    }
    
    func getVideos()
    {
        let ref = Database.database().reference().child("Moods").child(mood).child("videos")
        
        DispatchQueue.main.async {
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return }
            let value = snapshot.value as! [String : AnyObject]
            let theValue = value as! [String : String]
            for (_,value) in theValue
            {
                self.videos.append(value)
            }
            self.videoID = self.videos[Int(arc4random_uniform(UInt32(self.videos.count)))]
        })
        }
    }
    
    func getArticles()
    {
        
        let ref = Database.database().reference().child("Moods").child(mood).child("articles")
        DispatchQueue.main.async {
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return }
            let value = snapshot.value as! [String : AnyObject]
            let theValue = value as! [String : String]
            for (_,value) in theValue
            {
                self.articles.append(value)
            }
            
            self.moodTB.reloadData()
            self.view.addSubview(self.moodTB)
            self.setScrollIndicatorColor(color: self.color)
            self.articleLink = self.articles[Int(arc4random_uniform(UInt32(self.articles.count)))]
            //print(self.videos.count)
            
        })
            
        }
        
    }
    func getTempResources()
    {
        let ref = Database.database().reference().child("Moods").child(mood)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return }
            let value = snapshot.value as! [String : AnyObject]
                let theValue = value as! [String : String]
                self.articleLink = theValue["articleLink"]!
                self.videoID = theValue["videoID"]!
            self.moodTB.reloadData()
            
        })
        
    }
}
