
import UIKit
import Foundation

class moodCell: UITableViewCell{
    
    var videoView = UIWebView()
    var videoLink = String()
    var articleView = UIWebView()
    var articleLink = String()
    var video = Bool()
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 8
            frame.size.height -= 4 * 10
            super.frame = frame
        }
    }
    override func layoutSubviews() {
        videoView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        videoView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        articleView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        articleView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        if(video)
        {
            addSubview(videoView)
            loadYoutube(videoID: "v1jOJ5fWmYE")
        }else{
            let url = NSURL(string: "https://medium.com/@jonathan.kopp/ultimate-health-fitness-e2a1271ad2d8")
            let request = NSURLRequest(url: url! as URL)
            addSubview(articleView)
            //articleView.navigationDelegate = self
            articleView.loadRequest(request as URLRequest)
        }
    }
    
    func loadYoutube(videoID:String) {
        // create a custom youtubeURL with the video ID
        guard
            let youtubeURL = NSURL(string: "https://www.youtube.com/embed/\(videoID)")
            else { return }
        // load your web request
        videoView.loadRequest(NSURLRequest(url: youtubeURL as URL) as URLRequest)
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
