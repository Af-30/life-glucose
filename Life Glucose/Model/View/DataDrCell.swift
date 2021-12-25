//
//  DataDrTableViewCell.swift
//  Life Glucose
//
//  Created by grand ahmad on 17/05/1443 AH.
//

import UIKit

class DataDrCell: UITableViewCell {

    @IBOutlet weak var dataDrImage: UIImageView!{
        didSet{
            dataDrImage.backgroundColor = .cyan
            dataDrImage.layer.masksToBounds = true
            dataDrImage.layer.cornerRadius = dataDrImage.frame.height / 2
        }
    }
    @IBOutlet weak var nameCellDrLabel: UILabel!
    @IBOutlet weak var cityDataDrLabel: UILabel!
    @IBOutlet weak var descriptionDataDrLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with dataDr:DataDr) -> UITableViewCell {
        nameCellDrLabel.text = dataDr.name
        cityDataDrLabel.text = dataDr.city
        descriptionDataDrLabel.text = dataDr.description
        dataDrImage.loadImageUsingCache(with: dataDr.imageUrl)
        return self
    }
    
    override func prepareForReuse() {
        dataDrImage.image = nil
        dataDrImage.image = nil
    }
}
