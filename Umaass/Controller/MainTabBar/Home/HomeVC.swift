//
//  HomeVC.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces


class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, bookingApptCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, GMSMapViewDelegate {

       @IBOutlet var label_category: UILabel!
       @IBOutlet var label_Country: UILabel!
       @IBOutlet var textField_Country: UITextField!
       @IBOutlet var textField_Category: UITextField!
    
    @IBOutlet weak var noItemLabel             : UILabel!
    @IBOutlet weak var categoryCollectionView  : UICollectionView!
    @IBOutlet weak var ProviderTableView       : UITableView!
    @IBOutlet weak var filterOutletBtn         : UIButton!
    @IBOutlet weak var clearFilterBtn          : UIButton!
    
    @IBOutlet var filterView                   : UIView!
    @IBOutlet weak var switchDist              : UISwitch!
    @IBOutlet weak var cityText                : UITextField!
    @IBOutlet weak var slideView               : UIView!
    @IBOutlet weak var slideBar                : UISlider!
    
    @IBOutlet weak var nearMeLab               : UILabel!
    @IBOutlet weak var distanceLab             : UILabel!
    @IBOutlet weak var selectCityLab           : UILabel!
    
    @IBOutlet weak var startDistLbl            : UILabel!
    @IBOutlet weak var variableDistLbl         : UILabel!
    @IBOutlet weak var endDistLbl              : UILabel!
   
    
    
    var categoryList           = [categoryData]()
    var cityList               = [CityData]()
    var selectedCityId         : String?
      var selectCountryId:String?
    
    var providerList           = [ProvidersData]()
    var moreProviderList       = [ProvidersData]()
    
    var blackView              = UIView()
    var cityPicker             = UIPickerView()
    var cityToolBar            = UIToolbar()
    
    var expertisePicker        = UIPickerView()
    var expertiseToolBar       = UIToolbar()
    
    var educationPicker        = UIPickerView()
    var educationToolBar       = UIToolbar()
    
    var isFavorited            : Int = 0
    var favoriteProviderId     : Int? = 0
    var selectedProviderId     = Int()
    
    var latitude               : String?
    var longitude              : String?
    
    var lat                    : String?
    var lng                    : String?
    
    var k = 2
    var switcherIsOn           : Bool? = false
    var providerName           : String?
    var alertcontroller        : UIAlertController?
    var locationManager        = CLLocationManager()
    var apptRateId : Int?
    var apptRateStatus         : String?
    
    
    var provName = String()
    var searchProvName = String()
    var enterProvName = String()
    
    var cityId:Int?
    var countryId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLabelLanguageData(label: noItemLabel, key: "No item")
        setLabelLanguageData(label: nearMeLab, key: "Near me")
        setLabelLanguageData(label: distanceLab, key: "distance")
        setLabelLanguageData(label: selectCityLab, key: "Select city")
        
        setButtonLanguageData(button: filterOutletBtn, key: "Filter")
        setButtonLanguageData(button: clearFilterBtn, key: "clear")
        
        getProfile()
        
        switchDist.isOn = false
        slideView.isHidden = true
        getAllCategory()
        getCities()
        setMessageLanguageData(&homePageTitle, key: "Category Expertise")
        self.navigationItem.title = homePageTitle
        cornerViews(view: filterView, cornerValue: 6.0, maskToBounds: true)
        cornerButton(button: filterOutletBtn, cornerValue: 6.0, maskToBounds: true)
        cornerButton(button: clearFilterBtn, cornerValue: 6.0, maskToBounds: true)
        navigationController?.navigationBar.tintColor = .black
        
        variableDistLbl.text = ""
        setUpNavBarButton()
        createCityPicker()
        createCarToolBar()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.delegate = self
        
        label_Country.text = setMessage(key: "countryFilter")
        label_category.text = setMessage(key: "category")
        textField_Country.placeholder = setMessage(key: "countryFilter")
        textField_Category.placeholder = setMessage(key: "category")
        
