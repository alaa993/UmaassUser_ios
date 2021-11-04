//
//  EditAppointmentVC.swift
//  Umaass
//
//  Created by Hesam on 7/10/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class EditAppointmentVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var scrollView       : UIScrollView!
    @IBOutlet weak var clentNameText    : UITextField!
    @IBOutlet weak var phonNumberText   : UITextField!
    @IBOutlet weak var descriptionText  : UITextField!
    @IBOutlet weak var genderText       : UITextField!
    @IBOutlet weak var dateText         : UITextField!
    @IBOutlet weak var timeText         : UITextField!
    
    @IBOutlet weak var clientNamLab: UILabel!
    @IBOutlet weak var phonLabe: UILabel!
    @IBOutlet weak var descLab: UILabel!
    @IBOutlet weak var genderLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var timeLabe: UILabel!
    
    
    
    
    var passedClientName : String?
    var passedNumber     : String?
    var passedDesc       : String?
    var passedGender     : String?
    var passedDate       : String?
    var passedTime       : String?
    var passedApptId     : Int?
    
    var genderPicker          = UIPickerView()
    var genderToolBar         = UIToolbar()
    
    var datePicker            = UIDatePicker()
    var datePickerToolBar     = UIToolbar()
    
    var timePicker            = UIDatePicker()
    var timePickerToolBar     = UIToolbar()
    
    var genderArr             = [String]()
    var strDate               = String()
    var selectedDate          = String()
    var updateModel           : [updateApptInfoModel] = []
    var finalUrl              = String()
    
    var updateAppt = String()
    var expiredate = String()
    
    var currentDate   = Date()
    let requestedComponent     : Set<Calendar.Component> = [.day,.hour,.minute,.second]
    let userCalendar           = Calendar.current
    var fromDate     = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentDate()
        
        if resourceKey == "en" {
            genderArr.append("Male")
            genderArr.append("Female")
        }
        if resourceKey == "ar" {
            genderArr.append("ذكر")
            genderArr.append("أنثى")
        }
        if resourceKey == "ckb" {
            genderArr.append("نێر")
            genderArr.append("مێ")
        }
        
        
        setLabelLanguageData(label: clientNamLab, key: "Client Name")
        setLabelLanguageData(label: phonLabe, key: "phone")
        setLabelLanguageData(label: descLab, key: "description")
        setLabelLanguageData(label: genderLab, key: "Gender")
        setLabelLanguageData(label: dateLab, key: "date")
        setLabelLanguageData(label: timeLabe, key: "time")
        
        setTextHintLanguageData(text: clentNameText, key: "Client Name")
        setTextHintLanguageData(text: phonNumberText, key: "phone")
        setTextHintLanguageData(text: descriptionText, key: "description")
        setTextHintLanguageData(text: genderText, key: "Gender")
        setTextHintLanguageData(text: dateText, key: "date")
        setTextHintLanguageData(text: timeText, key: "time")
        
        
        setMessageLanguageData(&editApptInfoPageTitle, key: "Edit")
        self.navigationItem.title = editApptInfoPageTitle
        // fill text ---------
        clentNameText.text = passedClientName
        phonNumberText.text = passedNumber
        descriptionText.text = passedDesc
        genderText.text = passedGender
        dateText.text = passedDate
        timeText.text = passedTime
        
        createGenderPicker()
        createGenderToolBar()
        createDatePicker()
        createDatePickerToolBar()
        createTimePicker()
        createTimePickerToolBar()
        
        
        setMessageLanguageData(&navigationSave, key: "save")
        let saveEdit = UIBarButtonItem(title: navigationSave, style: .plain, target: self, action: #selector(saveChanges))
        self.navigationItem.rightBarButtonItem = saveEdit
    }
    
    var datee = Date()
    func getCurrentDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        currentDate = datee as Date
    }
    
    @objc func saveChanges(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        fromDate = dateFormatter.date(from: dateText.text ?? "") ?? datee as Date
        
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: currentDate, to: fromDate)
        if (timeDifference.day! < 0) {
            setMessageLanguageData(&expiredate, key: "Appointment date is expired. Please enter correct date")
            self.displayAlertMsg(userMsg: expiredate)
        }else{
            setMessageLanguageData(&enterYourName, key: "Enter your name")
            setMessageLanguageData(&selectYourGender, key: "Select your Gender")
            setMessageLanguageData(&enterYourNumber, key: "Please Enter Your Number")
            
            
            if (clentNameText.text == "") || ((clentNameText.text?.isEmpty)!) || (phonNumberText.text == "") || ((phonNumberText.text?.isEmpty)!) || (genderText.text == "") || ((genderText.text?.isEmpty)!){
                
                if (clentNameText.text == "") || ((clentNameText.text?.isEmpty)!) {
                    displayAlertMsg(userMsg: enterYourName)
                }
                if (phonNumberText.text == "") || ((phonNumberText.text?.isEmpty)!) {
                    displayAlertMsg(userMsg: enterYourNumber)
                }
                
                if (genderText.text == "") || ((genderText.text?.isEmpty)!) {
                    displayAlertMsg(userMsg: selectYourGender)
                }
            }else{
                loading()
                
                var nameTxt = (clentNameText?.text ?? "")
                if let encodText = nameTxt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                    print(encodText)
                    nameTxt = encodText
                }
                
                var descTxt = (descriptionText?.text ?? "")
                if let encodText = descTxt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                    print(encodText)
                    descTxt = encodText
                }
                
                let baseurll = baseCustomerUrl + "appointments/" + "\(passedApptId ?? 1)"
                let firstUrl = "?client_name=" + nameTxt + "&client_phone=" + (phonNumberText.text ?? "")
                let secUrl = "&client_age=&client_gender=" + "\(clientGender ?? 1)"
                let lastUrl = "&description=" + descTxt
                let fromto = "&from_to=" + ((dateText.text ?? "") + " " + (timeText.text ?? ""))
                let finalU = baseurll + firstUrl + secUrl + lastUrl + fromto
                
                if finalU.contains(" ")  {
                    finalUrl = finalU.replacingOccurrences(of: " ", with: "%20")
                }else{
                    finalUrl = finalU
                }
                
                print(finalUrl)
                let headers:HTTPHeaders = [
                    "Authorization": "Bearer \(accessToken)",
                    "X-Requested-With": "application/json",
                    "Content-type" : "application/json",
                    "Accept" : "application/json"
                ]
                
                Alamofire.request(finalUrl, method: .put, headers: headers).responseJSON { response in
                    self.dismissLoding()
                    if let value: AnyObject = response.result.value as AnyObject? {
                        let post = JSON(value)
                        print(post)
                        let status = response.response?.statusCode
                        print(status)
                        let data = post["data"].dictionary
                        print(data)
                        if status == 200 {
                            setMessageLanguageData(&self.updateAppt, key: "Your Appointment Successfully Updated")
                            self.displaySuccessMsg(userMsg: self.updateAppt)
                        }else {
                            setMessageLanguageData(&self.expiredate, key: "Appointment date is expired. Please enter correct date")
                            self.displayAlertMsg(userMsg: self.expiredate)
                        }
                    }
                }
            }
        }
    }
    
    //https://qdor.net/api/customer/appointments/88?client_name=hesi&client_phone=09123213480&client_age=40&client_gender=1&description=descr&from_to=2019-09-20 10:00
    
    //https://qdor.net/api/customer/appointments/88?client_name=maldini&client_phone=09123213480&client_age=35&client_gender=1&description=desc%20rhh
    //https://qdor.net/api/customer/appointments/88?client_name=maldini&client_phone=09123213480&client_age=30&client_gender=1&description=desc%20rhh&from_to=2019-09-27 10:00
    //https://qdor.net/api/customer/appointments/88?client_name=maldini&client_phone=09123213480&client_age=30&client_gender=1&description=desc%20rhh&from_to=2019-09-27 10:00
    //https://qdor.net/api/customer/appointments/88?client_name=maldini&client_phone=09123213480&client_age=30&client_gender=1&description=desc%20rhh&from_to=2019-09-27 16:00
    //https://qdor.net/api/customer/appointments/88?client_name=maldini&client_phone=09123213480&client_age=39&client_gender=1&description=desc&from_to=2019-09-20 12:00:00
    //https://qdor.net/api/customer/appointments/88?client_name=maldini&client_phone=09123213480&client_age=30&client_gender=1&description=desc&from_to=2019-09-20%2014:00
    //https://qdor.net/api/customer/appointments/88?client_name=maldini&client_phone=09123213480&client_age=30&client_gender=1&description=desc&from_to=2019-09-20%2013:00
    
    
    //https://qdor.net/api/customer/appointments/88?client_name=hesih&client_phone=09123213480&client_age=34&client_gender=1&description=desc%20rhh%20hbh&from_to=2019-09-27 19:30
    
    
    
    
