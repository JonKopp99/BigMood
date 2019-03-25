//
//  messageCell.swift
//  BigMood
//
//  Created by Jonathan Kopp on 3/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import UIKit
import Foundation
class messageCell: UITableViewCell{
    var sender = Bool()
    var msg = UITextView()
    var theMsg = String()
    override func layoutSubviews() {
       msg.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        msg.isEditable = false
        msg.backgroundColor = .clear
        msg.text = theMsg
        if(sender)
        {
            //print("Width before:", msg.frame.width)
            msg.frame = CGRect(x: frame.width * 0.4, y: 0, width: frame.width - frame.width * 0.4 - 10, height: frame.height)
            msg.sizeToFit()
            msg.textAlignment = .left
            msg.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            //print("Width after:", msg.frame.width)
            let newWidth = msg.frame.width
             msg.frame = CGRect(x: frame.width - newWidth - 10, y: 0, width: newWidth, height: frame.height)
        }else{
            msg.frame = CGRect(x: 10, y: 0, width: frame.width - frame.width * 0.4 - 10, height: frame.height)
            msg.sizeToFit()
            msg.textAlignment = .left
            msg.textColor = #colorLiteral(red: 0.2392156863, green: 0.6745098039, blue: 0.968627451, alpha: 1)
        }
        //msg.adjustsFontSizeToFitWidth = true
        
        
        addSubview(msg)
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