        textField_Country.addTarget(self, action: #selector(intentCountry), for: .touchDown)
        textField_Category.addTarget(self, action: #selector(intentCategory), for: .touchDown)
        cityText.addTarget(self, action: #selector(intentCity), for: .touchDown)
        
//        if #available(iOS 11.0, *) {
//            navigationController?.navigationBar.prefersLargeTitles = true
//            navigationItem.largeTitleDisplayMode = .always
//            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "HelveticaNeue-Bold", size: 22)!]
//        } else {
//            // Fallback on earlier versions
//        }
        
        noItemLabel.isHidden = true
        ProviderTableView.isHidden = true
        
        //        if let flowLayout = topCatCollection as? UICollectionViewFlowLayout {
        //            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        //        }
        
        unreadMessag()
        
   
    }
    
    @objc func backingTapped() {
        let reloadPage = self.storyboard?.instantiateViewController(withIdentifier: "catPage")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = reloadPage
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getProviderList()
    }
    
    @IBAction func switchDistanceTapped(_ sender: Any) {
        if switcherIsOn == false {
            switcherIsOn = true
            self.latitude = self.lat
            self.longitude = self.lng
            slideView.isHidden = false
        }else{
            switcherIsOn = false
            self.latitude = ""
            self.longitude = ""
            slideView.isHidden = true
        }
    }
    
    @IBAction func sliderTapped(_ sender: Any) {
        variableDistLbl.text = "\(Int(slideBar.value))"
    }
    
    
// ********************************** Profile **********************************
    func getProfile(){
        let profileUrl = baseUrl + "profile"
        ServiceAPI.shared.fetchGenericData(urlString: profileUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: profileModell?, error:Error?,status:Int?) in
            
            //            print(status)
            if status == 200 {
                let profile = model?.data
                //                print(profile)
                //                print(model?.data?.name ?? "")
                
                userName = (profile?.name ?? "user name")
                userNumberRegist = profile?.phone ?? ""
                self.apptRateStatus = profile?.last_done_appt?.user_commenting_status ?? ""
                self.apptRateId = profile?.last_done_appt?.id ?? 0
                userAge = "\(profile?.age ?? 0)"
                let gender = profile?.gender ?? 1
                if gender == 1 {
                    userGender = "Male"
                }else{
                    userGender = "Female"
                }
                
                
                if self.apptRateStatus == "no-comment" {
                    self.performSegue(withIdentifier: "toRate", sender: self)
                }
            }
        }
    }
    
//***************************** get Main Category *****************************
    
    func getAllCategory() {
        loading()
        var categoryUrl = String()
        if resourceKey == "ckb" {
            categoryUrl = "http://umaass.com/api/categories?lang=ku"
        }else{
            categoryUrl = "http://umaass.com/api/categories?lang=" + resourceKey
        }
        print(categoryUrl)
        ServiceAPI.shared.fetchGenericData(urlString: categoryUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: categoryModel?, error:Error?,status:Int?) in
            //            print(categoryUrl)
            //            print(status)
            self.dismissLoding()
            if status == 200 {
                self.categoryList = model?.data ?? []
                print(self.categoryList)
                
                setMessageLanguageData(&allCategory, key: "all")
                self.categoryList.insert(categoryData(id: 0, name: allCategory, image: nil), at: 0)
                
                self.categoryCollectionView.reloadData()
            }else{
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                self.displayAlertMsg(userMsg: someThingWentWrong)
            }
        }
    }
    
//***************************** get Cities *****************************
    func getCities() {
        loading()
        let cityUrl = baseUrl + "cities"
        //        print(cityUrl)
        ServiceAPI.shared.fetchGenericData(urlString: cityUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: cityModel?, error:Error?,status:Int?) in
            self.dismissLoding()
            //            print(status)
            if status == 200 {
                self.cityList = model?.data ?? []
                //                print(self.cityList)
            }else{
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                self.displayAlertMsg(userMsg: someThingWentWrong)
            }
        }
    }
    
    // ******************************** Collection *************************************
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let catCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as! CategoryCollectionViewCell
        cornerLabel(label: catCell.catNameLabel, cornerValue: 6.0, maskToBounds: true)
        catCell.catNameLabel.text = self.categoryList[indexPath.row].name ?? ""
        return catCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.providerName = ""
        if indexPath.row == 0 {
            selectedCatId = ""
            self.getProviderList()
            self.navigationItem.title = "Category Expertise"
        }else{
            selectedCatId = "\(self.categoryList[indexPath.row].id ?? 1)"
            print(selectedCatId!)
            self.getProviderList()
            selectedCategoryName = self.categoryList[indexPath.row].name ?? ""
            self.navigationItem.title = selectedCategoryName ?? "Category Expertise"
        }
    }
    
    // auto resize coolection size --------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let catTitle = self.categoryList[indexPath.row].name{
            let size = CGSize(width: 250, height: 32)
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 14.0)!]
            let estimatedFrame = NSString(string: catTitle).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            return CGSize(width: estimatedFrame.width + 40, height: 32)
        }
        return CGSize(width: 200, height: 32)
    }
    
    
