//
//  RatingListViewCell.swift
//  LOG
//
//  Created by zeyadel3ssal on 6/11/19.
//  Copyright © 2019 zeyadel3ssal. All rights reserved.
//

import UIKit

class RatingListViewCell: UITableViewCell {

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var gameLabel: UILabel!
    
    
    override func prepareForReuse() {
        cosmosView.prepareForReuse()
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
