//
//  GameTableViewCell.swift
//  APIPractice
//
//  Created by Bogdan Anishchenkov on 16.09.2022.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet var gameImage: UIImageView!
    @IBOutlet var gameInfoLabel: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
