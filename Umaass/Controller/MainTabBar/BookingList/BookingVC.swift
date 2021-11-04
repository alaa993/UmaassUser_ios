//
//  BookingVC.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage



class BookingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var noItemLabel: UILabel!
    @IBOutlet weak var myApptsTableView: UITableView!
   
    
    var blackView             = UIView()
    var allApptsDataList      = [AllApptsData]()
    var moreApptsDataList     = [AllApptsData]()
    var selectedApptId        = Int()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
//        let button = UIButton.init(type: .custom)
//        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 50)
//        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 50)
//        heightConstraint.isActive = true
//        widthConstraint.isActive = true
//        button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
//        cornerButton(button: button, cornerValue: 6.0, maskToBounds: true)
//        button.setImage(UIImage.init(named: "umaassIcon.png"), for: UIControl.State.normal)
//        let logoImg = UIBarButtonItem.init(customView: button)
//        self.navigationItem.rightBarButtonItem = logoImg

        
        noItemLabel.isHidden = true
        myApptsTableView.isHidden = true
        
        
        setMessageLanguageData(&myAppointmentPageTitle, key: "Appointments")
        self.navigationItem.title = myAppointmentPageTitle
        navigationController?.navigationBar.tintColor = .black
        
//        if #available(iOS 11.0, *) {
//            navigationController?.navigationBar.prefersLargeTitles = true
//            navigationItem.largeTitleDisplayMode = .always
//            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "HelveticaNeue-Bold", size: 22)!]
//        } else {
//            // Fallback on earlier versions
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllAppts()
    }
    
//***************************** get Doctor List *******************************
    func getAllAppts(){
        loading()
        let apptsUrl = baseCustomerUrl + "appointments?status=all"
        
        print(apptsUrl)
        ServiceAPI.shared.fetchGenericData(urlString: apptsUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: AllApptsModel?, error:Error?,status:Int?) in
            self.dismissLoding()
            print(status)
            if status == 200 {
                self.allApptsDataList = model?.data ?? []
                print(self.allApptsDataList)
                
                if self.allApptsDataList.count > 0 {
                    self.noItemLabel.isHidden = true
                    self.myApptsTableView.isHidden = false
                    self.myApptsTableView.reloadData()
                }else{
                    self.noItemLabel.isHidden = false
                    self.myApptsTableView.isHidden = true
                }
            }
            else if status == 401 || status == 404{
                let message = swiftyJsonVar["message"].string
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                self.displayAlertMsg(userMsg: someThingWentWrong)
                self.myApptsTableView.isHidden = true
                self.noItemLabel.isHidden = false
            }
            else if status == 500 {
                //                self.displayAlertMsg(userMsg: "wrong accesss token!")
            }
            else{
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                self.displayAlertMsg(userMsg: someThingWentWrong)
            }
        }
    }
    
    var i : Int = 2
    func loadMoreAppts(){
        loading()
        let apptsUrl = baseCustomerUrl + "appointments?page=" + "\(i)" + "&status=all"
        print(apptsUrl)
        ServiceAPI.shared.fetchGenericData(urlString: apptsUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: AllApptsModel?, error:Error?,status:Int?) in
            self.dismissLoding()
            print(status)
            if status == 200 {
                self.moreApptsDataList = model?.data ?? []
                print(self.moreApptsDataList)
                
                if self.moreApptsDataList.count > 0 {
                    for j in 0..<self.moreApptsDataList.count {
                        self.allApptsDataList.append(self.moreApptsDataList[j])
                        
                    }
                    self.i = self.i + 1
                    self.myApptsTableView.reloadData()
                }
            }else if status == 401 || status == 404 {
                let message = swiftyJsonVar["message"].string
                setMessageLanguageData(&unacouticated, key: "Unauthenticated! Please log out and login again")
                self.displayAlertMsg(userMsg: unacouticated)
                self.myApptsTableView.isHidden = true
                self.noItemLabel.isHidden = false
            }
            else if status == 500 {
                //                self.displayAlertMsg(userMsg: "Wrong access token! Please logOut and login again")
            }
            else{
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                self.displayAlertMsg(userMsg: someThingWentWrong)
            }
        }
    }
    
    
