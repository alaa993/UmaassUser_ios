//
//  MessageCell.swift
//  QDorProvider
//
//  Created by kavos khajavi on 11/3/20.
//  Copyright © 2020 Hesam. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
       var model:DataNotification? {
           
           didSet {
               
               label_name.text = model?.title
               label_message.text = model?.message

               let currentDate = Date()
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyy-mm-dd hh:mm"
               let convertedDate: String = dateFormatter.string(from: currentDate)
               lable_date.text = convertedDate
               
           }
    
       }
    
    @IBOutlet var label_name: UILabel!
    @IBOutlet var lable_date: UILabel!
    @IBOutlet var label_message: UILabel!
    
    
}
