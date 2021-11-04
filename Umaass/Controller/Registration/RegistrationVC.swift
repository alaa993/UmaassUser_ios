//
//  RegistrationVC.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import Alamofire
import Firebase



class RegistrationVC: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var registerScrollView : UIScrollView!
    @IBOutlet weak var nameText           : UITextField!
    @IBOutlet weak var emailText          : UITextField!
    @IBOutlet weak var registerOutletBtn  : UIButton!
    @IBOutlet weak var genderText         : UITextField!
    
    @IBOutlet weak var RegistrationLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var emailLab: UILabel!
    @IBOutlet weak var genderLab: UILabel!
    @IBOutlet weak var registrationMesageLab: UILabel!
    
    
    
    var genderPicker          = UIPickerView()
    var genderToolBar         = UIToolbar()
    
//    var datePicker            = UIDatePicker()
//    var datePickerToolBar     = UIToolbar()
    
    var errorList             = [String:AnyObject]()
    var errorMessage          : [String]?
    
    var genderArr             = [String]()
    
    var strDate               = String()
    var selectedDate          = String()
    
    var registSuccesssful = String()
    var emailAlreadyTaken = String()
    var phoneAlreadyTaken = String()
    public var phoneNumber = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        
        setLabelLanguageData(label: RegistrationLab, key: "Register")
        setLabelLanguageData(label: registrationMesageLab, key: "")
        setLabelLanguageData(label: nameLab, key: "Full Name")
        setLabelLanguageData(label: emailLab, key: "Email")
        setLabelLanguageData(label: genderLab, key: "Gender")
        
        setTextHintLanguageData(text: nameText, key: "Full Name")
        setTextHintLanguageData(text: emailText, key: "Email")
        setTextHintLanguageData(text: genderText, key: "Gender")
        
        setButtonLanguageData(button: registerOutletBtn, key: "Register")
        
        createGenderPicker()
        createGenderToolBar()