//***************************** get Doctor List *******************************
    func getProviderList(){
        loading()
        let providersUrl = baseCustomerUrl + "providers?page=1"
        let providersParam : Parameters = [
            "category_id"     : selectedCatId ?? "",
            "city_id"         : selectedCityId ?? "",
            "country_id"      : selectCountryId ?? "" ,
            "favorites"       : "",
            "lat"             : latitude ?? "",
            "lng"             : longitude ?? "",
            "distance_limit"  : variableDistLbl.text ?? "",
            "by_distance"     : switcherIsOn ?? false,
            "q"               : self.providerName ?? ""
        ]
        
        print(providersUrl)
        print(providersParam)
        ServiceAPI.shared.fetchGenericData(urlString: providersUrl, parameters: providersParam, methodInput: .get, isHeaders: true) { (model: ProvidersModel?, error:Error?,status:Int?) in
            
            //            print(status)
            self.dismissLoding()
            if status == 200 {
                self.providerList = model?.data ?? []
                print(self.providerList)
                if self.providerList.count > 0 {
                    self.noItemLabel.isHidden = true
                    self.ProviderTableView.isHidden = false
                    self.ProviderTableView.reloadData()
                }else{
                    self.noItemLabel.isHidden = false
                    self.ProviderTableView.isHidden = true
                }
            }else if status == 401 || status == 404 {
                //                let message = swiftyJsonVar["message"].string
                
                setMessageLanguageData(&unacouticated, key: "Unauthenticated! Please logOut and login again")
                self.displayAlertMsg(userMsg: unacouticated)
            }
            else if status == 500 {
                setMessageLanguageData(&wrongAccess, key: "Wrong access token")
                self.displayAlertMsg(userMsg: wrongAccess)
            }else{
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                let message = swiftyJsonVar["message"].string
                self.displayAlertMsg(userMsg: message ?? someThingWentWrong)
            }
        }
    }
    
    var i : Int = 2
    func loadMoreProvider(){
        let providersUrl = baseCustomerUrl + "providers?page=" + "\(i)"
        let providersParam : Parameters = [
            "category_id"     : selectedCatId ?? "",
            "city_id"         : selectedCityId ?? "",
             "country_id"      : selectCountryId ?? "" ,
            "favorites"       : "",
            "lat"             : latitude ?? "",
            "lng"             : longitude ?? "",
            "distance_limit"  : variableDistLbl.text ?? "",
            "by_distance"     : switcherIsOn ?? false,
            "q"               : self.providerName ?? ""
        ]
        ServiceAPI.shared.fetchGenericData(urlString: providersUrl, parameters: providersParam, methodInput: .get, isHeaders: true) { (model: ProvidersModel?, error:Error?,status:Int?) in
            self.dismissLoding()
            if status == 200 {
                self.moreProviderList = model?.data ?? []
                if self.moreProviderList.count > 0 {
                    for i in 0..<self.moreProviderList.count {
                        self.providerList.append(self.moreProviderList[i])
                    }
                    self.i = self.i + 1
                    self.ProviderTableView.reloadData()
                }
            }else if status == 401 || status == 404 {
                setMessageLanguageData(&unacouticated, key: "Unauthenticated! Please logOut and login again")
                self.displayAlertMsg(userMsg: unacouticated)
            }
            else if status == 500 {
                setMessageLanguageData(&wrongAccess, key: "Wrong access token")
                self.displayAlertMsg(userMsg: wrongAccess)
            }else{
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                let message = swiftyJsonVar["message"].string
                self.displayAlertMsg(userMsg: message ?? someThingWentWrong)
            }
        }
    }
    // ************************************ Doctors Table *************************
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.providerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let providerCell = tableView.dequeueReusableCell(withIdentifier: "ProviderTableCell", for: indexPath) as! ProviderTableViewCell
        providerCell.provideCellDelegate = self
        
        if (indexPath.row) % 2 == 0 {
            providerCell.providerListMainView.backgroundColor = .white
        }else{
            providerCell.providerListMainView.backgroundColor = lightGreen
        }
        
        providerCell.providerNameLabel.text = self.providerList[indexPath.row].name ?? ""
        providerCell.firstExistApptLabel.text = self.providerList[indexPath.row].first_exists_appt ?? "\(Date())"
        providerCell.providerViewsLabel.text = "\(self.providerList[indexPath.row].visits ?? 0)"
        providerCell.distanceLabel.text = self.providerList[indexPath.row].distance ?? ""
        providerCell.expertiesLAbel.text = self.providerList[indexPath.row].industry_title ?? ""
        
        let rateNum = self.providerList[indexPath.row].rate ?? 1.0
        print(rateNum)
        providerCell.rateView.rating = Double(rateNum)
        
        
        getImage(urlStr: (self.providerList[indexPath.row].avatar?.url_sm ?? ""), img: providerCell.providerImage)
        