// ************************************ Doctors Table *************************
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.allApptsDataList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myApptCell = tableView.dequeueReusableCell(withIdentifier: "BookingTableCell", for: indexPath) as! BookingTableViewCell
        
        myApptCell.providerNameLabel.text = self.allApptsDataList[indexPath.row].staff?.name ?? ""
        myApptCell.categoryFieldLabel.text = "   " + (self.allApptsDataList[indexPath.row].industry?.category?.name ?? "")
        myApptCell.clientNameLbale.text = self.allApptsDataList[indexPath.row].client_name ?? ""
        
        let status = self.allApptsDataList[indexPath.row].status ?? ""
        if status == "pending" {
            setMessageLanguageData(&pendingg, key: "pending")
            myApptCell.statusLabel.text = pendingg
        }
        if status == "confirmed" {
            setMessageLanguageData(&confiremdd, key: "confirmed")
            myApptCell.statusLabel.text = confiremdd
        }
        if status == "no-show" {
            setMessageLanguageData(&noShoww, key: "no show")
            myApptCell.statusLabel.text = noShoww
        }
        if status == "done" {
            setMessageLanguageData(&donee, key: "Done")
            myApptCell.statusLabel.text = donee
        }
        
        
        if self.allApptsDataList[indexPath.row].status == "pending" {
            myApptCell.statusIconImg.image = pendingIcon
            
            let fullDate = self.allApptsDataList[indexPath.row].from_to ?? ""
            let separateDate = fullDate.split(separator: " ")
            if separateDate.count > 0 {
                myApptCell.reservDateLabel.text = "\(separateDate[0])"
                myApptCell.reservClockLabel.text = "\(separateDate[1])"
            }
        }
        if self.allApptsDataList[indexPath.row].status == "done" {
            myApptCell.statusIconImg.image = doneIcon
            let fullDate = self.allApptsDataList[indexPath.row].start_time ?? ""
            let separateDate = fullDate.split(separator: " ")
            if separateDate.count > 0 {
                myApptCell.reservDateLabel.text = "\(separateDate[0])"
                myApptCell.reservClockLabel.text = "\(separateDate[1])"
            }
        }
        if self.allApptsDataList[indexPath.row].status == "confirmed" {
            myApptCell.statusIconImg.image = confirmIcon
            let fullDate = self.allApptsDataList[indexPath.row].start_time ?? ""
            let separateDate = fullDate.split(separator: " ")
            if separateDate.count > 0 {
                myApptCell.reservDateLabel.text = "\(separateDate[0])"
                myApptCell.reservClockLabel.text = "\(separateDate[1])"
            }
        }
        if self.allApptsDataList[indexPath.row].status == "no-show" {
            myApptCell.statusIconImg.image = noShowIcon
            let fullDate = self.allApptsDataList[indexPath.row].start_time ?? ""
            let separateDate = fullDate.split(separator: " ")
            if separateDate.count > 0 {
                myApptCell.reservDateLabel.text = "\(separateDate[0])"
                myApptCell.reservClockLabel.text = "\(separateDate[1])"
            }
        }
        
        myApptCell.serviceLabel.text = self.allApptsDataList[indexPath.row].service?.title ?? ""
        
        getImage(urlStr: (self.allApptsDataList[indexPath.row].staff?.avatar?.url_sm ?? ""), img: myApptCell.providerImg)
        
        if indexPath.row == self.allApptsDataList.count - 1{
            self.loadMoreAppts()
        }
        
        return myApptCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedApptId = self.allApptsDataList[indexPath.row].id ?? 1
        performSegue(withIdentifier: "toApptDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toApptDetails"{
            let destVC = segue.destination as! AppointmentDetailsVC
            destVC.passedSelectedApptId = selectedApptId
        }
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



//func rightLogoImage(navigateion: UINavigationItem) {
//    let button = UIButton.init(type: .custom)
//    let widthConstraint = button.widthAnchor.constraint(equalToConstant: 50)
//    let heightConstraint = button.heightAnchor.constraint(equalToConstant: 50)
//    heightConstraint.isActive = true
//    widthConstraint.isActive = true
//    button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
//    cornerButton(button: button, cornerValue: 6.0, maskToBounds: true)
//    button.setImage(UIImage.init(named: "umaassIcon.png"), for: UIControl.State.normal)
//    let logoImg = UIBarButtonItem.init(customView: button)
//    navigateion.rightBarButtonItem = logoImg
//}



var pendingg = String()
var confiremdd = String()
var noShoww = String()
var donee = String()
