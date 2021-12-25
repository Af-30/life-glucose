//
//  DataDrTableViewCell.swift
//  Life Glucose
//
//  Created by grand ahmad on 17/05/1443 AH.
//

import UIKit

class DataDrCell: UITableViewCell {

    @IBOutlet weak var dataCellImage: UIImageView!{
        didSet{
            dataCellImage.backgroundColor = .cyan
            dataCellImage.layer.masksToBounds = true
            dataCellImage.layer.cornerRadius = dataCellImage.frame.height / 2
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
    
    func configure(with dataDr:DoctorModel) -> UITableViewCell {
        nameCellDrLabel.text = dataDr.name
        cityDataDrLabel.text = dataDr.city
        descriptionDataDrLabel.text = dataDr.description
        dataCellImage.loadImageUsingCache(with: dataDr.imageUrl)
        return self
    }
    
    override func prepareForReuse() {
        dataCellImage.image = nil
        dataCellImage.image = nil
    }
}
