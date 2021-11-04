//
//  ContactUsVC.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import MessageUI


class ContactUsVC: UIViewController , MFMailComposeViewControllerDelegate {

    

    
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    
    @IBOutlet weak var whatsAppLab: UILabel!
    @IBOutlet weak var emailLab: UILabel!
    @IBOutlet weak var addreessLab: UILabel!
    @IBOutlet weak var explainLab: UILabel!
    @IBOutlet weak var addressLab: UILabel!
    
    
    var appVersion     = Int()
    var addressString  : String?
    var valueType      = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabelLanguageData(label: explainLab, key: "The application is designed to reduce the waste of time that gets very widespread in our daily lives")
        setLabelLanguageData(label: whatsAppLab, key: "whatsapp")
        setLabelLanguageData(label: emailLab, key: "Email")
        setLabelLanguageData(label: addreessLab, key: "Address")
        setLabelLanguageData(label: addressLab, key: "umaassAddress")
//        setLabelLanguageData(label: versionLable, key: "Version")
        
        setButtonLanguageData(button: emailBtn, key: "Send")
        setButtonLanguageData(button: callBtn, key: "Call now")
        
//        getAppVersion()
        
        setMessageLanguageData(&contactusPageTitle, key: "Contact us")
        self.navigationItem.title = contactusPageTitle
        
        

        
        cornerButton(button: callBtn, cornerValue: Float(callBtn.frame.height / 2), maskToBounds: true)
        cornerButton(button: emailBtn, cornerValue: Float(emailBtn.frame.height / 2), maskToBounds: true)
        
        
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
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
    }
    
//    func getAppVersion(){
//        loading()
//        let versionUrl = baseUrl + "version/ios"
//        ServiceAPI.shared.fetchGenericData(urlString: versionUrl, parameters: emptyParam, methodInput: .get) { (model: aboutUsModel?, error, status) in
//            self.dismissLoding()
//            if status == 200 {
//                self.appVersion = model?.data?.version ?? 1
//                self.versionLable.text = "Version  " + "\(self.appVersion)"
//            }else{
//
//            }
//        }
//    }
    
    @IBAction func messageToWhatsappTapped(_ sender: Any) {
        let url:NSURL = URL(string: ("https://api.whatsapp.com/send?phone=447732830221"))! as NSURL
        UIApplication.shared.open(url as URL)
    }
    
    @IBAction func sendEmailTapped(_ sender: Any) {
        let email = "umaass.app@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
//        let mailVC = MFMailComposeViewController()
//        if MFMailComposeViewController.canSendMail() {
//            mailVC.mailComposeDelegate = self
//            mailVC.setSubject("Complain and Suggestions")
//            mailVC.setMessageBody("", isHTML: false)
//            mailVC.setToRecipients(["umaass.app@gmail.com"])
//            present(mailVC, animated: true, completion: nil)
//        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch (result) {
        case .saved:
            print("Message saved")
        case .cancelled:
            print("Message cancelled")
        case .failed:
            print("Message failed")
        case .sent:
            print("Message sent")
        }
        self.dismiss(animated: true, completion: nil)
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

fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
















//    @IBAction func getAboutTapped(_ sender: Any) {
//        loading()
//        let versionUrl = baseUrl + "page/about"
//        valueType = "About App"
//        ServiceAPI.shared.fetchGenericData(urlString: versionUrl, parameters: emptyParam, methodInput: .get) { (model: rulseAboutModel?, error, status) in
//            self.dismissLoding()
//            if status == 200 {
//                self.addressString = model?.rulesdata
//                print(self.addressString ?? "")
//                self.performSegue(withIdentifier: "toWebView", sender: self)
//            }else{
//                self.displayAlertMsg(userMsg: "SomeThing Went Wrong!")
//            }
//        }
//    }
//
//
//    @IBAction func getRulesTapped(_ sender: Any) {
//        loading()
//        let versionUrl = baseUrl + "page/rule"
//        print(versionUrl)
//        valueType = "Rules"
//        ServiceAPI.shared.fetchGenericData(urlString: versionUrl, parameters: emptyParam, methodInput: .get) { (model: rulseAboutModel?, error, status) in
//            self.dismissLoding()
//            print(status)
//            if status == 200 {
//                self.addressString = model?.rulesdata
//                print(self.addressString ?? "")
//                self.performSegue(withIdentifier: "toWebView", sender: self)
//            }else{
//                self.displayAlertMsg(userMsg: "SomeThing Went Wrong!")
//            }
//        }
//    }
