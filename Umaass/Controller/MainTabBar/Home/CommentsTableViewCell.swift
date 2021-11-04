//
//  CommentsTableViewCell.swift
//  Umaass
//
//  Created by Hesam on 7/1/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import Cosmos

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    @IBOutlet weak var starRateView: CosmosView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cornerImage(image: userImage, cornerValue: Float(userImage.frame.height / 2), maskToBounds: true)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
