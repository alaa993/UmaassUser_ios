//
//  ProfileVC.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import CoreData



class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, bookingApptCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var favoriteTableView        : UITableView!
    @IBOutlet weak var profileImage             : UIImageView!
    @IBOutlet weak var userNameLabel            : UILabel!
    @IBOutlet weak var numberLabel              : UILabel!
    @IBOutlet weak var emailLabel               : UILabel!
    @IBOutlet weak var favoriteTitle            : UILabel!
    @IBOutlet weak var favImg                   : UIImageView!
    @IBOutlet weak var languageLbl              : UILabel!
    
    @IBOutlet var btnSuggestion: UIButton!
    
    @IBOutlet weak var usernameLab  : UILabel!
    @IBOutlet weak var numberLab    : UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var emailLab     : UILabel!
    @IBOutlet weak var contactBtn   : UIButton!
    @IBOutlet weak var aboutBtn     : UIButton!
    @IBOutlet weak var editBtn      : UIButton!
    @IBOutlet weak var langBtn      : UIButton!
    
    @IBOutlet var turkishLabel: UILabel!
    @IBOutlet var turkishIconButton: UIButton!
    
// -----------------------------------------------------------
    
    @IBOutlet weak var arabicIconBtn: UIButton!
    @IBOutlet var selectLangView: UIView!
    @IBOutlet weak var selectLangLable: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var kurdishLabel: UILabel!
    @IBOutlet weak var arabicLabel: UILabel!
    @IBOutlet weak var englishIconBtn: UIButton!
    @IBOutlet weak var kurdishIconBtn: UIButton!
    @IBOutlet weak var selectLangOutletBtn: UIButton!
     @IBOutlet var label_messagCount: UILabel!
    @IBOutlet var btnMessag: UIButton!
    
    var blackView              = UIView()
    
    var markedIsShow           : Bool = false
    var isMarked               : Bool = false
    var isFavorited            : Int = 1
    var favoriteProviderId     : Int?
    var latitude               : Double? = 0.0
    var longitude              : Double? = 0.0
    var providerList           = [ProvidersData]()
    var moreProviderList       = [ProvidersData]()
    var selectId               : Int?
    var logoutmessage = String()
    
    var userName : String?
    var userEmail : String?
//    var birthdate : String?
    var gender : String?
    var addressString  : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cornerViews(view: selectLangView, cornerValue: 8.0, maskToBounds: true)
        
        if resourceKey == "en" {
            setLabelLanguageData(label: languageLbl, key: "english")
        }
        if resourceKey == "ar" {
            setLabelLanguageData(label: languageLbl, key: "arabic")
        }
        if resourceKey == "ckb" {
            setLabelLanguageData(label: languageLbl, key: "kurdish")
        }
        
        setLabelLanguageData(label: usernameLab, key: "user name")
        setLabelLanguageData(label: numberLab, key: "phone")
        setLabelLanguageData(label: emailLab, key: "Email")
        
        setLabelLanguageData(label: englishLabel, key: "english")
        setLabelLanguageData(label: kurdishLabel, key: "kurdish")
        setLabelLanguageData(label: arabicLabel, key: "arabic")
        setLabelLanguageData(label: selectLangLable, key: "Select language")
        setLabelLanguageData(label: favoriteTitle, key: "My favorite")
        setButtonLanguageData(button: selectLangOutletBtn, key: "Select language")
        
        
        setButtonLanguageData(button: contactBtn, key: "Contact us")
        setButtonLanguageData(button: aboutBtn, key: "about us")
        setButtonLanguageData(button: editBtn, key: "Edit profile")
        setButtonLanguageData(button: langBtn, key: "Language")
        
        setButtonLanguageData(button: shareBtn, key: "share")
        btnSuggestion.setTitle(setMessage(key: "Suggest Salon"), for: .normal)
        
        // ------------- banner view --------------
//        bannerView.adUnitID = unitId
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
        
        cornerImage(image: profileImage, cornerValue: Float(profileImage.frame.height / 2), maskToBounds: true)
        navigationController?.navigationBar.tintColor = .black
        
        setMessageLanguageData(&profilePageTitle, key: "profile")
        self.navigationItem.title = profilePageTitle
        
        favImg.isHidden = true
        favoriteTitle.isHidden = true
        btnMessag.setTitle(setMessage(key:"message"), for: .normal)
        label_messagCount.layer.cornerRadius = 30/2
       label_messagCount.clipsToBounds = true
