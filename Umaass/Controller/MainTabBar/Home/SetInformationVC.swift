//
//  SetInformationVC.swift
//  Umaass
//
//  Created by Hesam on 7/1/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import CoreData

class SetInformationVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var phoneLab: UILabel!
    @IBOutlet weak var descLab: UILabel!
    @IBOutlet weak var genderLab: UILabel!
    @IBOutlet weak var bookMySelfLab: UILabel!
    
    
    @IBOutlet weak var mainView                 : UIView!
    @IBOutlet weak var oneStepLabel             : UILabel!
    @IBOutlet weak var twoStepLabel             : UILabel!
    @IBOutlet weak var threeStepLabel           : UILabel!
    @IBOutlet weak var setApptLab: UILabel!
    @IBOutlet weak var userInfoLab: UILabel!
    @IBOutlet weak var submitLab: UILabel!
    
    @IBOutlet weak var nameText                 : UITextField!
    @IBOutlet weak var phoneText                : UITextField!
    @IBOutlet weak var descriptionText          : UITextView!
    @IBOutlet weak var genderText               : UITextField!
//    @IBOutlet weak var acceptRullsBtn           : UIButton!
    @IBOutlet weak var continueOutletBtn        : UIButton!
    @IBOutlet weak var mySelfBtnOtlet           : UIButton!
//    @IBOutlet weak var acceptRulesLabel         : UILabel!
//    @IBOutlet weak var rulesBtnOutlet           : UIButton!
    
    

    
    
    var genderPicker          = UIPickerView()
    var genderToolBar         = UIToolbar()
    
    var isMyself              : Bool = false
    var isCheked              : Bool = false
    var genderArr             = [String]()
    var addressString  : String?
    var valueType      = String()
    
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
        
        
        
//        acceptRullsBtn.isHidden = true
//        rulesBtnOutlet.isHidden = true
//        acceptRulesLabel.isHidden = true
    
//        fetchAcceptRules()
        
        setLabelLanguageData(label: nameLab, key: "Name")
        setLabelLanguageData(label: phoneLab, key: "phone")
        setLabelLanguageData(label: descLab, key: "description")
        setLabelLanguageData(label: genderLab, key: "Gender")
        setLabelLanguageData(label: bookMySelfLab, key: "For me")
//        setLabelLanguageData(label: acceptLab, key: "")
//        setButtonLanguageData(button: rulesBtnOutlet, key: "Rules")
        
        setTextHintLanguageData(text: nameText, key: "Enter your name")
        setTextHintLanguageData(text: phoneText, key: "Enter your phone")
        setTextHintLanguageData(text: genderText, key: "Select client gender")
        
        setLabelLanguageData(label: setApptLab, key: "set date")
        setLabelLanguageData(label: userInfoLab, key: "User Information")
        setLabelLanguageData(label: submitLab, key: "submit appot")
        setButtonLanguageData(button: continueOutletBtn, key: "Continue")
        
        setMessageLanguageData(&userInformationPageTitle, key: "User Information")
        self.navigationItem.title = userInformationPageTitle
        // ------------- banner view --------------
  
       
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

        
        cornerLabel(label: oneStepLabel, cornerValue: Float(oneStepLabel.frame.height / 2), maskToBounds: true)
        cornerLabel(label: twoStepLabel, cornerValue: Float(twoStepLabel.frame.height / 2), maskToBounds: true)
        cornerLabel(label: threeStepLabel, cornerValue: Float(threeStepLabel.frame.height / 2), maskToBounds: true)
        cornerButton(button: continueOutletBtn, cornerValue: 6.0, maskToBounds: true)
        cornerButton(button: mySelfBtnOtlet, cornerValue: 6.0, maskToBounds: true)
//        cornerButton(button: acceptRullsBtn, cornerValue: 3.0, maskToBounds: true)
        descriptionText.layer.cornerRadius = 6.0

        
        createGenderPicker()
        createGenderToolBar()
        
        selectMySelf()
    }
    
    
    //----------------------------- images -----------------------------
    let checkedImage  = UIImage(named : "checkOn.png")!
    let unChekedImage = UIImage(named : "checkOff.png")!
