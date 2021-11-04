//
//  SetDateTimeVC.swift
//  Umaass
//
//  Created by Hesam on 7/1/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import FSCalendar



class SetDateTimeVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var oneStepLabel         : UILabel!
    @IBOutlet weak var setApptLab: UILabel!
    
    @IBOutlet weak var twoStepLabel         : UILabel!
    @IBOutlet weak var userInfoLab: UILabel!
    
    @IBOutlet weak var threeStepLabel       : UILabel!
    @IBOutlet weak var submitLab: UILabel!
    
    @IBOutlet weak var continueOutletBtn    : UIButton!
    @IBOutlet weak var calendar             : FSCalendar!
    @IBOutlet weak var doneBtn              : UIButton!
    
    @IBOutlet var setTimePopView            : UIView!
  
  
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var reservedTimaLabel    : UILabel!
    @IBOutlet weak var reservTimeLab: UILabel!
    @IBOutlet weak var separatorLabel       : UILabel!
    

    
    
// ------------------------------------------
    var presentdays = [String]()
    var absentdays = [String]()
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    
    
    var blackView = UIView()
    var strDate = String()
    var selectedDateStr = String()
    var selectedDate = Date()
    var selectedTime = String()
    var currentDate   = Date()


    
    let requestedComponent     : Set<Calendar.Component> = [.day,.hour,.minute,.second]
    let userCalendar           = Calendar.current
    
       var hoursArray = [String]()
       var minArray = [String]()
    var enterCorrectDate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setLabelLanguageData(label: reservTimeLab, key: "Date appointment")
        setLabelLanguageData(label: setApptLab, key: "set date")
        setLabelLanguageData(label: userInfoLab, key: "User Information")
        setLabelLanguageData(label: submitLab, key: "submit appot")
        setButtonLanguageData(button: continueOutletBtn, key: "Continue")
        setButtonLanguageData(button: doneBtn, key: "Done")
        
        setMessageLanguageData(&setDatePageTitle, key: "set date")
        self.navigationItem.title = setDatePageTitle
        // ------------- banner view --------------

        
        getCurrentDate()
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

        reservedTimaLabel.isHidden = true
        separatorLabel.isHidden = true
        continueOutletBtn.isEnabled = false
        continueOutletBtn.backgroundColor = .lightGray
        cornerLabel(label: oneStepLabel, cornerValue: Float(oneStepLabel.frame.height / 2), maskToBounds: true)
        cornerLabel(label: twoStepLabel, cornerValue: Float(twoStepLabel.frame.height / 2), maskToBounds: true)
        cornerLabel(label: threeStepLabel, cornerValue: Float(threeStepLabel.frame.height / 2), maskToBounds: true)
        cornerButton(button: continueOutletBtn, cornerValue: 6.0, maskToBounds: true)
        cornerButton(button: doneBtn, cornerValue: 6.0, maskToBounds: true)
        calendar?.register(FSCalendarCell.self, forCellReuseIdentifier: "CalendarCell")
        cornerViews(view: setTimePopView, cornerValue: 6.0, maskToBounds: true)
        
        self.calendar.firstWeekday = 7
        self.calendar.appearance.todayColor = .orange
        
        //self.calendar.locale = Locale(identifier: "en_GB")
        self.calendar.calendarHeaderView.collectionViewLayout.collectionView?.semanticContentAttribute = .forceLeftToRight
        self.calendar.collectionViewLayout.collectionView?.semanticContentAttribute = .forceLeftToRight
        FSCalendar.appearance().semanticContentAttribute = .forceLeftToRight
        //        timePickerView.datePickerMode = .time
        //        timePickerView.minuteInterval = 30
        //        timePickerView.locale = Locale(identifier: "en_GB")
        
        
        minArray = ["00","05","10","15","20","25","30","35","40","45","50","55"]
        timePickerView.delegate = self
        timePickerView.dataSource = self
    }
    
