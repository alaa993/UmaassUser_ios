//
//  ProviderWorkingHoursVC.swift
//  Umaass
//
//  Created by Hesam on 7/1/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit


class ProviderWorkingHoursVC: UIViewController {

    @IBOutlet weak var providerTimeSchLab: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var satFromText: UITextField!
    @IBOutlet weak var satToText: UITextField!
    @IBOutlet weak var satLabel: UILabel!
    
    @IBOutlet weak var sunFromText: UITextField!
    @IBOutlet weak var sunToText: UITextField!
    @IBOutlet weak var sunLabel: UILabel!
    
    @IBOutlet weak var monFRomText: UITextField!
    @IBOutlet weak var monToText: UITextField!
    @IBOutlet weak var monLabel: UILabel!
    
    @IBOutlet weak var tueFromText: UITextField!
    @IBOutlet weak var tueToText: UITextField!
    @IBOutlet weak var tueLabel: UILabel!
    
    @IBOutlet weak var wedFromText: UITextField!
    @IBOutlet weak var wedToText: UITextField!
    @IBOutlet weak var wedLabel: UILabel!
    
    @IBOutlet weak var thuFromText: UITextField!
    @IBOutlet weak var thuToText: UITextField!
    @IBOutlet weak var thuLabel: UILabel!
    
    @IBOutlet weak var friFtomText: UITextField!
    @IBOutlet weak var friToText: UITextField!
    @IBOutlet weak var friLabel: UILabel!
    

    
    
    var days = [Int]()
    var starts = [String]()
    var ends = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMessageLanguageData(&workingHoursPageTitle, key: "working hours")
        
        setLabelLanguageData(label: satLabel, key: "Saturday")
        setLabelLanguageData(label: sunLabel, key: "Sunday")
        setLabelLanguageData(label: monLabel, key: "Monday")
        setLabelLanguageData(label: tueLabel, key: "Tuesday")
        setLabelLanguageData(label: wedLabel, key: "Wednesday")
        setLabelLanguageData(label: thuLabel, key: "Thursday")
        setLabelLanguageData(label: friLabel, key: "Friday")
        setLabelLanguageData(label: providerTimeSchLab, key: "Provider Time Schedule")
        self.navigationItem.title = workingHoursPageTitle
        
        
//        let button = UIButton.init(type: .custom)
//        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 50)
//        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 50)
//        heightConstraint.isActive = true
//        widthConstraint.isActive = true
//        button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
//        cornerButton(button: button, cornerValue: 4.0, maskToBounds: true)
//        button.setImage(UIImage.init(named: ""), for: UIControl.State.normal)
//        let logoImg = UIBarButtonItem.init(customView: button)
//        self.navigationItem.rightBarButtonItem = logoImg

        
        
        
        
       
        
        
        satFromText.isEnabled = false
        satToText.isEnabled = false
        sunFromText.isEnabled = false
        sunToText.isEnabled = false
        monFRomText.isEnabled = false
        monToText.isEnabled = false
        tueFromText.isEnabled = false
        tueToText.isEnabled = false
        wedFromText.isEnabled = false
        wedToText.isEnabled = false
        thuFromText.isEnabled = false
        thuToText.isEnabled = false
        friFtomText.isEnabled = false
        friToText.isEnabled = false
        
        for i in 0..<providerWorkingHors.count  {
            let day = providerWorkingHors[i].day ?? 1
            let start = providerWorkingHors[i].start ?? ""
            let end = providerWorkingHors[i].end ?? ""
            days.append(day)
            starts.append(start)
            ends.append(end)
        }
        print(days)
        print(starts)
        print(ends)
        
    
        cornerViews(view: mainView, cornerValue: 6.0, maskToBounds: true)
        
        // --------------------- default -------------------------
        
