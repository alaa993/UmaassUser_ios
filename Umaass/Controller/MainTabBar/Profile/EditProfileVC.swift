//
//  EditProfileVC.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class EditProfileVC: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var mainView     : UIView!
    @IBOutlet weak var scrollView   : UIScrollView!
    @IBOutlet weak var nameText     : UITextField!
    @IBOutlet weak var emailText    : UITextField!
    @IBOutlet weak var genderText   : UITextField!
 
    
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var emailLab: UILabel!
    @IBOutlet weak var genderLab: UILabel!
    
    
    
    
    var passedName           : String?
    var passedEmail          : String?
    var passedGender         : String?
    var passedDescription    : String?
    var deviceId             : String?
    
    var updateProfile = String()
    
    var genderPicker          = UIPickerView()
    var genderToolBar         = UIToolbar()
    
//    var datePicker          = UIDatePicker()
//    var datePickerToolBar   = UIToolbar()
    
    var genderArr             = [String]()
    var birthdate             = String()
    var selectedDate          = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabelLanguageData(label: nameLab, key: "Full Name")
        setLabelLanguageData(label: emailLab, key: "Email")
        setLabelLanguageData(label: genderLab, key: "Gender")
        
        setTextHintLanguageData(text: nameText, key: "Full Name")
        setTextHintLanguageData(text: emailText, key: "Email")
        setTextHintLanguageData(text: genderText, key: "Gender")
        
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
        
        createGenderPicker()
        createGenderToolBar()
//        createDatePicker()
//        createDatePickerToolBar()
        
//        let button = UIButton.init(type: .custom)
//        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 50)
//        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 50)
//        heightConstraint.isActive = true
//        widthConstraint.isActive = true
//        button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
//        cornerButton(button: button, cornerValue: 4.0, maskToBounds: true)
//        button.setImage(UIImage.init(named: "umaassIcon.png"), for: UIControl.State.normal)
//        let logoImg = UIBarButtonItem.init(customView: button)
//        self.navigationItem.rightBarButtonItem = logoImg

        
        let UUIDValue = UIDevice.current.identifierForVendor!.uuidString
        print("UUID: \(UUIDValue)")
        deviceId = "customer-" + UUIDValue
        
        setMessageLanguageData(&editProfilePageTitle, key: "Edit profile")
        self.navigationItem.title = editProfilePageTitle
        
        cornerViews(view: mainView, cornerValue: 6.0, maskToBounds: true)
        
        setMessageLanguageData(&navigationSave, key: "save")
        let editProfileBarButton = UIBarButtonItem(title: navigationSave, style: .plain, target: self, action: #selector(saveProfile))
        
        self.navigationItem.rightBarButtonItem  = editProfileBarButton
        
        nameText.text = passedName
        emailText.text = passedEmail
//        birthdayText.text = passedBirthdate
        genderText.text = passedGender
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
    }
    
    
// ****************************** save profile *******************************

    var updateProfileUrl = String()
    var finalUrl = String()
    
    @objc func saveProfile() {
        
         var languge = ""
        loading()
        
        var nameTxt = (nameText?.text ?? "")
        if let encodText = nameTxt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            print(encodText)
            nameTxt = encodText
        }
        
        let baseurll = baseUrl + "profile?&name=" + nameTxt
        let firstUrl = "&email=" + (emailText?.text)!
        let birtdayGender = "&birthdate=&gender=" + "\(clientGender ?? 1)"
        let devicetype = "&device_type=ios&device_token=" + deviceTokenn
        let idDevice = "&device_id=" + (deviceId ?? "")
        
        switch resourceKey {
             case "en":
                 languge = "&language=EN"
             case "ar":
                 languge = "&language=AR"
             case "ckb":
                 languge = "&language=KU"
             default:
                 languge = "&language=EN"
             }
        
        let finalUr = baseurll + firstUrl + birtdayGender + devicetype + idDevice + languge
        
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
            "Accept" : "application/json"
        ]
        
        Alamofire.request(finalUrl, method: .put, headers: headers).responseJSON { response in
            self.dismissLoding()
            if let value: AnyObject = response.result.value as AnyObject? {
                let post = JSON(value)
                print(post)
                let status = response.response?.statusCode
                let data = post["data"].dictionary
                let message = data?["message"]?.stringValue
                if status == 200 {
                    setMessageLanguageData(&self.updateProfile, key: "Your profile Successfully Updated")
                    self.displaySuccessMsg(userMsg: self.updateProfile)
                }else {
                    setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                    self.displayAlertMsg(userMsg: someThingWentWrong)
                }
            }
        }
    }
    
    //    @objc func save(){
    //        loading()
    //        let updateProfileUrl = baseUrl + "profile"
    //        let updateProfileParam: Parameters = [
    //            "name"                       : nameText.text ?? "",
    //            "email"                      : emailText.text ?? "",
    //            "device_type"                : "ios",
    //            "device_token"               : deviceToken,
    //            "device_id"                  : deviceId ?? ""
    //        ]
    //
    //        print(updateProfileParam)
    //        print(updateProfileUrl)
    //
    //        ServiceAPI.shared.fetchGenericData(urlString: updateProfileUrl, parameters: updateProfileParam, methodInput: .put, isHeaders: true){ (model: MessageModel?, error:Error?,status:Int?) in
    //            self.dismissLoding()
    //            print(status)
    //            if status == 200 {
    //                let message = model?.data?.message ?? "Your Profile Successfuly Updated!"
    //                self.displaySuccessMsg(userMsg: message)
    //            }else {
    //                let errorMessage = model?.data?.message ?? "SomeThing went wrong!"
    //                self.displayAlertMsg(userMsg: errorMessage)
    //            }
    //        }
    //    }
    
    
    
// ************************************ Picker *************************************
//    func createDatePicker(){
//        datePicker.datePickerMode = .date
//        birthdayText.inputView = datePicker
//        birthdayText.inputAccessoryView = datePickerToolBar
//    }
//    func createDatePickerToolBar(){
//        datePickerToolBar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(setDate))
//        datePickerToolBar.setItems([doneButton], animated: false)
//        datePickerToolBar.isUserInteractionEnabled = true
//        datePickerToolBar.backgroundColor = .lightGray
//        datePickerToolBar.tintColor = greenColor
//    }
//
//    @objc func setDate() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        birthdate = dateFormatter.string(from: datePicker.date)
//        birthdayText.text = birthdate
//        view.endEditing(true)
//    }
    
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
    
//***************************** Hide KeyBoard ***********************************
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.scrollView.endEditing(true)
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0...1:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        case 2:
            scrollView.setContentOffset(CGPoint(x: 0, y: 20), animated: true)
        default:
            print("ok")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameText {
            nameText.resignFirstResponder()
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
        let okAction = (UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil);
    }
}


// Firebase registration token : clFCXcP5Zj8:APA91bGMTC1JfWVNvyxJMdnh90ydLBoCjPHd3j-0_bsJ-NU0Aq7FeMt6fs4cioGMud5ftejVEjxTgqBoFHqZW8zVWS-T-JY7C3scT5UhLYi5GjJ4vArD_WUUp7XDD9Qo1f8yb2aPW1TN

//UUID: 8B73F581-BC11-4527-ABB9-E7EB69989A68

//UUID: 8B73F581-BC11-4527-ABB9-E7EB69989A68