//        let imageUrl = self.providerList[indexPath.row].avatar?.url_sm ?? ""
//        let url = NSURL(string: imageUrl)
//        if url != nil {
//            providerCell.providerImage.af_setImage(withURL: url! as URL, placeholderImage: UIImage(named: "user.png"), filter: nil, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
//        }else{
//            providerCell.providerImage.image = UIImage(named: "user.png")
//        }
        
        
        if self.providerList[indexPath.row].is_favorited == 0 {
            providerCell.markBtnOtlet.setImage(unMarkIcon, for: .normal)
        }else{
            providerCell.markBtnOtlet.setImage(markIcon, for: .normal)
        }
        
        if indexPath.row == self.providerList.count - 1{
            self.loadMoreProvider()
        }
        
        return providerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
    
    func BookingApptCell(cell: UITableViewCell) {
        let index = self.ProviderTableView.indexPath(for: cell)
        print(index?.row ?? "")
        selectedProviderId = self.providerList[(index?.row)!].id ?? 1
        staffId = selectedProviderId
        providerAvatar = self.providerList[(index?.row)!].avatar?.url_sm ?? ""
        performSegue(withIdentifier: "toDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails"{
            let destVC = segue.destination as! ProviderDetailsVC
            destVC.passedProviderId = selectedProviderId
        }
        if segue.identifier == "toRate"{
            let destVC = segue.destination as! RatingVC
            destVC.passedApptRateId = apptRateId
        }
    }
    
    func markeAppointment(cell: UITableViewCell) {
        
        if accessToken == "" {
               let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
               self.present(destVC, animated: false, completion: nil)
               return
           }
        
        
        let index = ProviderTableView.indexPath(for: cell)!
        //        print(index.row)
        
        let cell = ProviderTableView.cellForRow(at: IndexPath(row: (index.row), section: 0)) as! ProviderTableViewCell
        isFavorited = self.providerList[index.row].is_favorited ?? 0
        //        print(isFavorited)
        favoriteProviderId = self.providerList[index.row].id ?? 1
        //        print(favoriteProviderId)
        
        if isFavorited == 0 {
            isFavorited = 1
            cell.markBtnOtlet.setImage(markIcon, for: .normal)
            self.favoriteAppt()
        }else{
            isFavorited = 0
            cell.markBtnOtlet.setImage(unMarkIcon, for: .normal)
            self.unFavoriteAppt()
        }
    }
    
    func favoriteAppt(){
        loading()
        let favoriteUrl = baseCustomerUrl + "providers/" + "\(favoriteProviderId ?? 1)" + "/favorite"
        //        print(favoriteUrl)
        ServiceAPI.shared.fetchGenericData(urlString: favoriteUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: MessageModel?, error:Error?,status:Int?) in
            self.dismissLoding()
            //            print(status)
            if status == 200 {
                setMessageLanguageData(&favoritedd, key: "Successfully favorite")
                self.displaySuccessMsg(userMsg: favoritedd)
                
            }else{
                let errorMessage = model?.data?.message ?? "someThing went wrong!"
                self.displayAlertMsg(userMsg: errorMessage)
            }
        }
    }
    
    func unFavoriteAppt(){
        loading()
        let unfavoriteUrl = baseCustomerUrl + "providers/" + "\(favoriteProviderId ?? 1)" + "/unfavorite"
        //        print(unfavoriteUrl)
        ServiceAPI.shared.fetchGenericData(urlString: unfavoriteUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: MessageModel?, error:Error?,status:Int?) in
            
            self.dismissLoding()
            if status == 200 {
                setMessageLanguageData(&unfavoritedd, key: "Successfully Unfavorite")
                self.displaySuccessMsg(userMsg: unfavoritedd)
                
            }else{
                let errorMessage = model?.data?.message ?? "someThing went wrong!"
                self.displayAlertMsg(userMsg: errorMessage)
            }
        }
    }
    