        if days.count > 0 {
            for j in 0..<days.count {
                print(days[j])
                
                if days.contains(0) {
                    if days[j] == 0 {
                        satFromText.backgroundColor = .white
                        satFromText.text = starts[j]
                        satToText.backgroundColor = .white
                        satToText.text = ends[j]
                        satLabel.textColor = .black
                    }
                }else{
                    satFromText.backgroundColor = offTextColor
                    satFromText.text = ""
                    satToText.backgroundColor = offTextColor
                    satToText.text = ""
                    satLabel.textColor = .lightGray
                }
                
                if days.contains(1){
                    if days[j] == 1 {
                        sunFromText.backgroundColor = .white
                        sunFromText.text = starts[j]
                        sunToText.backgroundColor = .white
                        sunToText.text = ends[j]
                        sunLabel.textColor = .black
                    }
                }else{
                    sunFromText.backgroundColor = offTextColor
                    sunFromText.text = ""
                    sunToText.backgroundColor = offTextColor
                    sunToText.text = ""
                    sunLabel.textColor = .lightGray
                }
                
                if days.contains(2){
                    if days[j] == 2 {
                        monFRomText.backgroundColor = .white
                        monFRomText.text = starts[j]
                        monToText.backgroundColor = .white
                        monToText.text = ends[j]
                        monLabel.textColor = .black
                    }
                }else{
                    monFRomText.backgroundColor = offTextColor
                    monFRomText.text = ""
                    monToText.backgroundColor = offTextColor
                    monToText.text = ""
                    monLabel.textColor = .lightGray
                }
                
                if days.contains(3) {
                    if days[j] == 3 {
                        tueFromText.backgroundColor = .white
                        tueFromText.text = starts[j]
                        tueToText.backgroundColor = .white
                        tueToText.text = ends[j]
                        tueLabel.textColor = .black
                    }
                }else{
                    tueFromText.backgroundColor = offTextColor
                    tueFromText.text = ""
                    tueToText.backgroundColor = offTextColor
                    tueToText.text = ""
                    tueLabel.textColor = .lightGray
                }
                
                if days.contains(4) {
                    if days[j] == 4 {
                        wedFromText.backgroundColor = .white
                        wedFromText.text = starts[j]
                        wedToText.backgroundColor = .white
                        wedToText.text = ends[j]
                        wedLabel.textColor = .black
                    }
                }else{
                    wedFromText.backgroundColor = offTextColor
                    wedFromText.text = ""
                    wedToText.backgroundColor = offTextColor
                    wedToText.text = ""
                    wedLabel.textColor = .lightGray
                }
                
                if days.contains(5){
                    if days[j] == 5 {
                        thuFromText.backgroundColor = .white
                        thuFromText.text = starts[j]
                        thuToText.backgroundColor = .white
                        thuToText.text = ends[j]
                        thuLabel.textColor = .black
                    }
                }else{
                    thuFromText.backgroundColor = offTextColor
                    thuFromText.text = ""
                    thuToText.backgroundColor = offTextColor
                    thuToText.text = ""
                    thuLabel.textColor = .lightGray
                }
                if days.contains(6) {
                    if days[j] == 6 {
                        friFtomText.backgroundColor = .white
                        friFtomText.text = starts[j]
                        friToText.backgroundColor = .white
                        friToText.text = ends[j]
                        friLabel.textColor = .black
                    }
                }else{
                    friFtomText.backgroundColor = offTextColor
                    friFtomText.text = ""
                    friToText.backgroundColor = offTextColor
                    friToText.text = ""
                    friLabel.textColor = .lightGray
                }
            }
        }else{
            satFromText.backgroundColor = offTextColor
            satToText.backgroundColor = offTextColor
            satLabel.textColor = .lightGray
            
            sunFromText.backgroundColor = offTextColor
            sunToText.backgroundColor = offTextColor
            sunLabel.textColor = .lightGray
            
            monFRomText.backgroundColor = offTextColor
            monToText.backgroundColor = offTextColor
            monLabel.textColor = .lightGray
            
            tueFromText.backgroundColor = offTextColor
            tueToText.backgroundColor = offTextColor
            tueLabel.textColor = .lightGray
            
            wedFromText.backgroundColor = offTextColor
            wedToText.backgroundColor = offTextColor
            wedLabel.textColor = .lightGray
            
            thuFromText.backgroundColor = offTextColor
            thuToText.backgroundColor = offTextColor
            thuLabel.textColor = .lightGray
            
            friFtomText.backgroundColor = offTextColor
            friToText.backgroundColor = offTextColor
            friLabel.textColor = .lightGray
        }
    }
    
    
    
    
    
}

var providerWeekDays = [Int]()