//        createDatePicker()
//        createDatePickerToolBar()
        
        cornerButton(button: registerOutletBtn, cornerValue: 6.0, maskToBounds: true)
        registerOutletBtn.backgroundColor = greenColor
        let touch = UITapGestureRecognizer(target: self, action: #selector(singleTapGestureCaptured))
        registerScrollView.addGestureRecognizer(touch)
    }

    @objc func singleTapGestureCaptured(gesture: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    
    @IBAction func registerTapped(_ sender: Any) {
        setMessageLanguageData(&enterYourName, key: "Enter your name")
        setMessageLanguageData(&selectYourGender, key: "Select your Gender")
        
        
        if (nameText.text == "") || ((nameText.text?.isEmpty)!) || (genderText.text == "") || ((genderText.text?.isEmpty)!) {
            
            if (nameText.text == "") || ((nameText.text?.isEmpty)!) {
                displayAlertMsg(userMsg: enterYourName)
            }
//            if (emailText.text == "") || ((emailText.text?.isEmpty)!) {
//                displayAlertMsg(userMsg: "Enter your email")
//            }
//            if (birthdateText.text == "") || ((birthdateText.text?.isEmpty)!) {
//                displayAlertMsg(userMsg: "Enter your BirthDay Date")
//            }
            if (genderText.text == "") || ((genderText.text?.isEmpty)!) {
                displayAlertMsg(userMsg: selectYourGender)
            }
        }else{
            userName = nameText.text ?? ""
            Analytics.logEvent("Regestration", parameters: nil)
            loading()
            let registerUrl = baseUrl + "register"
            let param: Parameters = [
                "name"                : nameText.text ?? "",
                "access_token"        : facebookToken,
                "email"               : emailText.text ?? "",
                "birthdate"           : "2000-03-10",
                "gender"              : clientGender ?? 1,
                "phone"                :phoneNumber
            ]
            print(param)
            print(registerUrl)
            
            ServiceAPI.shared.fetchGenericData(urlString: "https://umaass.com/api/register", parameters: param, methodInput: .post, isHeaders: false){ (model: RegistrationModel?, error:Error?,status:Int?) in
                
                self.dismissLoding()
                //                print(status)
                if status == 200 {
                    accessToken = model?.data?.token ?? ""
                    print(accessToken)
                    setMessageLanguageData(&msgLoginSuccefull, key: "registration Successful")
                    self.displaySuccessMsg(userMsg: msgLoginSuccefull)
                }else if status == 422 {
                    self.errorList = swiftyJsonVar["errors"].dictionaryObject! as [String : AnyObject]
                    print(self.errorList)
                    
                    if self.errorList["email"] as? [String] != nil {
                        self.errorMessage = self.errorList["email"] as? [String]
                        print(self.errorMessage ?? "")
                        setMessageLanguageData(&self.emailAlreadyTaken, key: "The email has already been taken")
                        self.displayAlertMsg(userMsg: self.errorMessage?[0] ?? self.emailAlreadyTaken)
                    }
                    
                    if self.errorList["phone"] as? [String] != nil {
                        self.errorMessage = self.errorList["phone"] as? [String]
                        print(self.errorMessage ?? "")
                        setMessageLanguageData(&self.phoneAlreadyTaken, key: "The phone has already been taken")
                        self.displayAlertMsg(userMsg: self.errorMessage?[0] ?? self.phoneAlreadyTaken)
                    }
                }else if status == 500 {
                    print("500")
                }else{
                    setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                    self.displayAlertMsg(userMsg: someThingWentWrong)
                }
            }
        }
    }
    
    
// ************************************ Picker *************************************
//    func createDatePicker(){
//        datePicker.datePickerMode = .date
//        birthdateText.inputView = datePicker
//        birthdateText.inputAccessoryView = datePickerToolBar
//    }
//    func createDatePickerToolBar(){
//        datePickerToolBar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(setDate))
//        datePickerToolBar.setItems([doneButton], animated: false)
//        datePickerToolBar.isUserInteractionEnabled = true
//        datePickerToolBar.backgroundColor = .lightGray
//        datePickerToolBar.tintColor = greenColor
//    }
//    @objc func setDate() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        birthdateText.text = dateFormatter.string(from: datePicker.date)
//        view.endEditing(true)
//    }
    
    
    
    func createGenderPicker(){
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.backgroundColor = gray
        genderText.inputView = genderPicker
        genderText.inputAccessoryView = genderToolBar
       // genderPicker.selectedRow(inComponent: 1)
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
                clientGendertxt = "Male"
            }else{
                clientGender = 0
                clientGendertxt = "Female"
                genderText.text = "Female"
            }
        }
        if resourceKey == "ar" {
            if genderArr[row] == "ذكر" {
                clientGender = 1
                genderText.text = "ذكر"
                clientGendertxt = "ذكر"
            }else{
                clientGender = 0
                clientGendertxt = "أنثى"
                genderText.text = "أنثى"
            }
        }
        if resourceKey == "ckb" {
            if genderArr[row] == "نێر" {
                clientGender = 1
                genderText.text = "نێر"
                clientGendertxt = "نێر"
            }else{
                clientGender = 0
                clientGendertxt = "مێ"
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
    
    
//***************************** Hide KeyBoard ***********************************
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.registerScrollView.endEditing(true)
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            registerScrollView.setContentOffset(CGPoint(x: 0, y: 20), animated: true)
        default:
            registerScrollView.setContentOffset(CGPoint(x: 0, y: 80), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        registerScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameText {
            nameText.resignFirstResponder()
        }
        if textField == emailText {
            emailText.resignFirstResponder()
        }
        return true
    }
    
    
    // ---------------------------- text field delegate -----------------------------------
    
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
        setMessageLanguageData(&ok, key: "Ok")
        
        let myAlert = UIAlertController(title: successfullyDone ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
        let okAction = (UIAlertAction(title: ok, style: .default, handler: { action in
            saveToken(token: accessToken)
            self.saveProfile()
            self.performSegue(withIdentifier: "toCategory", sender: self)
//            let myTabBar = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as! UITabBarController
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = myTabBar
        }))
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil);
    }
    
    var deviceId           : String?
     var finalUrl           = String()
     
     func saveProfile() {
         var languge = ""
         let UUIDValue = UIDevice.current.identifierForVendor!.uuidString
           deviceId = "customer-" + UUIDValue
            let baseurll = baseUrl + "profile?&name="
            let firstUrl = "&email="
            let devicetype = "&device_type=ios&device_token=" + deviceTokenn
            let idDevice = "&device_id=" + (deviceId ?? "")
            let gender = "&gender=\(clientGender ?? 1)"
         
         switch resourceKey {
            case "en":
                languge = "&language=EN"
            case "ar":
                languge = "&language=AR"
            case "ckb":
                languge = "&language=KU"
            case "tr":
                languge = "&language=TR"
            default:
                languge = "&language=EN"
            }
            
            let finalUr = baseurll + firstUrl + devicetype + idDevice + languge + gender
            
            if finalUr.contains(" ")  {
                finalUrl = finalUr.replacingOccurrences(of: " ", with: "%20")
            }else{
                finalUrl = finalUr
            }
            
            print(finalUrl)
            print(accessToken)
            let headers:HTTPHeaders = [
                "Authorization": "Bearer \(accessToken)",
                "X-Requested-With": "application/json",
                "Content-type" : "application/json",
                "Accept" : "application/json"]
            
            Alamofire.request(finalUrl, method: .put, headers: headers).responseJSON { response in
         
            }
        }
    
}


var selectYourGender = String()
var enterYourName = String()
var someThingWentWrong = String()
var unacouticated = String()
var wrongAccess = String()
var favoritedd = String()
var unfavoritedd = String()
var successUploded = String()
var yourimageSize = String()
var cancell = String()
var chooseImage = String()
var photoSource = String()
var photoLibrary = String()

var done = String()

var male = String()
var female = String()
