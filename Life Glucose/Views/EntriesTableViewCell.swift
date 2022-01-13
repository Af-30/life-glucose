//
//  EntriesTableViewCell.swift
//  Life Glucose
//
//  Created by grand ahmad on 01/06/1443 AH.
//

import UIKit

class EntriesTableViewCell: UITableViewCell {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var glucose: UILabel!
    @IBOutlet weak var imageViewCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("+++++++++++++++++++++\(resultLabel.text)")
        if resultLabel.text == "normal" || resultLabel.text == "طبيعي" {
            resultLabel.textColor  = UIColor.green

        }
        if resultLabel.text == "hight" || resultLabel.text == "مرتفع" {
            resultLabel.textColor  = UIColor.red
        }
//        }else{
//            resultLabel.textColor  = UIColor.yellow
//        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
