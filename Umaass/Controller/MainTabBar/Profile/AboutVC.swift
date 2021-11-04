//
//  AboutVC.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit


class AboutVC: UIViewController {

    @IBOutlet weak var whoLab: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var passedtext      : String?
    var passedValueType = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.layer.cornerRadius = 8.0
        scrollView.layer.masksToBounds = true
        if #available(iOS 11.0, *) {
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: textLabel.bottomAnchor).isActive = true
        } else {
            scrollView.bottomAnchor.constraint(equalTo:textLabel.bottomAnchor).isActive = true
        }
        
        setLabelLanguageData(label: whoLab, key: "Who we are")
        
        

        
        
        setMessageLanguageData(&aboutusPageTitle, key: "about us")
        self.navigationItem.title = aboutusPageTitle
        
        let data = self.passedtext?.data(using: String.Encoding.unicode)!
        if data != nil {
            let attrStr = try? NSMutableAttributedString(data: data!,options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],documentAttributes: nil)
            
            attrStr!.addAttributes([NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSMutableAttributedString.Key.foregroundColor: UIColor.black], range: NSMakeRange(0, attrStr!.length))
            
            self.textLabel.attributedText = attrStr
        }else{
            self.textLabel.text = "About app ..."
        }
        
    }
}
