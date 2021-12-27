//
//  MainCell.swift
//  SpaceX-APP
//
//  Created by MacBook Air on 20.12.2021.
//

import UIKit

class MainCell: UITableViewCell {
    
    @IBOutlet weak var spaceXImageView: UIImageView!
    @IBOutlet weak var FlightNumberLabel: UILabel!
    @IBOutlet weak var MissionNameLabel: UILabel!
    @IBOutlet weak var LaunchYearLabel: UILabel!
    @IBOutlet weak var MissionPatchImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        spaceXImageView.layer.cornerRadius = 10.0
        spaceXImageView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
