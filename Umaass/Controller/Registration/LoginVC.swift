//
//  LoginVC.swift
//  QdorUser
//
//  Created by Hesam on 10/8/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseUI
import CountryList

class LoginVC: UIViewController  {
    
    @IBOutlet weak var topView          : UIView!
    @IBOutlet weak var numberView       : UIView!
    @IBOutlet weak var image            : UIImageView!
    @IBOutlet weak var numberText       : UITextField!
    @IBOutlet weak var loginBtn         : UIButton!
    @IBOutlet var btnSelectCode: UIButton!
    @IBOutlet weak var messageLab: UILabel!
    
    //view verifi
    
    
    @IBOutlet var lbPhoneNumber: UILabel!
    @IBOutlet var mainViewVerify: UIView!
    @IBOutlet var btnVeify: UIButton!
    @IBOutlet var otpInputView: OTPInputView!
    
    var countryList = CountryList()
    var codeCountry = ""
    var isLoginVC : Bool = false
    
    var notRegisterUser = String()
    var InvalidData = String()
    var notRegister = String()
    
    fileprivate var authStateDidChangeHandle: AuthStateDidChangeListenerHandle?
    fileprivate(set) var auth: Auth?
    fileprivate(set) var authUI: FUIAuth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        setLabelLanguageData(label: self.messageLab, key: "The application is designed to reduce the waste of time that gets very widespread in our daily lives")
        //
        //        cornerImage(image: image, cornerValue: 12.0, maskToBounds: true)
        //        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        //        numberView.layer.cornerRadius = numberView.frame.height / 2
        //        numberView.layer.masksToBounds = false
        //        numberView.layer.shadowOpacity = 0.5
        //        numberView.layer.shadowRadius = 4.0
        //        numberView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        //        numberView.layer.shadowColor = UIColor(red: 120/255 , green: 120/255, blue: 120/255, alpha: 1.0).cgColor
        
        loginBtn.layer.cornerRadius = 8
        loginBtn.layer.masksToBounds = false
        loginBtn.layer.shadowColor = UIColor.black.cgColor
        loginBtn.layer.shadowRadius = 2.0
        loginBtn.layer.shadowOpacity = 0.8
        loginBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        loginBtn.layer.shadowColor = UIColor(red: 120/255 , green: 120/255, blue: 120/255, alpha: 1.0).cgColor
        
        btnSelectCode.layer.borderColor = UIColor.gray.cgColor
        btnSelectCode.layer.borderWidth = 1
        btnSelectCode.layer.cornerRadius = 5
        btnSelectCode.setTitle("+964", for: .normal)
        numberText.keyboardType = .asciiCapableNumberPad
        
        btnVeify.layer.cornerRadius = 8
        btnVeify.layer.masksToBounds = false
        btnVeify.layer.shadowColor = UIColor.black.cgColor
        btnVeify.layer.shadowRadius = 2.0
        btnVeify.layer.shadowOpacity = 0.8
        btnVeify.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btnVeify.layer.shadowColor = UIColor(red: 120/255 , green: 120/255, blue: 120/255, alpha: 1.0).cgColor
        
        countryList.delegate = self
        otpInputView.delegateOTP = self
        codeCountry = "+964"
        
    
       self.topView.frame = CGRect(x: 0, y: 40, width: view.frame.width-30 , height: view.frame.height-40)

