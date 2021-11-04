////
////  LoginFBVC.swift
////  Umaass
////
////  Created by Hesam on 6/31/1398 AP.
////  Copyright © 1398 Hesam. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import SwiftyJSON
//import Firebase
//
//
//class LoginFBVC: UIViewController {
//
//    @IBOutlet weak var topView          : UIView!
//    @IBOutlet weak var numberView       : UIView!
//    @IBOutlet weak var image            : UIImageView!
//    @IBOutlet weak var numberText       : UITextField!
//    @IBOutlet weak var loginBtn         : UIButton!
//
//    var isLoginVC : Bool = false
//    var accountKit: AccountKitManager = AccountKitManager(responseType: .accessToken)
//
//    var notRegisterUser = String()
//    var InvalidData = String()
//    var notRegister = String()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        cornerImage(image: image, cornerValue: 12.0, maskToBounds: true)
//        UIView.appearance().semanticContentAttribute = .forceLeftToRight
//        numberView.layer.cornerRadius = numberView.frame.height / 2
//        numberView.layer.masksToBounds = false
//        numberView.layer.shadowOpacity = 0.5
//        numberView.layer.shadowRadius = 4.0
//        numberView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//        numberView.layer.shadowColor = UIColor(red: 120/255 , green: 120/255, blue: 120/255, alpha: 1.0).cgColor
//
//        loginBtn.layer.cornerRadius = loginBtn.frame.height / 2
//        loginBtn.layer.masksToBounds = false
//        loginBtn.layer.shadowColor = UIColor.black.cgColor
//        loginBtn.layer.shadowRadius = 2.0
//        loginBtn.layer.shadowOpacity = 0.8
//        loginBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//        loginBtn.layer.shadowColor = UIColor(red: 120/255 , green: 120/255, blue: 120/255, alpha: 1.0).cgColor
//
//        numberText.keyboardType = .asciiCapableNumberPad
//    }
//
//    // ---- AKFViewControllerDelegate -----
//    func viewController(_ viewController: UIViewController & AKFViewController, didCompleteLoginWith accessToken: AKFAccessToken, state: String) {
//        loading()
//        print("accessToken",accessToken.tokenString)
//        // --- number ----
//        accountKit.requestAccount { (account, error) in
//            if(error != nil){
//                //error while fetching information
//            }else if let phoneNum = account?.phoneNumber{
//                print("Phone Number\(phoneNum.stringRepresentation())")
//            }
//        }
//
//        facebookToken = accessToken.tokenString
//        print(facebookToken)
//        login(token: facebookToken)
//    }
//
//
//    func login(token: String){
//        let loginUrl = baseUrl + "login?access_token=" + token
//        print(loginUrl)
//        Alamofire.request(loginUrl, method: .post).responseJSON { response in
//            self.dismissLoding()
//            if let value: AnyObject = response.result.value as AnyObject? {
//                let post = JSON(value)
//                print(post)
//                let status = response.response?.statusCode
//                print(status)
//                if status == 201 || status == 200 {
//                    let resData = post["data"].dictionaryObject
//                    let tokenStr = resData?["token"] as? String
//                    print(tokenStr ?? "")
//                    accessToken = tokenStr ?? ""
//                    saveToken(token: tokenStr ?? "")
//                    let myTabBar = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as! UITabBarController
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.window?.rootViewController = myTabBar
//                }
//
//                if status == 412 {
//                    setMessageLanguageData(&self.notRegisterUser, key: "The user has not register yet")
//                    self.displayNotExsistMsg(userMsg: self.notRegisterUser)
//                }
//                if status == 422 {
//                    setMessageLanguageData(&self.InvalidData, key: "Invalid data")
//                    self.displayAlertMsg(userMsg: self.InvalidData)
//                }
//            }
//        }
//    }
//
//
//// ******************************** Alert Message ********************************
//    func displayAlertMsg(userMsg: String){
//        setMessageLanguageData(&msgAlert, key: "Warrning")
//        setMessageLanguageData(&msgOk, key: "Ok")
//
//        let myAlert = UIAlertController(title: msgAlert ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
//        let okAction = UIAlertAction(title: msgOk,style: UIAlertAction.Style.default, handler: nil)
//        myAlert.addAction(okAction)
//        self.present(myAlert, animated:true, completion:nil);
//    }
//
//    func displayNotExsistMsg(userMsg: String){
//        setMessageLanguageData(&msgAlert, key: "Warrning")
//        setMessageLanguageData(&msgOk, key: "Ok")
//        setMessageLanguageData(&self.notRegister, key: "Not registered")
//
//        let myAlert = UIAlertController(title: self.notRegister ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
//        let okAction = (UIAlertAction(title: msgOk, style: .default, handler: { action in
//            let destVC:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registrationUser") as! RegistrationVC
//            self.present(destVC, animated: false, completion: nil)
//        }))
//        myAlert.addAction(okAction)
//        self.present(myAlert, animated:true, completion:nil);
//    }
//
//
//
//    @IBAction func loginTapped(_ sender: Any) {
//    setMessageLanguageData(&enterYourNumber, key: "Please Enter Your Number")
//    numberText.resignFirstResponder()
//        Analytics.logEvent("loginWithFacebook", parameters: nil)
//
//        if (numberText.text == "") || (numberText.text!.isEmpty) {
//            displayAlertMsg(userMsg: enterYourNumber)
//        }else{
//            let number = numberText.text ?? ""
////            if number == "905389349591" {
////                loginWithNumber(number: "905389349591")
//            if number == "9647731357575" {
//                loginWithNumber(number: "9647731357575")
//            }else{
//                let inputState = UUID().uuidString
//                let vc = (accountKit.viewControllerForPhoneLogin(with: .init(countryCode: "+946", phoneNumber: number
//                    ), state: inputState))
//                vc.isSendToFacebookEnabled = true
//                vc.delegate = self
//                self.present(vc as UIViewController, animated: true, completion: nil)
//            }
//        }
//    }
//
//
//
//
//    func loginWithNumber(number: String){ //%2B
//        let loginUrl = baseUrl + "login?access_token=abcd&phone=%2B" + number
//        print(loginUrl)
//
//        Alamofire.request(loginUrl, method: .post).responseJSON { response in
//            self.dismissLoding()
//            if let value: AnyObject = response.result.value as AnyObject? {
//                let post = JSON(value)
//                print(post)
//                let status = response.response?.statusCode
//                print(status)
//                if status == 201 || status == 200 {
//                    let resData = post["data"].dictionaryObject
//                    let tokenStr = resData?["token"] as? String
//                    print(tokenStr ?? "")
//                    accessToken = tokenStr ?? ""
//                    saveToken(token: tokenStr ?? "")
//                    let myTabBar = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as! UITabBarController
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.window?.rootViewController = myTabBar
//                }
//
//                if status == 412 {
//                    setMessageLanguageData(&self.notRegisterUser, key: "The user has not register yet")
//                    self.displayNotExsistMsg(userMsg: self.notRegisterUser)
//                }
//                if status == 422 {
//                    setMessageLanguageData(&self.InvalidData, key: "Invalid data")
//                    self.displayAlertMsg(userMsg: self.InvalidData)
//                }
//            }
//        }
//    }
//
//}
//
//
//
var ok = String()
var enterYourNumber = String()
