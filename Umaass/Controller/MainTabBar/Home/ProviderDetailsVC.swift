//
//  ProviderDetailsVC.swift
//  Umaass
//
//  Created by Hesam on 7/1/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import AlamofireImage
import Cosmos


class ProviderDetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mainView                   : UIView!
    @IBOutlet weak var providerImg                  : UIImageView!
    @IBOutlet weak var providerNameLbl            : UILabel!
    @IBOutlet weak var providerAddress            : UILabel!
    @IBOutlet weak var providerDescriptionLabel   : UILabel!
    @IBOutlet weak var providerExpertiseLbl       : UILabel!
    @IBOutlet weak var serviceCollection          : UICollectionView!
    @IBOutlet weak var callOutletBtn              : UIButton!
    @IBOutlet weak var bookOutletBtn              : UIButton!
    @IBOutlet weak var rateview                   : CosmosView!
    @IBOutlet weak var commentsBtn                : UIButton!
    @IBOutlet weak var workingHoursBtn            : UIButton!
    @IBOutlet weak var galleryBtn                 : UIButton!
    @IBOutlet weak var mapBtn                     : UIButton!
    @IBOutlet weak var noServiceLbl               : UILabel!
    
    @IBOutlet weak var addressLab: UILabel!
    @IBOutlet weak var descLab: UILabel!
    @IBOutlet weak var serviceLab: UILabel!
    
    
    
    
    var tableItem          = ["Services","Staff"]
    var currentLocation    : CLLocation?
    var locationManager    = CLLocationManager()
    var lat                : Double?
    var lng                : Double?
    var marker             = GMSMarker()
    var selectService      = String()
    
    var passedProviderId   = Int()
    var providerPhonNumber = String()
    
    var providerDetails    : showProviderData?
    
    var serviceSelectedIndex   : Int?
    var staffSelectedIndex     : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setButtonLanguageData(button: commentsBtn, key: "comments")
        setButtonLanguageData(button: workingHoursBtn, key: "working hours")
        setButtonLanguageData(button: galleryBtn, key: "gallery")
        setButtonLanguageData(button: mapBtn, key: "location")
        setButtonLanguageData(button: bookOutletBtn, key: "Book now")
        
        setLabelLanguageData(label: addressLab, key: "Address")
        setLabelLanguageData(label: descLab, key: "description")
        setLabelLanguageData(label: serviceLab, key: "Services")
        setLabelLanguageData(label: noServiceLbl, key: "noService")
        
        
        cornerButton(button: commentsBtn, cornerValue: 8.0, maskToBounds: true)
        cornerButton(button: workingHoursBtn, cornerValue: 8.0, maskToBounds: true)
        cornerButton(button: galleryBtn, cornerValue: 8.0, maskToBounds: true)
        cornerButton(button: mapBtn, cornerValue: 8.0, maskToBounds: true)
        serviceId = nil
        serviceCollection.isHidden = true
        noServiceLbl.isHidden = true
        getIndistryInfo()
        
        setMessageLanguageData(&providerPageTitle, key: "Provider Details")
        self.navigationItem.title = providerPageTitle
        cornerImage(image: providerImg, cornerValue: Float(providerImg.frame.height / 2), maskToBounds: true)
        cornerButton(button: bookOutletBtn, cornerValue: 4.0, maskToBounds: true)
        
//        locationManager.delegate = self
//                googleMapView.isMyLocationEnabled = true
//                googleMapView.settings.compassButton = true
//                googleMapView.settings.myLocationButton = true
//                locationManager.desiredAccuracy = kCLLocationAccuracyBest
//                locationManager.startUpdatingLocation()
//                locationManager.requestWhenInUseAuthorization()
//                locationManager.requestAlwaysAuthorization()
//                locationManager.startMonitoringSignificantLocationChanges()
//        
        
//        let button = UIButton.init(type: .custom)
//        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 50)
//        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 50)
//        heightConstraint.isActive = true
//        widthConstraint.isActive = true
//        button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
//        cornerButton(button: button, cornerValue: 4.0, maskToBounds: true)
//        button.setImage(UIImage.init(named: "umaassIcon.png"), for: UIControl.State.normal)
//        let logoImg = UIBarButtonItem.init(customView: button)
//
//        navigationItem.rightBarButtonItem = logoImg
//
    }