        self.mainViewVerify.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width-30, height: view.frame.height-40)
        
        
    }

 func login(token: String,phonNumber:String){
          
            let newString = phonNumber.replacingOccurrences(of: "+", with: "%2B")
            let loginUrl = baseUrl+"login?access_token=\(token)&phone=\(newString)"
    
            print(loginUrl)
            Alamofire.request(loginUrl, method: .post).responseJSON { response in
                self.dismissLoding()
                if let value: AnyObject = response.result.value as AnyObject? {
                    let post = JSON(value)
                    print(post)
                    let status = response.response?.statusCode
                    if status == 201 || status == 200 {
                        self.getProfile()
                        let resData = post["data"].dictionaryObject
                        let tokenStr = resData?["token"] as? String
                        print(tokenStr ?? "")
                        accessToken = tokenStr ?? ""
                        saveToken(token: tokenStr ?? "")
                        let myTabBar = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as! UITabBarController
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = myTabBar
                    }
                    
                    if status == 412 {
                        setMessageLanguageData(&self.notRegisterUser, key: "The user has not register yet")
                        self.displayNotExsistMsg(userMsg: self.notRegisterUser)
                    }
                    if status == 422 {
                        setMessageLanguageData(&self.InvalidData, key: "Invalid data")
                        self.displayAlertMsg(userMsg: self.InvalidData)
                    }
                }
            }
        }
        
        
    // ******************************** Alert Message ********************************
        func displayAlertMsg(userMsg: String){
            setMessageLanguageData(&msgAlert, key: "Warrning")
            setMessageLanguageData(&msgOk, key: "Ok")
            
            let myAlert = UIAlertController(title: msgAlert ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: msgOk,style: UIAlertAction.Style.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated:true, completion:nil);
        }
        
        func displayNotExsistMsg(userMsg: String){
            setMessageLanguageData(&msgAlert, key: "Warrning")
            setMessageLanguageData(&msgOk, key: "Ok")
            setMessageLanguageData(&self.notRegister, key: "Not registered")
            
            let myAlert = UIAlertController(title: self.notRegister ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
            let okAction = (UIAlertAction(title: msgOk, style: .default, handler: { action in
                let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registrationUser") as! RegistrationVC
                destVC.phoneNumber = self.lbPhoneNumber.text ?? ""
                
                self.present(destVC, animated: false, completion: nil)
            }))
            myAlert.addAction(okAction)
            self.present(myAlert, animated:true, completion:nil);
        }
    
    @IBAction func btnActionVerify(_ sender: Any) {
        
       otpInputView.otpFetch()
        
    }
    @IBAction func btnActionRusem(_ sender: Any) {
      
        self.topView.frame = CGRect(x: 0, y: 40, width: view.frame.width-30 , height: view.frame.height-40)
            
            self.mainViewVerify.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width-30, height: view.frame.height-40)
    }
    
    
    @IBAction func btnActionSelectCode(_ sender: Any) {
        
        let navController = UINavigationController(rootViewController: countryList)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
    /*  setMessageLanguageData(&enterYourNumber, key: "Please Enter Your Number")
            numberText.resignFirstResponder()
                Analytics.logEvent("loginWithFacebook", parameters: nil)
                
                if (numberText.text == "") || (numberText.text!.isEmpty) {
                    displayAlertMsg(userMsg: enterYourNumber)
                }else{
                    let number = numberText.text ?? ""

                    if number == "9647731357575" {
                        loginWithNumber(number: "9647731357575")
                    }else{
                       sendPhoneNumber()
                    }
                }*/
        auth = Auth.auth()
                    authUI = FUIAuth.defaultAuthUI()
                    authUI?.delegate = self
                    let phoneProvider = FUIPhoneAuth.init(authUI: authUI!)
                    authUI?.providers = [phoneProvider]
                DispatchQueue.main.async {
                    phoneProvider.signIn(withPresenting: self, phoneNumber: nil);
                }
    }
    
    
      func loginWithNumber(number: String){ //%2B
           let loginUrl = baseUrl + "login?access_token=abcd&phone=%2B" + number
           print(loginUrl)
           
           Alamofire.request(loginUrl, method: .post).responseJSON { response in
               self.dismissLoding()
               if let value: AnyObject = response.result.value as AnyObject? {
                   let post = JSON(value)
                   print(post)
                   let status = response.response?.statusCode
                   if status == 201 || status == 200 {
                       self.getProfile()
                       let resData = post["data"].dictionaryObject
                       let tokenStr = resData?["token"] as? String
                       print(tokenStr ?? "")
                       accessToken = tokenStr ?? ""
                       saveToken(token: tokenStr ?? "")
                       let myTabBar = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as! UITabBarController
                       let appDelegate = UIApplication.shared.delegate as! AppDelegate
                       appDelegate.window?.rootViewController = myTabBar
                   }
                   
                   if status == 412 {
                       setMessageLanguageData(&self.notRegisterUser, key: "The user has not register yet")
                       self.displayNotExsistMsg(userMsg: self.notRegisterUser)
                   }
                   if status == 422 {
                       setMessageLanguageData(&self.InvalidData, key: "Invalid data")
                       self.displayAlertMsg(userMsg: self.InvalidData)
                   }
               }
           }
       }
    
    
    func sendPhoneNumber()  {
        
        self.loading()
        let phonNumber = numberText.text
        if phonNumber?.count ?? 0 < 1 {
            return
        }
        
        let phonnumber = "\(codeCountry)\(phonNumber ?? "")"
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phonnumber, uiDelegate: nil) { (verificationID, error) in
            self.dismissLoding()
            if let error = error {
                self.displayAlertMsg(userMsg: error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            self.lbPhoneNumber.text = phonnumber
            self.topView.frame = CGRect(x: 0, y: CGFloat(self.view.frame.height), width: self.view.frame.width-30, height: self.view.frame.height-40)
                
            self.mainViewVerify.frame = CGRect(x: 0, y: 40, width: self.view.frame.width-30 , height: self.view.frame.height-40)
           
        }
        
        
    }
    
    
    func verifiy(code:String)  {
        
        self.loading()
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else { return }
        
        let credential = PhoneAuthProvider.provider()
            .credential(withVerificationID: verificationID,verificationCode:code )
        Auth.auth().signIn(with: credential) { (authResult, error) in
            
            self.dismissLoding()
            if let error = error {
                self.displayAlertMsg(userMsg:error.localizedDescription)
                return
            }
             UserDefaults.standard.set(nil, forKey: "authVerificationID")
            facebookToken = authResult?.additionalUserInfo?.providerID ?? "defalt"
            self.login(token: authResult?.additionalUserInfo?.providerID ?? "defalt", phonNumber: authResult?.user.phoneNumber ?? "")
            
        }
        
    }
    
    
    // ********************************** Profile **********************************
    func getProfile(){
        let profileUrl = baseUrl + "profile"
        ServiceAPI.shared.fetchGenericData(urlString: profileUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: profileModell?, error:Error?,status:Int?) in
        
            if status == 200 {
                let profile = model?.data
                let genderr = profile?.gender ?? 0
                self.saveProfile(gender:genderr)
                
            }
        }
    }
        
        var deviceId           : String?
        var finalUrl           = String()
        
        func saveProfile(gender:Int) {
            var languge = ""
            let UUIDValue = UIDevice.current.identifierForVendor!.uuidString
            deviceId = "customer-" + UUIDValue
            let baseurll = baseUrl + "profile?&name="
            let firstUrl = "&email="
            let devicetype = "&device_type=ios&device_token=" + deviceTokenn
            let idDevice = "&device_id=" + (deviceId ?? "")
            let gender = "&gender=\(gender)"
            
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



extension LoginVC : CountryListDelegate {
    
    func selectedCountry(country: Country) {
        codeCountry = "+\(country.phoneExtension)"
        btnSelectCode.setTitle("\(codeCountry)", for: .normal)
    }
}

extension LoginVC: OTPViewDelegate {
    
    func didFinishedEnterOTP(otpNumber: String) {
      verifiy(code: otpNumber)
    }
    
    func otpNotValid() {
        
        displayAlertMsg(userMsg: "Code Error")
       // showPopupAlert(title:"OTP Error", message:"")
    }
    
    
    
}
extension LoginVC:FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil {
            return
        }
        self.login(token: authDataResult?.additionalUserInfo?.providerID ?? "defalt", phonNumber: authDataResult?.user.phoneNumber ?? "")
      /*  loginByMobile(mobileNumber: String((authDataResult?.user.phoneNumber)!),
                      password: String((authDataResult?.user.uid)!),
                      token: String((authDataResult?.user.refreshToken)!))
    }*/

}
}

