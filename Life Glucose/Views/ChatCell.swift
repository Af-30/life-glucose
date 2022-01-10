//
//  ChatCell.swift
//  Life Glucose
//
//  Created by grand ahmad on 02/06/1443 AH.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var messageLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    enum sender {
        case me
        case other
    }
    func getMessageDesgin (sender: sender){
        var backGroundColor: UIColor?
        switch sender {
        case .me:
            backGroundColor = .init(named: "chatMe")
            messageBubble.layer.maskedCorners = [ .layerMinXMaxYCorner,.layerMinXMaxYCorner ,.layerMinXMaxYCorner ]
            messageLabel?.textAlignment = .right
        
            
        case .other:
            backGroundColor = .init(named: "chatOther")
            messageBubble.layer.maskedCorners = [ .layerMaxXMaxYCorner ,.layerMaxXMaxYCorner ,.layerMaxXMinYCorner ]
            messageLabel?.textAlignment = .left
            
           
        
        }
        messageBubble.backgroundColor = backGroundColor
        messageBubble.layer.cornerRadius = messageLabel.frame.size.height / 2.5
        messageBubble.layer.shadowOpacity = 0.1
        
    }
    
}
