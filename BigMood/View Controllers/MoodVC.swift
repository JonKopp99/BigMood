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
        greetinglabelView.frame = CGRect(x: 0, y: 30, width: self.view.bounds.width, height: 60)
        greetingLabel.frame = CGRect(x: 10, y: 0, width: self.view.bounds.width - 20, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 40)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        greetingLabel.text = "Here's something to help."
        greetingLabel.shadowColor = .black
        greetingLabel.shadowOffset = CGSize(width: -2, height: 2)
        self.greetinglabelView.addSubview(greetingLabel)
        self.view.addSubview(self.greetinglabelView)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        moodTB.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height - greetinglabelView.frame.maxY - 5)
        moodTB.separatorStyle = .none
        moodTB.backgroundColor = .clear
        
        getVideos()
        getArticles()
        
        
        setUpFooterView()
        
    }
    func setUpFooterView()
    {
        let theView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
        theView.backgroundColor = .clear
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
        self.moodTB.tableFooterView = theView
    }
    
    @objc func loadMorePressed()
    {
        print("Pressed")
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
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
        animation.type = .push
        animation.duration = 0.6
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        
        self.dismiss(animated: false, completion: nil) 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moodCell") as! moodCell
        if(indexPath.row == 0)
        {
            let index = Int(arc4random_uniform(UInt32(videos.count)))
            let newVideo = videos[index]
            self.videoID = newVideo
            cell.video = true
            cell.videoLink = newVideo
        }else{
            let index = Int(arc4random_uniform(UInt32(articles.count)))
            let newArticle = articles[index]
            self.articleLink = newArticle
            cell.video = false
            cell.articleLink = newArticle
            let fullscreenButton = UIButton(frame: CGRect(x: cell.frame.width + 50, y: cell.frame.height - 5, width: 35, height: 35))
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
        
        articleFullView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        let minimizeButton = UIButton()
        minimizeButton.frame = CGRect(x: self.view.bounds.width - 50, y: 35, width: 35, height: 35)
        minimizeButton.setImage(#imageLiteral(resourceName: "icons8-compress-50"), for: .normal)
        minimizeButton.contentMode = .scaleAspectFit
        minimizeButton.addTarget(self, action: #selector(minimizeButtonPressed(_:)), for: .touchUpInside)
        
        let articleWebView = UIWebView()
        let url = NSURL(string: articleLink)
        let request = NSURLRequest(url: url! as URL)
        articleWebView.frame = CGRect(x: 0, y: 80, width: self.view.bounds.width, height: self.view.bounds.height - 80)
        articleWebView.loadRequest(request as URLRequest)
        articleWebView.backgroundColor = .clear
        articleFullView.addSubview(articleWebView)
        self.articleFullView.addSubview(minimizeButton)
        self.view.addSubview(articleFullView)
        UIView.animate(withDuration: 1, animations: {
            self.greetinglabelView.alpha = 0.0
            self.articleFullView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            })
    }
    @objc func minimizeButtonPressed(_ sender : UIButton)
    {
        UIView.animate(withDuration: 1, animations: {
            self.greetinglabelView.alpha = 1.0
            self.articleFullView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: { (finished: Bool) in
            sender.removeFromSuperview()
            self.articleFullView.removeFromSuperview()
            
        })
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row >= 1 )
        {
            return self.view.bounds.height / 1.5
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
