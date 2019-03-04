
import UIKit
import Foundation
import WebKit
class moodCell: UITableViewCell{
    
    var videoView = WKWebView()
    var videoLink = String()
    var articleView = WKWebView()
    var articleLink = String()
    var video = Bool()
    var saveButton = UIButton()
    var liked = Bool()
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 8
            frame.size.height -= 4 * 10
            frame.size.width -= 30
            frame.origin.x += 15
            super.frame = frame
        }
    }
    override func layoutSubviews() {
        videoView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 35)
        videoView.backgroundColor = .clear
        articleView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        articleView.frame = CGRect(x: 0, y: 35, width: frame.width, height: frame.height - 70)
        videoView.layer.cornerRadius = 10
        videoView.layer.masksToBounds = true
        articleView.layer.cornerRadius = 10
        articleView.layer.masksToBounds = true
        saveButton.frame = CGRect(x: 10, y: frame.height - 35, width: 35, height: 35)
        var image = #imageLiteral(resourceName: "icons8-heart-outline-48")
        if(video && videoLiked())
        {
            image = #imageLiteral(resourceName: "icons8-heart-filled-50")
            liked = true
        }
        if(video == false && articlesLiked())
        {
            image = #imageLiteral(resourceName: "icons8-heart-filled-50")
            liked = true
        }
        saveButton.setImage(image, for: .normal)
        saveButton.contentMode = .scaleAspectFit
        saveButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        self.addSubview(saveButton)
        if(video)
        {
            addSubview(videoView)
            loadYoutube(videoID: videoLink)
        }else{
            let url = NSURL(string: articleLink)
            let request = NSURLRequest(url: url! as URL)
            
            addSubview(articleView)
            //articleView.navigationDelegate = self
            articleView.load(request as URLRequest)
        }
    }
    
    func videoLiked() -> Bool
    {
        let userDefaults = Foundation.UserDefaults.standard
        let theVideos = (userDefaults.stringArray(forKey: "SavedVideos") ?? [String]())
        
        if(theVideos.contains(videoLink)){
            return true
        }
        return false
    }
    
    func articlesLiked() -> Bool
    {
        let userDefaults = Foundation.UserDefaults.standard
        let theArticles = (userDefaults.stringArray(forKey: "SavedArticles") ?? [String]())
        
        if(theArticles.contains(articleLink)){
            return true
        }
        return false
    }
    func loadYoutube(videoID:String) {
        // create a custom youtubeURL with the video ID
        guard
            let youtubeURL = NSURL(string: "https://www.youtube.com/embed/\(videoID)")
            else { return }
        // load your web request
        videoView.load(NSURLRequest(url: youtubeURL as URL) as URLRequest)
    }
    @objc func savePressed()
    {
        if(liked)
        {
            return
        }
        let heartAnimation = UIImageView()
        heartAnimation.image = #imageLiteral(resourceName: "icons8-heart-filled-50")
        heartAnimation.frame = CGRect(x: 27.5, y: frame.height - 17.5, width: 0, height: 0)
        self.addSubview(heartAnimation)
        self.bringSubviewToFront(heartAnimation)
        UIView.animate(withDuration: 0.8, animations: {
            
            heartAnimation.frame = CGRect(x: 10, y: self.frame.height - 35, width: 35, height: 35)
            }, completion: { (finished: Bool) in
                self.saveButton.setImage(#imageLiteral(resourceName: "icons8-heart-filled-50"), for: .normal)
        })
        let userDefaults = Foundation.UserDefaults.standard
        var theVideos = (userDefaults.stringArray(forKey: "SavedVideos") ?? [String]())
        var theArticles = (userDefaults.stringArray(forKey: "SavedArticles") ?? [String]())
        if(video)
        {
            theVideos.append(videoLink)
            userDefaults.set(theVideos, forKey: "SavedVideos")
            print("Save as video")
        }else{
            theArticles.append(articleLink)
            userDefaults.set(theArticles, forKey: "SavedArticles")
            print("Save as article")
        }
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
