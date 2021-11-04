//
//  AppointmentDetailsVC.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import Alamofire


class AppointmentDetailsVC: UIViewController {

    @IBOutlet weak var providerImage            : UIImageView!
    @IBOutlet weak var providerNameLabel        : UILabel!
    @IBOutlet weak var serviceLabel             : UILabel!
    @IBOutlet weak var providerAddresLabel      : UILabel!
    @IBOutlet weak var apptStatus               : UILabel!
    @IBOutlet weak var statusImgIcon            : UIImageView!
    @IBOutlet weak var bookIdLbl                : UILabel!
    @IBOutlet weak var callBtnOutlet            : UIButton!
    
    @IBOutlet weak var clientNameLabel          : UILabel!
    @IBOutlet weak var clientNumberLabel        : UILabel!
    
    @IBOutlet weak var clientGenderLabel        : UILabel!
    @IBOutlet weak var clientDescLabel          : UILabel!
    @IBOutlet weak var applicantNameLbl         : UILabel!
    @IBOutlet weak var cancelBtn                : UIButton!

    @IBOutlet weak var apptDate                 : UILabel!
    @IBOutlet weak var apptTime                 : UILabel!
    @IBOutlet weak var firstApptLabel           : UILabel!
    @IBOutlet weak var firstApptVertical        : NSLayoutConstraint!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var applicantNameLab: UILabel!
    @IBOutlet weak var clientNameLab: UILabel!
    @IBOutlet weak var phoneNumberLab: UILabel!
    @IBOutlet weak var genderLab: UILabel!
    @IBOutlet weak var descLab: UILabel!
    @IBOutlet weak var appointDateLab: UILabel!
    @IBOutlet weak var appointTimeLab: UILabel!
    @IBOutlet weak var bookLab: UILabel!
    @IBOutlet weak var servLab: UILabel!
    
    
    
    var passedSelectedApptId        = Int()
    var apptsData                   : showApptData?
    
    var clientName                  = String()
    var clientPhoneNumber           = String()
    var staffPhonNumber             = String()
    var clientDesc                  = String()
    
    var clientGenderr               = String()
    var appDate                     = String()
    var appTime                     = String()
    
    var cancelApptt                     = String()
    
    override func viewWillAppear(_ animated: Bool) {
        getApptInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        firstApptLabel.isHidden = true
        firstApptVertical.constant = 16.0
        
        setMessageLanguageData(&appointmentDetailsPageTitle, key: "Appointment Details")
        self.navigationItem.title = appointmentDetailsPageTitle
        
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

        
        cornerButton(button: cancelBtn, cornerValue: 6.0, maskToBounds: true)
        cornerImage(image: providerImage, cornerValue: (Float(providerImage.frame.height / 2)), maskToBounds: true)
        
        setLabelLanguageData(label: applicantNameLab,key: "Applicant Name")
        setLabelLanguageData(label: clientNameLab, key: "Client Name")
        
        setLabelLanguageData(label: firstApptLabel, key: "First time that confirmed for you")
        
        setLabelLanguageData(label: genderLab,key: "Gender")
        setLabelLanguageData(label: phoneNumberLab, key: "phone")
        
        setLabelLanguageData(label: descLab,key: "description")
        setLabelLanguageData(label: appointDateLab, key: "Date appointment")
        setLabelLanguageData(label: servLab,key: "Service")
        setLabelLanguageData(label: appointTimeLab,key: "time appointment")
        setLabelLanguageData(label: bookLab, key: "Book id")
        
        setButtonLanguageData(button: cancelBtn, key: "Cancel appointment")
    }
    
