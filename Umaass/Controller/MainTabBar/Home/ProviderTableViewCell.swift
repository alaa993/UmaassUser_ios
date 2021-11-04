//
//  ProviderTableViewCell.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import Cosmos

protocol bookingApptCellDelegate {
    func BookingApptCell(cell: UITableViewCell)
    func markeAppointment(cell: UITableViewCell)
}

class ProviderTableViewCell: UITableViewCell {

    @IBOutlet weak var providerListMainView         : UIView!
    @IBOutlet weak var providerImage                : UIImageView!
    @IBOutlet weak var providerNameLabel            : UILabel!
    @IBOutlet weak var providerViewsLabel           : UILabel!
    @IBOutlet weak var firstExistApptLabel          : UILabel!
    @IBOutlet weak var bookOutletBtn                : UIButton!
    @IBOutlet weak var markBtnOtlet                 : UIButton!
    @IBOutlet weak var distanceLabel                : UILabel!
    @IBOutlet weak var expertiesLAbel               : UILabel!
    @IBOutlet weak var rateView                     : CosmosView!
    
    @IBOutlet weak var firstApptTimeLab: UILabel!
    
    
    var provideCellDelegate : bookingApptCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cornerViews(view: providerListMainView, cornerValue: 6.0, maskToBounds: true)
        cornerButton(button: bookOutletBtn, cornerValue: 4.0, maskToBounds: true)
        cornerImage(image: providerImage, cornerValue: Float(providerImage.frame.height / 2), maskToBounds: true)
        
        setLabelLanguageData(label: firstApptTimeLab, key: "First exist Appointment")
        setButtonLanguageData(button: bookOutletBtn, key: "Book now")
        
    }
    
    @IBAction func bookingTapped(_ sender: Any) {
        print("tapped")
        provideCellDelegate?.BookingApptCell(cell: self)
    }
    
    
    @IBAction func markApptTapped(_ sender: UIButton) {
        provideCellDelegate?.markeAppointment(cell: self)
    }
    
}