//        if #available(iOS 11.0, *) {
//            navigationController?.navigationBar.prefersLargeTitles = true
//            navigationItem.largeTitleDisplayMode = .always
//            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "HelveticaNeue-Bold", size: 22)!]
//        } else {
//            // Fallback on earlier versions
//        }
        
//        let button = UIButton.init(type: .custom)
//        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 50)
//        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 50)
//        heightConstraint.isActive = true
//        widthConstraint.isActive = true
//        button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
//        cornerButton(button: button, cornerValue: 4.0, maskToBounds: true)
//        button.setImage(UIImage.init(named: "umaassIcon.png"), for: UIControl.State.normal)
//
//        let logoImg = UIBarButtonItem.init(customView: button)
        
        let logOutBtn = UIBarButtonItem(image : UIImage (named: "logOut.png"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(ProfileVC.logOutt))
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItem = logOutBtn
    }
    override func viewDidAppear(_ animated: Bool) {
       label_messagCount.text = "\(UserDefaults.standard.getMessageCount())"
    }
    
    @objc func logOutt() {
        setMessageLanguageData(&logoutmessage, key: "Are you sure logout your account")
        displayQuestionMsg(userMsg: logoutmessage)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEdit"{
            let destVC = segue.destination as! EditProfileVC
            destVC.passedName = self.userName
            destVC.passedEmail = self.userEmail
            destVC.passedGender = self.gender
//            destVC.passedBirthdate = self.birthdate
        }
        
        if segue.identifier == "toAbout"{
            let destVC = segue.destination as! AboutVC
            destVC.passedtext = addressString ?? ""
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProfile()
        getFavoriteProviderList()
    }
    
    // ********************************** Profile **********************************
    func getProfile(){
        let profileUrl = baseUrl + "profile"
        ServiceAPI.shared.fetchGenericData(urlString: profileUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: profileModell?, error:Error?,status:Int?) in
            
            //            print(status)
            if status == 200 {
                let profile = model?.data
//                print(profile)
                print(model?.data?.name ?? "")
                self.userName = (profile?.name ?? "")
                self.userNameLabel.text = self.userName
                self.userEmail = (profile?.email ?? "")
                self.emailLabel.text = self.userEmail
                self.numberLabel.text = profile?.phone ?? ""
//                self.birthdate = profile?.birthdate ?? ""
                let genderr = profile?.gender ?? 0
                if genderr == 1 {
                    self.gender = "Male"
                }else{
                    self.gender = "Female"
                }
                
                let avatarImg = profile?.avatar?.url_sm ?? ""
                let url = NSURL(string: avatarImg)
                if url != nil {
                    self.profileImage.af_setImage(withURL: url! as URL, placeholderImage: UIImage(named: "user.png"), filter: nil, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
                }else{
                    self.profileImage.image = UIImage(named: "user.png")
                }
            }else if status == 401 || status == 404 {
                //                let message = swiftyJsonVar["message"].string
                setMessageLanguageData(&unacouticated, key: "Unauthenticated! Please logOut and login again")
                self.displayAlertMsg(userMsg: unacouticated)
            }else if status == 500 {
                setMessageLanguageData(&wrongAccess, key: "Wrong access token")
                self.displayAlertMsg(userMsg: wrongAccess)
            }else{
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                self.displayAlertMsg(userMsg: someThingWentWrong)
            }
        }
    }
    
    //***************************** get Doctor List *******************************
    func getFavoriteProviderList(){
        loading()
        let providersUrl = baseCustomerUrl + "providers?page=1&favorites=true"
//        let providersParam : Parameters = [
//            "category_id"  : "all",
//            "favorites"    : "true",
//            "lat"          : latitude ?? 0.0,
//            "lng"          : longitude ?? 0.0
//        ]
        
        print(providersUrl)
        //        print(providersParam)
        ServiceAPI.shared.fetchGenericData(urlString: providersUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: ProvidersModel?, error:Error?,status:Int?) in
            
            self.dismissLoding()
            if status == 200 {
                self.providerList = model?.data ?? []
                print(self.providerList)
                if self.providerList.count > 0 {
                    self.favImg.isHidden = false
                    self.favoriteTitle.isHidden = false
                    self.favoriteTableView.isHidden = false
                    self.favoriteTableView.reloadData()
                }else{
                    self.favImg.isHidden = true
                    self.favoriteTitle.isHidden = true
                    self.favoriteTableView.isHidden = true
                }
            }else if status == 401 || status == 404{
                setMessageLanguageData(&unacouticated, key: "Unauthenticated! Please logOut and login again")
                self.displayAlertMsg(userMsg: unacouticated)
            }else{
                let message = swiftyJsonVar["message"].string
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                self.displayAlertMsg(userMsg: message ?? someThingWentWrong)
            }
        }
    }
    
    var i : Int = 2
    func loadMoreFavAppts(){
        loading()
        let providersUrl = baseCustomerUrl + "providers?page=" + "\(i)" + "&favorites=true"
        ServiceAPI.shared.fetchGenericData(urlString: providersUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: ProvidersModel?, error:Error?,status:Int?) in
            self.dismissLoding()
            if status == 200 {
                self.moreProviderList = model?.data ?? []
                if self.moreProviderList.count > 0 {
                    for i in 0..<self.moreProviderList.count {
                        self.providerList.append(self.moreProviderList[i])
                    }
                    self.i = self.i + 1
                    self.favoriteTableView.reloadData()
                }
            }else if status == 401 || status == 404{
                setMessageLanguageData(&unacouticated, key: "Unauthenticated! Please logOut and login again")
                self.displayAlertMsg(userMsg: unacouticated)
            }else{
                let message = swiftyJsonVar["message"].string
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                self.displayAlertMsg(userMsg: message ?? someThingWentWrong)
            }
        }
    }
    
    // ************************************ Doctors Table *************************
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return providerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableCell", for: indexPath) as! FavoriteTableViewCell
        
        favCell.providerNameLbl.text = self.providerList[indexPath.row].name ?? ""
        favCell.firstApptLbl.text = self.providerList[indexPath.row].first_exists_appt ?? "\(Date())"
        favCell.visitlbl.text = "\(self.providerList[indexPath.row].visits ?? 0)"
        favCell.distanceLbl.text = self.providerList[indexPath.row].distance ?? ""
        favCell.favCellDelegate = self
        
        let rateNum = self.providerList[indexPath.row].rate ?? 1.0
        print(rateNum)
        favCell.rateView.rating = Double(rateNum)
        
        let imageUrl = self.providerList[indexPath.row].avatar?.url_sm ?? ""
        print(imageUrl)
        getImage(urlStr: imageUrl, img: favCell.providerImg)
        
        
        if self.providerList[indexPath.row].is_favorited == 1 {
            favCell.favoriteBtn.setImage(markIcon, for: .normal)
        }else{
            favCell.favoriteBtn.setImage(unMarkIcon, for: .normal)
        }
        
        if indexPath.row == self.providerList.count - 1{
            self.loadMoreFavAppts()
        }
        
        return favCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectId = self.providerList[indexPath.row].id ?? 1
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "doctorProfile") as? ProviderDetailsVC {
            vc.passedProviderId = (selectId ?? 1)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
    func BookingApptCell(cell: UITableViewCell) {
        print("ok")
    }
    
    func markeAppointment(cell: UITableViewCell) {
        let index = favoriteTableView.indexPath(for: cell)!
        print(index)
        let cell = favoriteTableView.cellForRow(at: IndexPath(row: (index.row), section: 0)) as! FavoriteTableViewCell
        favoriteProviderId = providerList[index.row].id
        cell.favoriteBtn.setImage(unMarkIcon, for: .normal)
        self.unFavoriteAppt()
    }
    
    func unFavoriteAppt(){
        loading()
        let unfavoriteUrl = baseCustomerUrl + "providers/" + "\(favoriteProviderId ?? 1)" + "/unfavorite"
        print(unfavoriteUrl)
        ServiceAPI.shared.fetchGenericData(urlString: unfavoriteUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: MessageModel?, error:Error?,status:Int?) in
            
            self.dismissLoding()
            if status == 200 {
                setMessageLanguageData(&unfavoritedd, key: "Successfully Unfavorite")
                self.displaySuccessMsg(userMsg: unfavoritedd)
                
            }else{
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                let errorMessage = model?.data?.message ?? someThingWentWrong
                self.displayAlertMsg(userMsg: errorMessage)
            }
        }
    }
    
    
    @IBAction func profileImageTapped(_ sender: Any) {
        setMessageLanguageData(&photoSource, key: "Photo Source")
        setMessageLanguageData(&chooseImage, key: "Choose Images")
        setMessageLanguageData(&photoLibrary, key: "Photo Library")
        setMessageLanguageData(&cancell, key: "Cancel")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: photoSource, message: chooseImage, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: photoLibrary, style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: cancell, style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if #available(iOS 11.0, *) {
            if let url = info[.imageURL] as? NSURL{
                uploadImage(urlLocal: url as URL)
            }
        } else {
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(urlLocal: URL){
        loading()
        let uploadImageUrl = baseUrl + "uploadAvatar"
        print(uploadImageUrl)
        let _ : Parameters = ["avatar": "" , "manner": "image"]
        
        print(urlLocal)
        ServiceAPI.shared.uploadAvatar(apiUrl: uploadImageUrl, urlLocal: urlLocal.absoluteURL, parameters: emptyParam) { (result:Result<MessageModel>) in
            self.dismissLoding()
            switch result {
            case .success( _, let status):
                if status == 200 {
                    setMessageLanguageData(&successUploded, key: "Your image Successfully Uploaded")
                    self.displaySuccessMsg(userMsg: successUploded)
                }
            case .failure(_,_ ,_):
                setMessageLanguageData(&yourimageSize, key: "Your image size must less than 5 MB")
                self.displayAlertMsg(userMsg: yourimageSize)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func contactTapped(_ sender: Any) {
        performSegue(withIdentifier: "toContact", sender: self)
    }
    
    @IBAction func aboutTapped(_ sender: Any) {
        loading()
        var aboutUrl = String()
        if resourceKey == "ckb" {
            aboutUrl = "http://umaass.com/api/page/about?lang=ku"
        }else{
            aboutUrl = "http://umaass.com/api/page/about?lang=" + resourceKey
        }
        
        ServiceAPI.shared.fetchGenericData(urlString: aboutUrl, parameters: emptyParam, methodInput: .get) { (model: rulseAboutModel?, error, status) in
            self.dismissLoding()
            if status == 200 {
                self.addressString = model?.rulesdata
                print(self.addressString ?? "")
                self.performSegue(withIdentifier: "toAbout", sender: self)
            }else{
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                self.displayAlertMsg(userMsg: someThingWentWrong)
            }
        }
    }
    
    @IBAction func editProfileTapped(_ sender: Any) {
        performSegue(withIdentifier: "toEdit", sender: self)
    }
    
    @IBAction func changeLanguageTapped(_ sender: Any) {
        popAnimationIn(popView: selectLangView)
    }
    
    @IBAction func shareAppTapped(_ sender: Any) {
        if let link = NSURL(string: "Umaass") {
            let objectsToShare = ["https://apps.apple.com/us/app/umaass/id1482503635",link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
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
    
    func displaySuccessMsg(userMsg: String){
        setMessageLanguageData(&successfullyDone, key: "Successfully Done")
        setMessageLanguageData(&ok, key: "Ok")
        
        let myAlert = UIAlertController(title: successfullyDone ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
        let okAction = (UIAlertAction(title: ok, style: .default, handler: { action in
            self.getFavoriteProviderList()
        }))
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil);
    }
    
    func displayQuestionMsg(userMsg: String){
        
        setMessageLanguageData(&yes, key: "yes")
        setMessageLanguageData(&no, key: "no")
        
        let msgAlertt = String()
        let myAlert = UIAlertController(title: msgAlertt ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
        let okAction = (UIAlertAction(title: yes, style: .default, handler: { action in
            self.logOut()
        }))
        let cancelAction = (UIAlertAction(title: no, style: .cancel, handler: { action in
            print("kojaaaa dadaaaaa bemon pishemoon")
        }))
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        self.present(myAlert, animated:true, completion:nil);
    }
    
    func logOut(){
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            let results = try context.fetch(request)
            for result in results as [NSManagedObject] {
                context.delete(result)
                print("User Data: \(results) is deleted")
            }
            do {
                try context.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
        } catch {
            print("Error with request: \(error)")
        }
        let reloadPage = self.storyboard?.instantiateViewController(withIdentifier: "SplashScreen")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = reloadPage
        
    }
    
    
// -------------------------------- Animation -------------------------------
    
    @IBAction func dismissTapped(_ sender: Any) {
        popAnimateOut(popView: selectLangView)
    }
    
    
    @IBAction func englishTapped(_ sender: Any) {
        
        englishIconBtn.setImage(UIImage(named: "selectOn"), for: .normal)
        kurdishIconBtn.setImage(UIImage(named: "selectOff"), for: .normal)
        arabicIconBtn.setImage(UIImage(named: "selectOff"), for: .normal)
           turkishIconButton.setImage(UIImage(named: "selectOff"), for: .normal)
        
        appLang = "English"
        resourceKey = "en"
    }
    
    @IBAction func kurdishTapped(_ sender: Any) {
       
        englishIconBtn.setImage(UIImage(named: "selectOff"), for: .normal)
        kurdishIconBtn.setImage(UIImage(named: "selectOn"), for: .normal)
        arabicIconBtn.setImage(UIImage(named: "selectOff"), for: .normal)
           turkishIconButton.setImage(UIImage(named: "selectOff"), for: .normal)
        
        appLang = "Kurdish"
        resourceKey = "ckb"
    }
    
    @IBAction func arabicTapped(_ sender: Any) {
        
        englishIconBtn.setImage(UIImage(named: "selectOff"), for: .normal)
        kurdishIconBtn.setImage(UIImage(named: "selectOff"), for: .normal)
        arabicIconBtn.setImage(UIImage(named: "selectOn"), for: .normal)
        turkishIconButton.setImage(UIImage(named: "selectOff"), for: .normal)
        appLang = "Arabic"
        resourceKey = "ar"
    }
    
    @IBAction func turkish(_ sender: Any) {
          
          englishIconBtn.setImage(UIImage(named: "selectOff"), for: .normal)
          kurdishIconBtn.setImage(UIImage(named: "selectOff"), for: .normal)
          arabicIconBtn.setImage(UIImage(named: "selectOff"), for: .normal)
          turkishIconButton.setImage(UIImage(named: "selectOn"), for: .normal)
          
          appLang = "Turkish"
          resourceKey = "tr"
          
      }
    
    @IBAction func selectLanguageTapped(_ sender: Any) {
        
        let request: NSFetchRequest<Setting> = Setting.fetchRequest()
        do {
            let results = try context.fetch(request)
            for result in results as [NSManagedObject] {
                context.delete(result)
                print("User Data: \(results) is deleted")
            }
            do {
                try context.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
        } catch {
            print("Error with request: \(error)")
        }
        
        popAnimateOut(popView: selectLangView)
        if resourceKey == "en" {
            setLabelLanguageData(label: languageLbl, key: "english")
        }
        if resourceKey == "ar" {
            setLabelLanguageData(label: languageLbl, key: "arabic")
        }
        if resourceKey == "ckb" {
            setLabelLanguageData(label: languageLbl, key: "kurdish")
        }
        if resourceKey == "tr" {
            setLabelLanguageData(label: languageLbl, key: "turkish")
        }
        saveLanguage(language: appLang, languageCode: resourceKey)
        saveChangelanguge()

    }
    
    
    
    func popAnimationIn(popView: UIView){
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.7)
            blackView.frame = window.frame
            window.addSubview(blackView)
            popView.center = self.view.center
            popView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            popView.alpha = 0
            UIApplication.shared.keyWindow?.addSubview(popView)
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                popView.alpha = 1
                popView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    func popAnimateOut(popView: UIView){
        UIView.animate(withDuration: 0.5, animations: {
            popView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            popView.alpha = 0
            self.blackView.alpha = 0
        }) { (success:Bool) in
            popView.removeFromSuperview()
        }
    }
    
    
    func saveChangelanguge() {
         
         loading()
         var finalUrl           = String()
         var languge = ""
         var deviceId = ""
         let UUIDValue = UIDevice.current.identifierForVendor!.uuidString
         deviceId = "customer-" + UUIDValue
         let baseurll = baseUrl + "user/language?device_id=\(deviceId)"
         
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
         
         let finalUr = baseurll + languge
         
         if finalUr.contains(" ")  {
             finalUrl = finalUr.replacingOccurrences(of: " ", with: "%20")
         }else{
             finalUrl = finalUr
         }
         
         let headers:HTTPHeaders = [
             "Authorization": "Bearer \(accessToken)",
             "X-Requested-With": "application/json",
            // "Content-type" : "application/json",
             "Accept" : "application/json"
         ]
         
         Alamofire.request(finalUrl, method: .patch, headers: headers).responseJSON { response in
             self.dismissLoding()
            
//print(response.debugDescription)
            
            let reloadPage = self.storyboard?.instantiateViewController(withIdentifier: "SplashScreen")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = reloadPage
            appDelegate.ChangeLayout()
             
         }
     }
    
    
}


