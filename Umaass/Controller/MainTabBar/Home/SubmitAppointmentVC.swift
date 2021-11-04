//
//  SubmitAppointmentVC.swift
//  Umaass
//
//  Created by Hesam on 7/1/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

import CoreData


class SubmitAppointmentVC: UIViewController {

    
    @IBOutlet weak var bookingPreviewLab: UILabel!
    @IBOutlet weak var providerLab: UILabel!
    @IBOutlet weak var apptDateLab: UILabel!
    @IBOutlet weak var infoLab: UILabel!
    
    @IBOutlet weak var provNameLab: UILabel!
    @IBOutlet weak var expLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var visitDateLab: UILabel!
    @IBOutlet weak var numbLab: UILabel!
    @IBOutlet weak var genderLab: UILabel!
    @IBOutlet weak var descLab: UILabel!
    
    @IBOutlet weak var infoView             : UIView!
    @IBOutlet weak var providerImage        : UIImageView!
    @IBOutlet weak var providerNameLabel    : UILabel!
    @IBOutlet weak var expertiseLabel       : UILabel!
    @IBOutlet weak var apptDateLabel        : UILabel!
    
    @IBOutlet weak var clientNameLabel      : UILabel!
    @IBOutlet weak var clientNumberLabel    : UILabel!
    @IBOutlet weak var clientGenderLabel    : UILabel!
    @IBOutlet weak var clientDescLabel      : UILabel!
    
    @IBOutlet weak var setApptLab: UILabel!
    @IBOutlet weak var userInfoLab: UILabel!
    @IBOutlet weak var submitLab: UILabel!
    @IBOutlet weak var oneStepLabel         : UILabel!
    @IBOutlet weak var twoStepLabel         : UILabel!
    @IBOutlet weak var threeStepLabel       : UILabel!
    @IBOutlet weak var profileImage         : UIImageView!
    @IBOutlet weak var submiteTurnOutletBtn : UIButton!
 
    
    var createApptList   = [String : AnyObject]()
    var submitAppt = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLabelLanguageData(label: nameLab, key: "Name")
        setLabelLanguageData(label: bookingPreviewLab, key: "booking")
        setLabelLanguageData(label: visitDateLab, key: "Date appointment")
        setLabelLanguageData(label: providerLab, key: "provider")
        setLabelLanguageData(label: apptDateLab, key: "Date appointment")
        
        setLabelLanguageData(label: infoLab, key: "User Information")
        setLabelLanguageData(label: provNameLab, key: "Name")
        setLabelLanguageData(label: expLab, key: "industry")
        setLabelLanguageData(label: numbLab, key: "phone")
        setLabelLanguageData(label: genderLab, key: "Gender")
        setLabelLanguageData(label: descLab, key: "description")
        
        
        setLabelLanguageData(label: setApptLab, key: "set date")
        setLabelLanguageData(label: userInfoLab, key: "User Information")
        setLabelLanguageData(label: submitLab, key: "submit appot")
        
        setButtonLanguageData(button: submiteTurnOutletBtn, key: "Continue")
        
        setMessageLanguageData(&submitAppointmentPageTitle, key: "Continue")
        self.navigationItem.title = submitAppointmentPageTitle
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

        
        cornerViews(view: infoView, cornerValue: 6.0, maskToBounds: true)
        cornerLabel(label: oneStepLabel, cornerValue: Float(oneStepLabel.frame.height / 2), maskToBounds: true)
        cornerLabel(label: twoStepLabel, cornerValue: Float(twoStepLabel.frame.height / 2), maskToBounds: true)
        cornerLabel(label: threeStepLabel, cornerValue: Float(threeStepLabel.frame.height / 2), maskToBounds: true)
        cornerButton(button: submiteTurnOutletBtn, cornerValue: 6.0, maskToBounds: true)
        cornerImage(image: profileImage, cornerValue: Float(profileImage.frame.height / 2), maskToBounds: true)
//
//
        print(clientGendertxt)
        print(userGender)
        providerNameLabel.text = (providerName ?? "")
        expertiseLabel.text = (industryName ?? "")
        apptDateLabel.text = (fromTo ?? "")

        clientNameLabel.text =  (clientName ?? "")
        clientNumberLabel.text =  (clientPhone ?? "")
        clientGenderLabel.text = (clientGendertxt ?? userGender)
        clientDescLabel.text = (clientDesc ?? "")

        getImage(urlStr: (providerAvatar ?? ""), img: self.providerImage)
        
    }

    @IBAction func submiteTapped(_ sender: Any) {
        
        loading()
        let makeApptUrl = baseCustomerUrl + "appointments"
        print(makeApptUrl)
        
        let parameters: [String: Any] = [
            "service_id" : serviceId,
            "staff_id" : staffId,
            "client_name" : clientName,
            "client_age" : 0,
            "client_phone" : clientPhone,
            "client_gender" : clientGender,
            "from_to" : fromTo ?? "now",
            "description" : clientDesc ?? "No Description"
        ]
        
        var headers:HTTPHeaders? = nil
        headers = [
            "Authorization": "Bearer \(accessToken)",
            "X-Requested-With": "application/json",
            "Content-type" : "application/json",
            "Accept" : "application/json"
        ]
        
        print(parameters)
        Alamofire.request(makeApptUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print(response)
                self.dismissLoding()
                if (response.result.value) != nil {
                    let swiftyJsonVar = JSON(response.result.value)
                    print("swiftyJsonVar ---------- ",swiftyJsonVar)
                    
                    if let resData = swiftyJsonVar["data"].dictionaryObject {
                        self.createApptList = resData as [String : AnyObject]
                        print(self.createApptList)
                        appointmetID = self.createApptList["id"] as! Int? ?? 1
                        //                        print(appointmetID)
                        setMessageLanguageData(&self.submitAppt, key: "your Appointment Successfully Submitted")
                        self.displaySuccessMsg(userMsg: self.submitAppt)
                    }else{
                        setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                        self.displayAlertMsg(userMsg: someThingWentWrong)
                    }
                }
        }
    }
        
        
