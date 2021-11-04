//
//  FavoriteTableViewCell.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import Cosmos

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var favoritView: UIView!
    @IBOutlet weak var providerImg: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    @IBOutlet weak var providerNameLbl: UILabel!
    @IBOutlet weak var firstApptLbl: UILabel!
    
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var visitlbl: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    
    @IBOutlet weak var firstExistLab: UILabel!
    
    var favCellDelegate : bookingApptCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLabelLanguageData(label: firstExistLab, key: "First exist Appointment")
        
        cornerViews(view: favoritView, cornerValue: 6.0, maskToBounds: true)
        cornerImage(image: providerImg, cornerValue: Float(providerImg.frame.height / 2), maskToBounds: true)
        
        
    }
    
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        favCellDelegate?.markeAppointment(cell: self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
