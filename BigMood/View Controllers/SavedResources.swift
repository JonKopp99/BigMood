//
//  MoodVC.swift
//  BigMood
//
//  Created by Jonathan Kopp on 2/4/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit
import WebKit
class SavedResources: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var greetingLabel = UILabel()
    var greetinglabelView = UIView()
    var moodTB = UITableView()
    var videos = [video]()
    var articles = [article]()
    var backgroundImage = UIImageView()
    var articleFullView = UIView()
    var backButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4196078431, green: 0.3764705882, blue: 1, alpha: 1)
        backgroundImage.image = #imageLiteral(resourceName: "blurredBackground")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
        moodTB.dataSource = self
        moodTB.delegate = self
        moodTB.register(SavedCell.self, forCellReuseIdentifier: "savedCell")
        greetinglabelView.backgroundColor = .clear
        self.greetinglabelView.alpha = 0.0
        greetinglabelView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 90)
        greetingLabel.frame = CGRect(x: 45, y: greetinglabelView.bounds.height/2-10, width: self.view.bounds.width - 90, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        greetingLabel.text = "Here's your saved resources."
        greetingLabel.shadowColor = .black
        greetingLabel.shadowOffset = CGSize(width: -2, height: 2)
        self.greetinglabelView.addSubview(greetingLabel)
        self.view.addSubview(self.greetinglabelView)
        
        backButton = UIButton()
        backButton.frame = CGRect(x: 5, y: greetingLabel.frame.minY + 12.5, width: 25, height: 25)
        backButton.setImage(#imageLiteral(resourceName: "icons8-undo-52"), for: .normal)
        backButton.alpha = 1.0
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.greetinglabelView.addSubview(backButton)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        moodTB.frame = CGRect(x: 0, y: -self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height - greetinglabelView.frame.maxY - 5)
        moodTB.separatorStyle = .none
        moodTB.backgroundColor = .clear
        
        getSavedResources()
        noResourcesFooterView()
        self.view.addSubview(moodTB)
    
        NotificationCenter.default.addObserver(self, selector: #selector(fullScreenPressed), name: NSNotification.Name(rawValue: "fullScreen"), object: nil)
    }
    func setScrollIndicatorColor() {
        for view in self.moodTB.subviews {
            if view.isKind(of: UIImageView.self),
                let imageView = view as? UIImageView,
                let _ = imageView.image  {
                imageView.image = nil
                view.backgroundColor = #colorLiteral(red: 1, green: 0.1240289235, blue: 0.1421327487, alpha: 1)
            }
        }
        
        
        self.moodTB.flashScrollIndicators()
    }
    func noResourcesFooterView()
    {
        if(articles.isEmpty && videos.isEmpty)
        {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
            let label = UILabel()
            label.frame = CGRect(x: 45, y: 10, width: self.view.bounds.width - 90, height: 50)
            label.textAlignment = .center
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
            //label.adjustsFontSizeToFitWidth = true
            label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            label.text = "No saved resources to load..."
            //label.shadowColor = .black
            //label.shadowOffset = CGSize(width: -2, height: 2)
            footerView.addSubview(label)
            moodTB.tableFooterView = footerView
        }else{
            moodTB.tableFooterView?.isHidden = true
        }
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
        return (articles.count + videos.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "savedCell") as! SavedCell
        let cell = SavedCell()
        var resourceMode = true //true if video false if article
        print("Index Row",indexPath.row)
        if(indexPath.row > videos.count - 1)
        {
            resourceMode = false
        }
        if(resourceMode)
        {
            cell.video = true
            cell.videoLink = videos[indexPath.row].link!
            cell.index = indexPath.row
        }else{
            cell.video = false
            cell.articleLink = articles[indexPath.row - (videos.count)].link!
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0)
        cell.layoutMargins = UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0)
        
        setScrollIndicatorColor()
        return cell
        
    }
    
    @objc func fullScreenPressed(_ notification: Notification)
    {
        
        articleFullView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        let minimizeButton = UIButton()
        minimizeButton.frame = CGRect(x: self.view.bounds.width - 50, y: 35, width: 35, height: 35)
        minimizeButton.setImage(#imageLiteral(resourceName: "icons8-compress-50"), for: .normal)
        minimizeButton.contentMode = .scaleAspectFit
        minimizeButton.addTarget(self, action: #selector(minimizeButtonPressed(_:)), for: .touchUpInside)
        
        let articleWebView = WKWebView()
        let urlString = notification.userInfo?["url"]
        let url = NSURL(string: urlString as! String)
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let userDefaults = Foundation.UserDefaults.standard
            var theVideos = (userDefaults.stringArray(forKey: "SavedVideos") ?? [String]())
            var theArticles = (userDefaults.stringArray(forKey: "SavedArticles") ?? [String]())
            if(indexPath.row >= videos.count)
            {
                articles.remove(at: indexPath.row - videos.count)
                theArticles.remove(at: indexPath.row - videos.count)
                userDefaults.set(theArticles, forKey: "SavedArticles")
            }else{
                theVideos.remove(at: indexPath.row)
                videos.remove(at: indexPath.row)
                userDefaults.set(theVideos, forKey: "SavedVideos")
            }
            moodTB.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if(indexPath.row < videos.count)
            {
                return self.view.bounds.height / 2.5
            }
        return self.view.bounds.height / 1.2
    }
    func getSavedResources()
    {
        let userDefaults = Foundation.UserDefaults.standard
        let theVideos = (userDefaults.stringArray(forKey: "SavedVideos") ?? [String]())
        let theArticles = (userDefaults.stringArray(forKey: "SavedArticles") ?? [String]())
        //Get Videos
        for v in theVideos
        {
            videos.append(video(link: v))
        }
        //Get Articles
        for a in theArticles
        {
            articles.append(article(link: a))
        }
        print(articles.count)
        print(videos.count)
        self.moodTB.reloadData()
        setScrollIndicatorColor()
    }
}


struct article{
    let link: String?
}
struct video{
    let link: String?
}

class customArticleButton: UIButton{
    var articleLink = String()
}