//        loading()
//        let makeApptUrl = baseCustomerUrl + "appointments"
//        print(makeApptUrl)
//
//        let model = createAppointment(service_id: serviceId , staff_id: staffId , client_name: clientName , client_phone: clientPhone , client_age: 0 , client_gender: clientGender , from_to: fromTo ?? "now" , description: clientDesc ?? "No Description")
//        print(model)
//
//        do {
//            let url = URL(string: makeApptUrl)!
//            var request = URLRequest(url: url)
//            let jsonEncoder = JSONEncoder()
//            let jsonData = try jsonEncoder.encode(model)
//            jsonEncoder.outputFormatting = .prettyPrinted
//
//            request.httpMethod = HTTPMethod.post.rawValue
//            request.httpBody = jsonData
//
//            URLSession.shared.getAllTasks { (openTasks: [URLSessionTask]) in
//                NSLog("open tasks: \(openTasks)")
//            }
//
//            let task = URLSession.shared.dataTask(with: request, completionHandler: { (responseData: Data?, response: URLResponse?, error: Error?) in
//                NSLog("\(response)")
//            })
//            task.resume()
//        }catch {
//
//        }
    
        
       
        
//        let model = createAppointment(service_id: serviceId , staff_id: staffId , client_name: clientName , client_phone: clientPhone , client_age: 0 , client_gender: clientGender , from_to: fromTo ?? "now" , description: clientDesc ?? "No Description")
//        print(model)
//        do {
//            let jsonEncoder = JSONEncoder()
//            let jsonData = try jsonEncoder.encode(model)
//            jsonEncoder.outputFormatting = .prettyPrinted
//
//            let url = URL(string: makeApptUrl)
//            var request = URLRequest(url: url!)
//            request.httpMethod = HTTPMethod.post.rawValue
//            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//            request.httpBody = jsonData
//
//            request.allHTTPHeaderFields = [
//                "Authorization": "Bearer \(accessToken)",
//                "X-Requested-With": "application/json",
//                "Content-type" : "application/json",
//                "Accept" : "application/json"
//            ]
//            print(jsonData)
//            Alamofire.request(request).responseJSON {
//                (response) in
//                self.dismissLoding()
//                print(response)
//                //                print(response.response?.statusCode)
//                //                let status = response.response?.statusCode
//
//                if (response.result.value) != nil {
//                    let swiftyJsonVar = JSON(response.result.value)
//                    print("swiftyJsonVar ---------- ",swiftyJsonVar)
//
//                    if let resData = swiftyJsonVar["data"].dictionaryObject {
//                        self.createApptList = resData as? [String:AnyObject] ?? [:]
//                        print(self.createApptList)
//                        appointmetID = self.createApptList["id"] as! Int? ?? 1
//                        setMessageLanguageData(&self.submitAppt, key: "your Appointment Successfully Submitted")
//                        self.displaySuccessMsg(userMsg: self.submitAppt)
//                    }else{
//                        setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
//                        self.displayAlertMsg(userMsg: someThingWentWrong)
//                    }
//                }
//            }
//        }catch {
//
//        }
    
    
    func displaySuccessMsg(userMsg: String){
        setMessageLanguageData(&successfullyDone, key: "Successfully Done")
        setMessageLanguageData(&ok, key: "Ok")
        
        let myAlert = UIAlertController(title: successfullyDone ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
        let okAction = (UIAlertAction(title: ok, style: .default, handler: { action in
//            self.saveAcceptRules()
            if let first = self.navigationController?.viewControllers.first {
                self.navigationController?.popToViewController(first, animated: true)
            }
            let index : Int? = 1
            let window = (UIApplication.shared.delegate as? AppDelegate)?.window
            let tabBar :UITabBarController? =  window?.rootViewController as? UITabBarController
            tabBar?.selectedIndex = index!
            
        }))
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil);
    }
    
    func displayAlertMsg(userMsg: String){
        setMessageLanguageData(&msgAlert, key: "Warrning")
        setMessageLanguageData(&msgOk, key: "Ok")
        
        let myAlert = UIAlertController(title: msgAlert ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: msgOk,style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil);
    }
    
// ------------------------------------------------------------------------
//    func saveAcceptRules() {
//        let acceptStatus = NSEntityDescription.insertNewObject(forEntityName: "Industry", into: context)
//        acceptStatus.setValue(acceptTheRules, forKey: "acceptRules")
//        do{
//            try context.save()
//            print("rulesStatus: \(String(describing: acceptTheRules))")
//        }catch{
//
//        }
//    }
}


    

