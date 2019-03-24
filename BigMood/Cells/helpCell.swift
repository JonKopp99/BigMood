//
//  helpCell.swift
//  BigMood
//
//  Created by Jonathan Kopp on 3/23/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//


import UIKit
import Foundation
class helpCell: UITableViewCell{
    var theOrganization = UILabel()
    var contact = UITextView()
    override func layoutSubviews() {
        
        theOrganization.frame = CGRect(x: 0, y: 0, width: frame.width, height: 20)
        theOrganization.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        theOrganization.backgroundColor = .clear
        theOrganization.textColor = .white
        theOrganization.adjustsFontSizeToFitWidth = true
        theOrganization.textAlignment = .center
        contact.frame = CGRect(x: 10, y: 20, width: frame.width - 20, height: 30)
        contact.isEditable = false
        contact.backgroundColor = .clear
        contact.textColor = .white
        contact.dataDetectorTypes = UIDataDetectorTypes.all
        contact.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        contact.textAlignment = .center
        contact.adjustsFontForContentSizeCategory = true
        
        addSubview(theOrganization)
        addSubview(contact)
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