// ---------------------------------- setUpNavBarButton -----------------------------------
    func setUpNavBarButton(){
        
//        let button = UIButton.init(type: .custom)
//        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 50)
//        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 50)
//        heightConstraint.isActive = true
//        widthConstraint.isActive = true
//        button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
//        cornerButton(button: button, cornerValue: 6.0, maskToBounds: true)
//        button.setImage(UIImage.init(named: "umaassIcon.png"), for: UIControl.State.normal)
//        let logoImg = UIBarButtonItem.init(customView: button)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
        button.setTitle(setMessage(key: "filters"), for: .normal)
        button.backgroundColor = greenColor
        button.layer.cornerRadius = 6.0
        button.layer.masksToBounds = true
           button.setTitleColor(.white, for: .normal)
  
           button.addTarget(self, action: #selector(HomeVC.filteringTapped), for: .touchUpInside)

        
        let filterButton = UIBarButtonItem(title: setMessage(key: "filters"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(HomeVC.filteringTapped))
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
      
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(HomeVC.searchTextBox))
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        var backBtn = UIBarButtonItem()
        if resourceKey == "en" {
            backBtn = UIBarButtonItem(image : UIImage (named: "backk.png"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(HomeVC.backingTapped))
            self.navigationController?.navigationBar.tintColor = UIColor.black
//            navigationItem.leftBarButtonItem = backBtn
        }else{
            backBtn = UIBarButtonItem(image : UIImage (named: "rightbackk.png"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(HomeVC.backingTapped))
            self.navigationController?.navigationBar.tintColor = UIColor.black
//            navigationItem.leftBarButtonItem = backBtn
        }
        
        self.navigationItem.setLeftBarButtonItems([backBtn , searchButton], animated: true)
    }
    
    @objc func filteringTapped() {
        popAnimationIn(popView: filterView)
    }
    @objc func searchTextBox() {
        
        setMessageLanguageData(&provName, key: "Provider Name")
        setMessageLanguageData(&searchProvName, key: "Search your provider")
        setMessageLanguageData(&cancell, key: "Cancel")
        setMessageLanguageData(&msgOk, key: "Ok")
        
        alertcontroller = UIAlertController(title: provName, message: searchProvName , preferredStyle: .alert)
        let alertAction = UIAlertAction(title: cancell, style: .default) { (action) in
        }
        alertcontroller?.addAction(alertAction)
        alertcontroller?.addTextField(configurationHandler: { (textField) in
            setTextHintLanguageData(text: textField, key: "enter your provider name")
            textField.textAlignment = .center
            let alertActionForTextField = UIAlertAction(title: msgOk, style: .default, handler: { (action) in
                if let textField = self.alertcontroller?.textFields{
                    let theTextField = textField
                    self.providerName = theTextField[0].text!
                    //                    print("providerName:",self.providerName)
                    self.getProviderList()
                    
                }
            })
            self.alertcontroller?.addAction(alertActionForTextField)
        })
        present(alertcontroller!, animated: true, completion: nil)
        //        let titleFont = [NSAttributedString.Key.font: UIFont(name: "IRANSansWeb", size: 14.0)!]
        //        let messageFont = [NSAttributedString.Key.font: UIFont(name: "IRANSansWeb", size: 12.0)!]
        //        let titleAttrString = NSMutableAttributedString(string: "نام تیم", attributes: titleFont)
        //        let messageAttrString = NSMutableAttributedString(string: "برای تیم خود یک اسم انتخاب کنید", attributes: messageFont)
        //        alertcontroller?.setValue(titleAttrString, forKey: "attributedTitle")
        //        alertcontroller?.setValue(messageAttrString, forKey: "attributedMessage")
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        popAnimateOut(popView: filterView)
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        self.getProviderList()
        popAnimateOut(popView: filterView)
    }
    
    @IBAction func clearFilterTapped(_ sender: Any) {
        self.latitude = ""
        self.longitude = ""
        selectedCityId = ""
        selectCountryId = ""
        
        self.cityText.text = ""
        self.variableDistLbl.text = ""
        switchDist.isOn = false
        slideView.isHidden = true
        popAnimateOut(popView: filterView)
        getProviderList()
    }
    
    
// ************************************ Picker *************************************
    
    func createCityPicker(){
        cityPicker.delegate = self
        cityPicker.dataSource = self
        cityPicker.backgroundColor = .lightGray
        cityText.inputView = cityPicker
        cityText.inputAccessoryView = cityToolBar
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == cityPicker {
            return 1
        }
        
        return 1
    }
// -------------------------------------------------------------------
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == cityPicker {
            return cityList.count
        }
        return 1
    }
    
// --------------------------------------------------------------------
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cityPicker {
            return cityList[row].name
        }
        return ""
    }
    
// --------------------------------------------------------------------
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == cityPicker {
            selectedCityId = "\(cityList[row].id ?? 1)"
            cityText.text = cityList[row].name ?? ""
        }
    }
    
