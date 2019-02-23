//
//  MoodVC.swift
//  BigMood
//
//  Created by Jonathan Kopp on 2/4/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit

class SavedResources: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var greetingLabel = UILabel()
    var greetinglabelView = UIView()
    var moodTB = UITableView()
    var videos = [video]()
    var articles = [article]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4196078431, green: 0.3764705882, blue: 1, alpha: 1)
        
        moodTB.dataSource = self
        moodTB.delegate = self
        moodTB.register(SavedCell.self, forCellReuseIdentifier: "savedCell")
        greetinglabelView.backgroundColor = .clear
        self.greetinglabelView.alpha = 0.0
        greetinglabelView.frame = CGRect(x: 0, y: 30, width: self.view.bounds.width, height: 60)
        greetingLabel.frame = CGRect(x: 10, y: 0, width: self.view.bounds.width - 20, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 40)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        greetingLabel.text = "Here's your saved resources."
        self.greetinglabelView.addSubview(greetingLabel)
        self.view.addSubview(self.greetinglabelView)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        moodTB.frame = CGRect(x: 10, y: -self.view.bounds.height, width: self.view.bounds.width - 20, height: self.view.bounds.height - greetinglabelView.frame.maxY - 5)
        moodTB.separatorStyle = .none
        moodTB.backgroundColor = .clear
        
        getSavedResources()
        self.view.addSubview(moodTB)
        
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
        let animation = CATransition()
        animation.type = .push
        animation.duration = 0.6
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (articles.count + videos.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCell") as! SavedCell
        var resourceMode = true //true if video false if article
        print(indexPath.row)
        if(indexPath.row >= videos.count)
        {
            resourceMode = false
        }
        let deleteButton = DeleteButton()
        if(resourceMode)
        {
            cell.video = true
            cell.videoLink = videos[indexPath.row].link!
            cell.index = indexPath.row
            deleteButton.tag = indexPath.row
            deleteButton.type = true
        }else{
            cell.video = false
            cell.articleLink = articles[indexPath.row - (videos.count)].link!
            cell.index = indexPath.row - (videos.count)
            deleteButton.tag = indexPath.row - videos.count
            deleteButton.type = false
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0)
        cell.layoutMargins = UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0)
        
        deleteButton.frame = CGRect(x: cell.frame.width + 35, y: 0, width: 35, height: 35)
        deleteButton.setImage(#imageLiteral(resourceName: "icons8-cancel-50 (2)"), for: .normal)
        deleteButton.contentMode = .scaleAspectFit
        deleteButton.indexPath = indexPath
        deleteButton.addTarget(self, action: #selector(self.deletePressed(_:)), for: .touchUpInside)
        cell.addSubview(deleteButton)
        //moodTB.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        return cell
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc func deletePressed(_ sender: DeleteButton?)
    {
        print("DeleteCalled")
        let theIndexRow = sender!.tag
        let video = sender!.type
        print(theIndexRow)
        
        let userDefaults = Foundation.UserDefaults.standard
        var theVideos = (userDefaults.stringArray(forKey: "SavedVideos") ?? [String]())
        var theArticles = (userDefaults.stringArray(forKey: "SavedArticles") ?? [String]())
        if(video)
        {
            theVideos.remove(at: theIndexRow)
            videos.remove(at: theIndexRow)
            userDefaults.set(theVideos, forKey: "SavedVideos")
            print("Save as video")
        }else{
            theArticles.remove(at: theIndexRow)
            articles.remove(at: theIndexRow)
            userDefaults.set(theArticles, forKey: "SavedArticles")
            print("Save as article")
        }
        moodTB.deleteRows(at: [sender!.indexPath], with: .fade)
        moodTB.reloadData()
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if(indexPath.row < videos.count)
            {
                return self.view.bounds.height * 0.35
            }
        return self.view.bounds.height * 0.6
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
    }
}


struct article{
    let link: String?
}
struct video{
    let link: String?
}

class DeleteButton : UIButton {
    var type = Bool() //Video if true false = article
    var indexPath = IndexPath()
}