// ************************************ Picker *************************************
    func createDatePicker() {
        datePicker.datePickerMode = .date
        dateText.inputView = datePicker
        dateText.inputAccessoryView = datePickerToolBar
    }
    func createDatePickerToolBar(){
        datePickerToolBar.sizeToFit()
        setMessageLanguageData(&done, key: "Done")
        let doneButton = UIBarButtonItem(title: done, style: .plain, target: self, action: #selector(setDate))
        datePickerToolBar.setItems([doneButton], animated: false)
        datePickerToolBar.isUserInteractionEnabled = true
        datePickerToolBar.backgroundColor = .lightGray
        datePickerToolBar.tintColor = greenColor
    }
    @objc func setDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateText.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    func createTimePicker(){
        timePicker.datePickerMode = .time
        timePicker.minuteInterval = 30
        timePicker.locale = Locale(identifier: "en_GB")
        timeText.inputView = timePicker
        timeText.inputAccessoryView = timePickerToolBar
    }
    func createTimePickerToolBar(){
        timePickerToolBar.sizeToFit()
        setMessageLanguageData(&done, key: "Done")
        let doneButton = UIBarButtonItem(title: done, style: .plain, target: self, action: #selector(setTime))
        timePickerToolBar.setItems([doneButton], animated: false)
        timePickerToolBar.isUserInteractionEnabled = true
        timePickerToolBar.backgroundColor = .lightGray
        timePickerToolBar.tintColor = greenColor
    }
    @objc func setTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        timeText.text = dateFormatter.string(from: timePicker.date)
        view.endEditing(true)
    }
    
    func createGenderPicker(){
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.backgroundColor = gray
        genderText.inputView = genderPicker
        genderText.inputAccessoryView = genderToolBar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
// -------------------------------------------------------------------
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArr.count
    }
    
// --------------------------------------------------------------------
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArr[row]
    }
    
