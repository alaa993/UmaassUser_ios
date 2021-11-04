//
//  RatingVC.swift
//  Umaass
//
//  Created by Hesam on 7/10/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import SwiftyJSON


class RatingVC: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var providerImage: UIImageView!
    @IBOutlet weak var providerNameLbl: UILabel!
    @IBOutlet weak var categoryNameLbl: UILabel!
    
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var ratingLab: UILabel!
    @IBOutlet weak var commentLab: UILabel!
    
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!

    
    var apptsData : showApptData?
    var starRate  : Float?
    //    var apptId    = Int()
    var passedApptRateId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        getApptDetails()
        cornerImage(image: providerImage, cornerValue: Float(providerImage.frame.height / 2), maskToBounds: true)
        cornerButton(button: skipBtn, cornerValue: 6.0, maskToBounds: true)
        cornerButton(button: sendBtn, cornerValue: 6.0, maskToBounds: true)
        commentTextView.layer.cornerRadius = 6.0
        commentTextView.layer.masksToBounds = true
        
        // ----------- rate view
        rateView.settings.textColor = .darkGray
        rateView.settings.textMargin = 12
        updateRating()
        rateView.didTouchCosmos = didTouchCosmos
        rateView.didFinishTouchingCosmos = didFinishTouchingCosmos
        setLabelLanguageData(label: ratingLab, key: "rating")
        setLabelLanguageData(label: commentLab, key: "comments")
        setButtonLanguageData(button: sendBtn, key: "Send")
        setButtonLanguageData(button: skipBtn, key: "Cancel")
    }
    
    // *************************** get Appt details *********************************
    
    func getApptDetails(){
        loading()
        let apptDetailUrl = baseCustomerUrl + "appointments/" + "\(passedApptRateId ?? 0)"
        print(apptDetailUrl)
        ServiceAPI.shared.fetchGenericData(urlString: apptDetailUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: showApptModel?, error:Error?,status:Int?) in
            self.dismissLoding()
            print(status)
            if status == 200 {
                self.apptsData = model?.data
                print(self.apptsData)
                self.providerNameLbl.text = self.apptsData?.staff?.name ?? ""
                self.categoryNameLbl.text = (self.apptsData?.industry?.category?.name ?? "") + " " + (self.apptsData?.service?.title ?? "")
                
                let imageUrl = self.apptsData?.staff?.avatar?.url_sm ?? ""
                getImage(urlStr: imageUrl, img: self.providerImage)
            }else{
                setMessageLanguageData(&apptNotValid, key: "This appointment not valid")
                self.displayAlertMsg(userMsg: apptNotValid)
            }
        }
    }
    
    
    func updateRating(){
        let value = starRate ?? 0.0
        //        print(value)
        //        print(starRate)
        rateView.rating = Double(value)
        rateView.text = "\(value)"
        
    }
    
    func didTouchCosmos(rating: Double){
        rateView.text = "\(rating)"
        starRate = Float(rating)
    }
    
    func didFinishTouchingCosmos(rating: Double){
        rateView.text = "\(rating)"
        starRate = Float(rating)
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        var commectStr = String()
        
        let comment = commentTextView.text ?? ""
        
        if let encodText = comment.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            print(encodText)
            commectStr = encodText
        }
        
        print(commectStr)
        loading()
        let first = "https://umaass.com/api/customer/appointments/" + "\(passedApptRateId ?? 1)" + "/comments?rate=" + "\(starRate ?? 0)"
        if (commectStr.contains(" ")) {
            commectStr = commectStr.replacingOccurrences(of: " ", with: "%20")
        }
        let second = "&content=" + (commectStr )
        let sendRateUrl = first + second
        print(sendRateUrl)
        
        
        ServiceAPI.shared.fetchGenericData(urlString: sendRateUrl, parameters: emptyParam, methodInput: .post, isHeaders: true){ (model: MessageModel?, error:Error?,status:Int?) in
            self.dismissLoding()
            print(model?.data)
            print(status)
            
            if status == 200 {
                setMessageLanguageData(&rateSent, key: "Your Rate Successfully Sent")
                let message = model?.data?.message ?? rateSent
                self.displaySuccessMsg(userMsg: rateSent)
            }else {
                setMessageLanguageData(&apptNotValid, key: "This appointment not valid")
                let errorMessage = model?.data?.message ?? apptNotValid
                self.displayAlertMsg(userMsg: errorMessage)
            }
        }
    }
    
    
    
    
    @IBAction func skipTapped(_ sender: Any) {
        let skipUrl = baseCustomerUrl + "appointments/comments/skip"
        //        print(skipUrl)
        ServiceAPI.shared.fetchGenericData(urlString: skipUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: commentsModel?, error:Error?,status:Int?) in
            self.dismissLoding()
            //            print(status)
            if status == 200 {
                //                let message = model?.data ?? []
                //                print(message)
                self.dismiss(animated: true, completion: nil)
            }else{
                setMessageLanguageData(&apptNotValid, key: "This appointment not valid")
                self.displayAlertMsg(userMsg: apptNotValid)
            }
        }
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // ---------------------------------------------------------------
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (commentTextView.textColor == UIColor.lightGray) && (commentTextView.isFirstResponder) {
            commentTextView.text = ""
            commentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentTextView.text.isEmpty || commentTextView.text == "" {
            commentTextView.textColor = UIColor.lightGray
            commentTextView.text = "comment ..."
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            commentTextView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    // ------------------------------- hide keyboard ---------------------------------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
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
        
        let myAlert = UIAlertController(title: successfullyDone, message: userMsg, preferredStyle: UIAlertController.Style.alert)
        let okAction = (UIAlertAction(title:msgOk, style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil);
    }
}


var apptNotValid = String()
var rateSent = String()