    @objc func editAppt(){
        performSegue(withIdentifier: "toEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEdit"{
            let destVC = segue.destination as! EditAppointmentVC
            destVC.passedClientName = self.clientName
            destVC.passedNumber = self.clientPhoneNumber
            destVC.passedDesc = self.clientDesc
            destVC.passedGender = self.clientGenderr
            destVC.passedDate = self.apptDate.text ?? ""
            destVC.passedTime = self.apptTime.text ?? ""
            destVC.passedApptId = passedSelectedApptId
        }
    }
    
//***************************** get Doctor information *******************************
    func getApptInfo(){
        loading()
        let apptDetailUrl = baseCustomerUrl + "appointments/" + "\(passedSelectedApptId)"
        print(apptDetailUrl)
        ServiceAPI.shared.fetchGenericData(urlString: apptDetailUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: showApptModel?, error:Error?,status:Int?) in
            self.dismissLoding()
            print(status)
            if status == 200 {
                self.apptsData = model?.data
                print(self.apptsData)
                
                self.applicantNameLbl.text = (self.apptsData?.applicant?.name ?? "")
                self.bookIdLbl.text =  (self.apptsData?.book_id ?? "")
                
                self.clientName = self.apptsData?.client_name ?? ""
                self.clientNameLabel.text = (self.apptsData?.client_name ?? "client name")
                
                self.clientPhoneNumber = self.apptsData?.client_phone ?? "client number"
                self.clientNumberLabel.text = (self.apptsData?.client_phone ?? "client number")
                
                
                self.clientDesc = self.apptsData?.description ?? "Description ..."
                self.clientDescLabel.text =  (self.apptsData?.description ?? "Description ...")
                
                self.providerNameLabel.text = self.apptsData?.staff?.name ?? "Provider Name"
                self.serviceLabel.text = self.apptsData?.service?.title ?? "Service"
                self.providerAddresLabel.text = self.apptsData?.industry?.address ?? "Address"
                self.staffPhonNumber = self.apptsData?.industry?.phone ?? ""
                self.callBtnOutlet.setTitle(self.staffPhonNumber, for: .normal)
                let imageUrl = self.apptsData?.staff?.avatar?.url_sm ?? ""
                getImage(urlStr: imageUrl, img: self.providerImage)
                
                let statuss = self.apptsData?.status ?? ""
                if statuss == "pending" {
                    setMessageLanguageData(&pendingg, key: "pending")
                    self.apptStatus.text = pendingg
                }
                if statuss == "confirmed" {
                    setMessageLanguageData(&confiremdd, key: "confirmed")
                    self.apptStatus.text = confiremdd
                }
                if statuss == "no-show" {
                    setMessageLanguageData(&noShoww, key: "no-show")
                    self.apptStatus.text = noShoww
                }
                if statuss == "done" {
                    setMessageLanguageData(&donee, key: "Done")
                    self.apptStatus.text = donee
                }
                
                if self.apptsData?.client_gender == 1{
                    self.clientGenderr = "Male"
                    setLabelLanguageData(label: self.clientGenderLabel, key: "male")
                }else{
                    self.clientGenderr = "Femal"
                    setLabelLanguageData(label: self.clientGenderLabel, key: "female")
                }
                
                if self.apptsData?.status == "pending" {
                    setLabelLanguageData(label: self.date, key: "from date")
                    setLabelLanguageData(label: self.time, key: "from time")
                    self.firstApptLabel.isHidden = true
                    self.firstApptVertical.constant = 16.0
                    self.statusImgIcon.image = pendingIcon
                    let fullDate = self.apptsData?.from_to ?? ""
                    let separateDate = fullDate.split(separator: " ")
                    
                    if separateDate.count > 0 {
                        self.apptDate.text = "\(separateDate[0])"
                        self.apptTime.text = "\(separateDate[1])"
                    }
                    
                    // ---------------- efit appointment --------
                    
                    setMessageLanguageData(&navigationEdit, key: "Edit")
                    let editAppt = UIBarButtonItem(title: navigationEdit, style: .plain, target: self, action: #selector(AppointmentDetailsVC.editAppt))
                    self.navigationItem.rightBarButtonItem = editAppt
                    
                }
                
                if self.apptsData?.status == "done" {
                    setLabelLanguageData(label: self.date, key: "Date appointment")
                    setLabelLanguageData(label: self.time, key: "time appointment")
                    
                    self.firstApptLabel.isHidden = true
                    self.firstApptVertical.constant = 16.0
                    self.statusImgIcon.image = doneIcon
                    self.cancelBtn.backgroundColor = gray
                    self.cancelBtn.isEnabled = false
                    let fullDate = self.apptsData?.start_time ?? ""
                    let separateDate = fullDate.split(separator: " ")
                    
                    if separateDate.count > 0 {
                        self.apptDate.text = "\(separateDate[0])"
                        self.apptTime.text = "\(separateDate[1])"
                    }
                }
                if self.apptsData?.status == "confirmed" {
                    setLabelLanguageData(label: self.date, key: "confirmed date")
                    setLabelLanguageData(label: self.time, key: "confirmed time")
                    
                    self.firstApptLabel.isHidden = false
                    self.firstApptVertical.constant = 32.0
                    self.statusImgIcon.image = confirmIcon
                    let fullDate = self.apptsData?.start_time ?? ""
                    let separateDate = fullDate.split(separator: " ")
                    
                    if separateDate.count > 0 {
                        self.apptDate.text = "\(separateDate[0])"
                        self.apptTime.text = "\(separateDate[1])"
                    }
                }
                if self.apptsData?.status == "no-show" {
                    setLabelLanguageData(label: self.date, key: "Date appointment")
                    setLabelLanguageData(label: self.time, key: "time appointment")
                    self.firstApptLabel.isHidden = true
                    self.firstApptVertical.constant = 16.0
                    self.statusImgIcon.image = noShowIcon
                    self.cancelBtn.backgroundColor = gray
                    self.cancelBtn.isEnabled = false
                    let fullDate = self.apptsData?.start_time ?? ""
                    let separateDate = fullDate.split(separator: " ")
                    
                    if separateDate.count > 0 {
                        self.apptDate.text = "\(separateDate[0])"
                        self.apptTime.text = "\(separateDate[1])"
                    }
                }
            }else{
                let message = swiftyJsonVar["message"].string
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                self.displayAlertMsg(userMsg: message ?? someThingWentWrong)
            }
        }
    }
    
    @IBAction func cancelApptTapped(_ sender: Any) {
        setMessageLanguageData(&self.cancelApptt, key: "Do you want to cancel this appointment")
        displayQuestionMsg(userMsg: self.cancelApptt)
    }
    
    func displayQuestionMsg(userMsg: String){
        
        setMessageLanguageData(&yes, key: "yes")
        setMessageLanguageData(&no, key: "no")
        
        let myAlert = UIAlertController(title: "" ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
        let okAction = (UIAlertAction(title: yes, style: .default, handler: { action in
            self.cancelAppt()
        }))
        let cancelAction = (UIAlertAction(title: no, style: .cancel, handler: { action in
            print("Oooch!")
        }))
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        self.present(myAlert, animated:true, completion:nil);
    }
    
    func cancelAppt(){
        loading()
        let deleteUrl = baseCustomerUrl + "appointments/" + "\(passedSelectedApptId)"
        print(deleteUrl)
        ServiceAPI.shared.fetchGenericData(urlString: deleteUrl, parameters: emptyParam, methodInput: .delete, isHeaders: true) { (model: MessageModel?, error:Error?,status:Int?) in
            print(status)
            self.dismissLoding()
            if status == 200 {
                setMessageLanguageData(&SuccessfullyCancel, key: "Successfully Canceled")
//                let deleteApptsMessage = model?.data?.message ?? SuccessfullyCancel
                self.displaySuccessMsg(userMsg: SuccessfullyCancel)
                
            }else{
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                let errorMessage = model?.data?.message ?? someThingWentWrong
                self.displayAlertMsg(userMsg: errorMessage)
            }
        }
    }
    
    @IBAction func callTurningTapped(_ sender: Any) {
        let url:NSURL = URL(string: ("TEL://" + self.staffPhonNumber))! as NSURL
        UIApplication.shared.open(url as URL)
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
    
    func displayAlertMsg(userMsg: String){
        setMessageLanguageData(&msgAlert, key: "Warrning")
        setMessageLanguageData(&msgOk, key: "Ok")
        
        let myAlert = UIAlertController(title: msgAlert ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: msgOk,style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil);
    }
}


var SuccessfullyCancel = String()
var malee = String()
var femalee = String()


var navigationEdit = String()
var navigationSave = String()
var cancelApptt                     = String()