//    @IBAction func checkBoxTapped(_ sender: Any) {
//        if isCheked == false {
//            isCheked = true
//            acceptTheRules = "accepted"
//            print("isCheked",isCheked)
//            acceptRullsBtn.setImage(checkedImage,  for: .normal)
//            continueOutletBtn.backgroundColor = greenColor
//            continueOutletBtn.isEnabled = true
//        }else{
//            isCheked = false
//            print("isCheked",isCheked)
//            acceptTheRules = ""
//            acceptRullsBtn.setImage(unChekedImage, for: .normal)
//            continueOutletBtn.backgroundColor = .lightGray
//            continueOutletBtn.isEnabled = false
//        }
//    }
    
    @IBAction func bookForMyselfTapped(_ sender: Any) {
         selectMySelf()
    }
    
    func selectMySelf(){
        if isMyself == false {
              isMyself = true
              print("isMyself",isMyself)
              mySelfBtnOtlet.setImage(checkedImage,  for: .normal)
              nameText.text = userName
              if userGender == "Male" {
                  setMessageLanguageData(&userGender, key: "male")
              }else{
                  setMessageLanguageData(&userGender, key: "female")
              }
              genderText.text = userGender
              nameText.backgroundColor = offTextColor
              genderText.backgroundColor = offTextColor
              phoneText.text = userNumberRegist
              phoneText.backgroundColor = offTextColor
          }else{
              isMyself = false
              print("isMyself",isMyself)
              mySelfBtnOtlet.setImage(unChekedImage, for: .normal)
              nameText.text = ""
              nameText.backgroundColor = .white
              
              genderText.text = ""
              genderText.backgroundColor = .white
              phoneText.text = ""
              phoneText.backgroundColor = .white
          }
    }
    
    
    @IBAction func continueTapped(_ sender: Any) {
    
        setMessageLanguageData(&enterYourName, key: "Enter your name")
        setMessageLanguageData(&enterYourNumber, key: "Enter your phonNumber")
        setMessageLanguageData(&selectYourGender, key: "Select your Gender")
        
        if (nameText.text == "") || ((nameText.text?.isEmpty)!) || (phoneText.text == "") || ((phoneText.text?.isEmpty)!) || (genderText.text == "")  || ((genderText.text?.isEmpty)!) {
            if (nameText.text == "") || ((nameText.text?.isEmpty)!) {
                displayAlertMsg(userMsg: enterYourName)
            }
            if (phoneText.text == "") || ((phoneText.text?.isEmpty)!) {
                displayAlertMsg(userMsg: enterYourNumber)
            }
            
            if (genderText.text == "") || ((genderText.text?.isEmpty)!) {
                displayAlertMsg(userMsg: selectYourGender)
            }
        }else{
            clientName = nameText.text ?? "name"
            clientPhone = phoneText.text ?? "number"
            clientGender = Int(genderText.text ?? "1") ?? 1
            clientDesc = (descriptionText.text ?? "No Description")
            performSegue(withIdentifier: "toSubmit", sender: self)
        }
    }
    
    
    @IBAction func rulesTapped(_ sender: Any) {
        loading()
        
        var versionUrl = String()
        if resourceKey == "ckb" {
            versionUrl = "http://umaass.com/api/page/rules?lang=ku"
        }else{
            versionUrl = "http://umaass.com/api/page/rules?lang=" + resourceKey
        }
//        print(versionUrl)
        valueType = "Rules"
        ServiceAPI.shared.fetchGenericData(urlString: versionUrl, parameters: emptyParam, methodInput: .get) { (model: rulseAboutModel?, error, status) in
            self.dismissLoding()
            if status == 200 {
                self.addressString = model?.rulesdata
                print(self.addressString ?? "")
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "about") as? AboutVC {
                    vc.passedValueType = self.valueType
                    vc.passedtext = self.addressString
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }else{
                setMessageLanguageData(&noData, key: "There is no data")
                self.displayAlertMsg(userMsg: noData)
            }
        }
    }
    
    // ************************************ Picker *************************************
    
    func createGenderPicker(){
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.backgroundColor = .lightGray
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
        genderToolBar.backgroundColor = gray
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
//        lable.font = UIFont(name: "Helvetica Neue", size: 15.0)
        
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
        self.mainView.endEditing(true)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameText {
            nameText.resignFirstResponder()
        }
        if textField == phoneText {
            phoneText.resignFirstResponder()
        }
        if textField == descriptionText {
            descriptionText.resignFirstResponder()
        }
        
        return true
    }
    
    
    
// ------------------------------------------------------------------
    func displayAlertMsg(userMsg: String){
        setMessageLanguageData(&msgAlert, key: "Warrning")
        setMessageLanguageData(&msgOk, key: "Ok")
        
        let myAlert = UIAlertController(title: msgAlert ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: msgOk,style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil);
    }
    
// ------------------------ fetch status --------------------------
//    func fetchAcceptRules(){
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Industry")
//        request.returnsObjectsAsFaults = false
//        do{
//            let results = try context.fetch(request)
//            print(results.count)
//            if (results.count) > 0 {
//                for result in results as! [NSManagedObject] {
//                    if let accept = result.value(forKey: "acceptRules") as? String {
//                        acceptTheRules = accept
//                        print("accept: \(String(describing: acceptTheRules))")
//
//                        if acceptTheRules == "accepted" || acceptTheRules == "" {
//                            acceptRullsBtn.isHidden = true
//                            rulesBtnOutlet.isHidden = true
//                            acceptRulesLabel.isHidden = true
//                            self.continueOutletBtn.backgroundColor = greenColor
//                            self.continueOutletBtn.isEnabled = true
//                        }else{
//
//                        }
//                    }
//                }
//            }else{
//                acceptRullsBtn.isHidden = false
//                rulesBtnOutlet.isHidden = false
//                acceptRulesLabel.isHidden = false
//                self.continueOutletBtn.backgroundColor = .lightGray
//                self.continueOutletBtn.isEnabled = false
//            }
//        }catch{
//            //
//        }
//    }
    
    
}


var noData = String()