// ********************************* Calendar *************************************
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "CalendarCell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        if date .compare(Date()) == .orderedSame {
            
            return false
        }
        else {
            return CheckWeekend(today: date)
        }
    }
    
    func CheckWeekend(today:Date) -> Bool{
        var DayExist:Bool
        // let today = NSDate()
        
        let calendar = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
        let components = calendar!.components([.weekday], from: today)
        
        print(providerWeekDays)
        print(components.weekday)
        
        if components.weekday == 7 && providerWeekDays.contains(0) {
            print("It's Working day")
            DayExist = true
        }else if providerWeekDays.contains(components.weekday ?? 0){
            print("It's Working day")
            DayExist = true
        }else{
            print("holiday")
            DayExist = false
        }
        print("weekday :\(String(describing: components.weekday)) ")
        return DayExist
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let calendar = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
        let components = calendar!.components(.weekday, from: date)
        if (providerWeekDays.contains(components.weekday ?? 0)) || (components.weekday == 7 && providerWeekDays.contains(0)){
            return greenColor
        }else{
            return UIColor.lightGray
        }
    }
    
    
    
    func getCurrentDate() {
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        currentDate = date as Date
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        selectedDate = date
        selectedDateStr = "\(date)"
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "en_GB")
        dateFormater.dateFormat = "YYYY-MM-dd"
        strDate = dateFormater.string(from: date)
        print(strDate)
        //        providerWorkingHors
        
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: currentDate, to: selectedDate as Date)
        
        if (timeDifference.day! < 0) {
            reservedTimaLabel.isHidden = true
            separatorLabel.isHidden = true
            continueOutletBtn.isEnabled = false
            continueOutletBtn.backgroundColor = .lightGray
            setMessageLanguageData(&enterCorrectDate, key: "Please enter correct date")
            self.displayAlertMsg(userMsg: enterCorrectDate)
        }else{
            
            
            let dateInWeek =   getDayOfWeek(strDate)
            
            hoursArray.removeAll()
            providerWorkingHors.forEach { (item) in
                
                if item.day == dateInWeek! || (item.day == 0 && dateInWeek! == 7) {
                    
                    let spliteStart =   (item.start ?? "0").split(separator: ":")
                    if spliteStart.count < 1 {
                        return
                    }
                    let s =  spliteStart[0]
                    let  start:Int = Int(s)!
                    
                    let spliteend =   (item.end ?? "0").split(separator: ":")
                    if spliteend.count < 1 {
                        return
                    }
                    let e =  spliteend[0]
                    let  end:Int = Int(e)!
                    
                    if start > end {
                        
                        for index in start...24 {
                            
                            if index < 10 {
                                hoursArray.append("0\(String(index))")
                            }else {
                                hoursArray.append(String(index))
                            }
                            
                            
                        }
                        
                        for index in 1...end {
                            
                            if index < 10 {
                                hoursArray.append("0\(String(index))")
                            }else {
                                hoursArray.append(String(index))
                            }
                            
                        }
                        
                    }else {
                        
                        for index in start...end {
                            if index < 10 {
                                hoursArray.append("0\(String(index))")
                            }else {
                                hoursArray.append(String(index))
                            }
                        }
                        
                    }
                    
                }
                
                
            }
            
            timePickerView.reloadComponent(0)
            popAnimationIn(popView: setTimePopView)
            
        }
    }
    
    
    
    @IBAction func popDismissTapped(_ sender: Any) {
        popAnimateOut(popView: setTimePopView)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.persian)! as Calendar
        self.view.endEditing(true)
        
      
        let selectedYearPicker = hoursArray[timePickerView.selectedRow(inComponent:0)]
        print(selectedYearPicker)
        
        
        
        let selectedYearPicker2 = minArray[timePickerView.selectedRow(inComponent:1)]
        print(selectedYearPicker2)
        

         reservedTimaLabel.text = (strDate + " - " + "\(selectedYearPicker):\(selectedYearPicker2)")
         fromTo = (strDate + " " + "\(selectedYearPicker):\(selectedYearPicker2)")
 
        
        reservedTimaLabel.isHidden = false
        separatorLabel.isHidden = false
        continueOutletBtn.isEnabled = true
        continueOutletBtn.backgroundColor = blueColor
        
        
    }
    
    // ********************************* time picker view *************************************
    
    
    @IBAction func actionTimePiker(_ sender: Any) {
        
       popAnimateOut(popView: setTimePopView)
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        performSegue(withIdentifier: "toInformation", sender: self)
    }
    
    // -------------------------------- Animation -------------------------------
    func popAnimationIn(popView: UIView){
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.7)
            blackView.frame = window.frame
            window.addSubview(blackView)
            popView.center = self.view.center
            popView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            popView.alpha = 0
            UIApplication.shared.keyWindow?.addSubview(popView)
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                popView.alpha = 1
                popView.transform = CGAffineTransform.identity
            }){ (success:Bool) in
                
            }
        }
    }
    
    func popAnimateOut(popView: UIView){
        UIView.animate(withDuration: 0.5, animations: {
            popView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            popView.alpha = 0
            self.blackView.alpha = 0
        }) { (success:Bool) in
            popView.removeFromSuperview()
        }
    }
    
    func displayAlertMsg(userMsg: String){
        setMessageLanguageData(&msgAlert, key: "Warrning")
        setMessageLanguageData(&msgOk, key: "Ok")
        
        let myAlert = UIAlertController(title: msgAlert ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: msgOk,style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil);
    }
}

extension SetDateTimeVC:UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return hoursArray.count
        }else {
            return minArray.count
        }
        
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return hoursArray[row]
        }else {
            return minArray[row]
        }
    }
    
       /* func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            var lable: UILabel
            if let view = view as? UILabel{
                lable = view
            }else {
                lable = UILabel()
            }
            lable.textColor     = .black

            if component == 0 {
                lable.textAlignment = .center
                lable.text = hoursArray[row]
                if row == 0 {
                     reservedTimaLabel.text = (strDate + " - " + "\(hoursArray[row]):00")
                        fromTo = (strDate + " " + "\(hoursArray[row]):00")
                }
            }else {

                lable.textAlignment = .center
                lable.text = minArray[row]
            }

            return lable
        }*/
    
    
}