//********************************* ToolBar PickerView **************************
    
    func createCarToolBar(){
        cityToolBar.sizeToFit()
        setMessageLanguageData(&done, key: "Done")
        let doneButton = UIBarButtonItem(title: done, style: .plain, target: self, action: #selector(dismissKeyboard))
        cityToolBar.setItems([doneButton], animated: false)
        cityToolBar.isUserInteractionEnabled = true
        cityToolBar.backgroundColor = .lightGray
        cityToolBar.tintColor = .black
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
        //        lable.font = UIFont.fontClanPro_Medium()
        if pickerView == cityPicker {
            lable.text = cityList[row].name ?? ""
        }
        return lable
    }
    
    @objc func dismissKeyboard(){
        filterView.endEditing(true)
    }
    
// *********************************** hide keyboard ****************************************
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.filterView.endEditing(true)
        self.view.endEditing(true)
    }
    
    
    
// -------------------------------- Animation -------------------------------
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
        
        let myAlert = UIAlertController(title: successfullyDone ,message: userMsg, preferredStyle: UIAlertController.Style.alert)
        let okAction = (UIAlertAction(title: msgOk, style: .default, handler: { action in
            self.getProviderList()
            //            self.navigationController?.popViewController(animated: true)
        }))
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil);
    }
    
    
// ******************* current location *************************
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while get location\(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        //        print("Latitude : \(userLocation!.coordinate.latitude)")
        //        print("Longitude : \(userLocation!.coordinate.longitude)")
        
        self.lat = "\(userLocation!.coordinate.latitude)"
        self.lng = "\(userLocation!.coordinate.longitude)"
        
        locationManager.stopUpdatingLocation()
    }
    
}

extension HomeVC :DelegateCity,DelegateCountry,DelegateCategory {
    
    
    @objc
    func intentCity(){
        if countryId == nil {
            displayAlertMsg(userMsg: setMessage(key: "Please first select the country"))
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCCity") as! VCCity
            vc.id = countryId ?? 0
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc
    func intentCountry(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCCountry") as! VCCountry
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc
    func intentCategory()  {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCCategory") as! VCCategory
          vc.delegate = self
          self.present(vc, animated: true, completion: nil)
    }
    
    func country(country: ProvineData) {
        textField_Country.text = country.name ?? ""
        countryId = country.id ?? 0
        selectCountryId = "\(country.id ?? 0)"
    }
    
    func city(model: CityData) {
        if countryId == 0 {
            displayAlertMsg(userMsg: setMessage(key: "Please first select the country"))
            return
        }
        cityText.text = model.name ?? ""
        selectedCityId = "\(model.id ?? 0)"
    }
    
    func category(category: categoryData) {
        selectedCatId = "\(category.id ?? 0)"
        textField_Category.text = category.name ?? ""
    }
    
    func unreadMessag()  {
            
            ServiceAPI.shared.fetchGenericData(urlString: baseUrl+"notifications?unread",parameters: [:], methodInput: .get, isHeaders: true) {(model:ModelNotificationMessage?, error:Error?,status:Int?) in
                
                if model?.data?.count  ?? 0 > 0 {
                    let model = model?.data?.filter {$0.app == "Customer" && !$0.read!}
                    UserDefaults.standard.setMessageCount(value: model?.count ?? 0)
                }
                
            }
            
        }
    
}



var providerAvatar : String?