//***************************** get Doctor information *******************************
    func getIndistryInfo(){
        loading()
        let industryDetailUrl = baseCustomerUrl + "providers/" + "\(passedProviderId)"
        print(industryDetailUrl)
        ServiceAPI.shared.fetchGenericData(urlString: industryDetailUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: showProviderModel?, error:Error?,status:Int?) in
            self.dismissLoding()
            if status == 200 {
                self.providerDetails = model?.data
                //                print(self.providerDetails)
                
                providerName = model?.data?.name ?? "provider name"
                self.providerNameLbl.text = providerName
                
                self.providerPhonNumber = model?.data?.industry?.phone ?? ""
                self.callOutletBtn.setTitle(self.providerPhonNumber, for: .normal)
                
                self.providerAddress.text = model?.data?.industry?.address ?? "Address"
                
                self.providerDescriptionLabel.text = model?.data?.industry?.description ?? "Description"
                
                let rateNum = model?.data?.rate ?? 0.0
                print(rateNum)
                self.rateview.rating = Double(rateNum)
                
                let imageUrl = model?.data?.avatar?.url_sm ?? ""
                getImage(urlStr: imageUrl, img: self.providerImg)
                
                industryName = (model?.data?.category_name ?? "catName") + " - " +
                    (model?.data?.industry?.title ?? "Industry")
                self.providerExpertiseLbl.text = industryName
                
                serviceList = model?.data?.services ?? []
                print(serviceList)
                if serviceList.count == 0 {
                    self.bookOutletBtn.isEnabled = false
                    self.bookOutletBtn.backgroundColor = .lightGray
                    self.serviceCollection.isHidden = true
                    self.noServiceLbl.isHidden = false
                }
                if serviceList.count > 0 {
                    self.bookOutletBtn.isEnabled = true
                    self.bookOutletBtn.backgroundColor = greenColor
                    self.serviceCollection.isHidden = false
                    self.noServiceLbl.isHidden = true
                    self.serviceCollection.reloadData()
                }
                
                providerWorkingHors = model?.data?.industry?.working_hours ?? []
                for i in 0..<providerWorkingHors.count  {
                    let day = providerWorkingHors[i].day ?? 1
                    providerWeekDays.append(day)
                    
                }
                
                imageGallery = model?.data?.industry?.gallery
                //                print(imageGallery)
                
                providerLat = model?.data?.industry?.lat ?? ""
                providerLng = model?.data?.industry?.lng ?? ""
                
                self.serviceCollection.reloadData()
            }else{
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                self.displayAlertMsg(userMsg: someThingWentWrong)
            }
        }
    }
    
// ************************************ Provider collections **********************************
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let serviceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionCell", for: indexPath) as! ServiceCollectionViewCell
        
        serviceCell.layer.cornerRadius = 6.0
        serviceCell.layer.masksToBounds = true
        serviceCell.layer.cornerRadius = 6.0
        serviceCell.layer.masksToBounds = true
        cornerViews(view: serviceCell.serviceMainView, cornerValue: 6.0, maskToBounds: true)
        cornerImage(image: serviceCell.checkBocImg, cornerValue: 6.0, maskToBounds: true)
        
        setLabelLanguageData(label: serviceCell.serviceNameLab, key: "Service Name")
        setLabelLanguageData(label: serviceCell.serviceTimeLab, key: "Service Time Duration")
        setLabelLanguageData(label: serviceCell.servicePriceLab, key: "Service Price")
        
        serviceCell.serviceNameLbl.text = serviceList[indexPath.row].title ?? ""
        serviceCell.serviceDurationLbl.text = "\(serviceList[indexPath.row].duration ?? 10)" + " min"
        serviceCell.servicePriceLbl.text = "\(serviceList[indexPath.row].price ?? 10)" + " $"
        
        //        print(serviceSelectedIndex)
        if serviceSelectedIndex == indexPath.row {
            serviceCell.checkBocImg.isHidden = false
        }else{
            serviceCell.checkBocImg.isHidden = true
        }
        
        return serviceCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        serviceId = (serviceList[indexPath.row].id ?? 1)
        serviceSelectedIndex = indexPath.row
    
        bookOutletBtn.isEnabled = true
        bookOutletBtn.backgroundColor = greenColor
    
        serviceCollection.reloadData()
    }

    @IBAction func toGalleryTapped(_ sender: Any) {
        performSegue(withIdentifier: "toGallery", sender: self)
    }
    
    
    @IBAction func BookNowTapped(_ sender: Any) {
        
        
        if accessToken == "" {
            let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.present(destVC, animated: false, completion: nil)
            return
        }
        if serviceId == nil {
            setMessageLanguageData(&selectService, key: "Please select your service")
            self.displayAlertMsg(userMsg: selectService)
        }else{
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "toBookingStep") as? SetInformationVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "toBookingStep") as? SetDateTimeVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onMapTapped(_ sender: Any) {
        performSegue(withIdentifier: "toMap", sender: self)
    }
    
    @IBAction func toCommentsTapped(_ sender: Any) {
        performSegue(withIdentifier: "toComments", sender: self)
    }
    
    @IBAction func workingHoursTapped(_ sender: Any) {
        performSegue(withIdentifier: "toHours", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            let destVC = segue.destination as! CommentsVC
            destVC.passedProviderId = passedProviderId
        }
    }
    
    @IBAction func callTurningTapped(_ sender: Any) {
        let url:NSURL = URL(string: ("TEL://" + providerPhonNumber))! as NSURL
        UIApplication.shared.open(url as URL)
    }
    
    func displayAlertMsg(userMsg: String){
        setMessageLanguageData(&msgAlert, key: "Warrning")
        setMessageLanguageData(&msgOk, key: "Ok")
        
        let myAlert = UIAlertController(title: msgAlert ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: msgOk,style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil);
    }
    
    func buttonsDesign(button: UIButton){
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 0.5
        
    }
}







