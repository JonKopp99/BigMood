//
//  journalCell.swift
//  BigMood
//
//  Created by Jonathan Kopp on 3/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//


import UIKit
import Foundation
class journalCell: UITableViewCell{
    var dateLabel = UILabel()
    var date = String()
    var month = String()
    var year = String()
    override func layoutSubviews() {
        let dateString = NSMutableAttributedString(string: (month + " " + date + ", "), attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Medium", size: 25)!, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        let yearString = NSMutableAttributedString(string: (year), attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Regular", size: 23)!, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        dateString.append(yearString)
        dateLabel.frame = CGRect(x: 40, y: 0, width: frame.width - 40, height: frame.height)
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.textColor = .white
        dateLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        dateLabel.attributedText = dateString
        dateLabel.textAlignment = .left
        addSubview(dateLabel)
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
