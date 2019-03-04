
import UIKit
import Foundation
import WebKit
class SavedCell: UITableViewCell{
    
    var videoView = WKWebView()
    var videoLink = String()
    var articleView = WKWebView()
    var articleLink = String()
    var video = Bool()
    var index = Int()
    var deleteButton = UIButton()
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
        videoView.frame = CGRect(x: 0, y: 35, width: frame.width, height: frame.height - 35)
        videoView.backgroundColor = .clear
        articleView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        articleView.frame = CGRect(x: 0, y: 35, width: frame.width, height: frame.height - 35)
        videoView.layer.cornerRadius = 10
        videoView.layer.masksToBounds = true
        articleView.layer.cornerRadius = 10
        articleView.layer.masksToBounds = true
        deleteButton.frame = CGRect(x: frame.width - 35, y: 0, width: 35, height: 35)
        deleteButton.setImage(#imageLiteral(resourceName: "icons8-cancel-50 (2)"), for: .normal)
        deleteButton.contentMode = .scaleAspectFit
        deleteButton.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        //self.addSubview(deleteButton)
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
    
    func loadYoutube(videoID:String) {
        // create a custom youtubeURL with the video ID
        guard
            let youtubeURL = NSURL(string: "https://www.youtube.com/embed/\(videoID)")
            else { return }
        // load your web request
        videoView.load(NSURLRequest(url: youtubeURL as URL) as URLRequest)
    }
    @objc func deletePressed()
    {
        let userDefaults = Foundation.UserDefaults.standard
        var theVideos = (userDefaults.stringArray(forKey: "SavedVideos") ?? [String]())
        var theArticles = (userDefaults.stringArray(forKey: "SavedArticles") ?? [String]())
        if(video)
        {
            theVideos.remove(at: index)
            userDefaults.set(theVideos, forKey: "SavedVideos")
            print("Save as video")
        }else{
            theArticles.remove(at: index)
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