// --------------------------------------------------------------------
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if resourceKey == "en" {
            if genderArr[row] == "Male" {
                clientGender = 1
                genderText.text = "Male"
            }else{
                clientGender = 0
                genderText.text = "Female"
            }
        }
        if resourceKey == "ar" {
            if genderArr[row] == "ذكر" {
                clientGender = 1
                genderText.text = "ذكر"
            }else{
                clientGender = 0
                genderText.text = "أنثى"
            }
        }
        if resourceKey == "ckb" {
            if genderArr[row] == "نێر" {
                clientGender = 1
                genderText.text = "نێر"
            }else{
                clientGender = 0
                genderText.text = "مێ"
            }
        }
    
    }
    
//********************************* ToolBar PickerView **************************
    
    func createGenderToolBar(){
        setMessageLanguageData(&done, key: "Done")
        genderToolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: done, style: .plain, target: self, action: #selector(dismissKeyboard))
        genderToolBar.setItems([doneButton], animated: false)
        genderToolBar.isUserInteractionEnabled = true
        genderToolBar.backgroundColor = .lightGray
        genderToolBar.tintColor = greenColor
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var lable: UILabel
        if let view = view as? UILabel{
            lable = view
        }else {
            lable = UILabel()
        }
        
        lable.textColor     = .black
        lable.textAlignment = .center
        lable.font = UIFont(name: "Helvetica Neue", size: 15.0)
        
        if pickerView == genderPicker {
            lable.text = genderArr[row]
        }
        return lable
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
// ********************** hide keyboard *****************************
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.scrollView.endEditing(true)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == clentNameText {
            clentNameText.resignFirstResponder()
        }
        if textField == phonNumberText {
            phonNumberText.resignFirstResponder()
        }
        if textField == descriptionText {
            descriptionText.resignFirstResponder()
        }
        
        return true
    }
    
// ---------------------------- display alert ---------------------------
    func displayAlertMsg(userMsg: String){
        setMessageLanguageData(&msgAlert, key: "Warrning")
        setMessageLanguageData(&msgOk, key: "Ok")
        
        let myAlert = UIAlertController(title: msgAlert ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: msgOk,style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil);
    }
    
    func displaySuccessMsg(userMsg: String){
        
        
        setMessageLanguageData(&successfullyDone, key: "Successfully Done")
        setMessageLanguageData(&msgOk, key: "Ok")
        
        
        let myAlert = UIAlertController(title: successfullyDone ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
        let okAction = (UIAlertAction(title: msgOk, style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil);
    }
}

