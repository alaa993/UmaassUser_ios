//
//  BookingTableViewCell.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit

class BookingTableViewCell: UITableViewCell {

    @IBOutlet weak var topCellView              : UIView!
    @IBOutlet weak var categoryFieldLabel       : UILabel!
    
    @IBOutlet weak var pastMainView             : UIView!
    @IBOutlet weak var providerImg              : UIImageView!
    @IBOutlet weak var provLab: UILabel!
    @IBOutlet weak var providerNameLabel        : UILabel!
    @IBOutlet weak var clientNameLab: UILabel!
    @IBOutlet weak var clientNameLbale          : UILabel!
    @IBOutlet weak var serviceLabel             : UILabel!
    @IBOutlet weak var servLab: UILabel!
    @IBOutlet weak var statusLabel              : UILabel!
    @IBOutlet weak var statusIconImg            : UIImageView!
    
    
    @IBOutlet weak var reservDateLabel          : UILabel!
    @IBOutlet weak var reservClockLabel         : UILabel!
    
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLabelLanguageData(label: dateLab, key: "date")
        setLabelLanguageData(label: timeLab, key: "time")
        
        setLabelLanguageData(label: provLab, key: "provider")
        setLabelLanguageData(label: clientNameLab, key: "Client Name")
        setLabelLanguageData(label: servLab, key: "Services")
        
        cornerViews(view: pastMainView, cornerValue: 6.0, maskToBounds: true)
        cornerImage(image: providerImg, cornerValue: Float(providerImg.frame.height / 2), maskToBounds: true)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
