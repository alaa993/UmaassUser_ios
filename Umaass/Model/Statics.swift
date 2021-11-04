//
//  Statics.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire
import CoreData


let googleApiKey = "AIzaSyAW8rhVu9UoawQEtRVutXqSLE9Qr__MHUI"


var msgLoginSuccefull = String()
var msgOk: String = "Ok"
var msgAlert: String = "Warrning"
var successfullyDone = String()


let msgAlertNewPassSend: String = "New password has been sent to you"
let msgConnectionToServerError: String = "Unable to communicate with the server"
let msgConnectionError: String = "No internet access"

// facebook account kit
let appID = "2278502678859504"
let accountKitClientToken = "229c29cb8b563b6af10fbb9a438ef4cb"
let accountKitAppSecret = "b65ca7b9e3568e5b15706d8293a92010"

// google advertis
let adMob = "ca-app-pub-6606021354718512~8856038341"
let unitId = "ca-app-pub-6606021354718512/3159475645"



// device token d49f9ece9f6dc94fb4a452ee46c364304eb1d30196332f97bb9dd83f94def9f8

// test "ca-app-pub-3940256099942544/2934735716"

let blueColor = UIColor(red: 86/255, green: 150/255, blue: 232/255, alpha: 1.0)

var lockedTextColor = UIColor(red: 100/255, green: 70/255, blue: 20/255, alpha: 0.4)


var tabBarIconColor = UIColor(red: 220/255, green: 150/255, blue: 15/255, alpha: 1.0)
var tabBarColor = UIColor(red: 68/255, green: 36/255, blue: 8/255, alpha: 1.0)
var offColorTranspert = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.5)
var btnColor = UIColor(red: 255/255, green: 170/255, blue: 40/255, alpha: 0.7)
var OrangeColor = UIColor(red: 255/255, green: 170/255, blue: 40/255, alpha: 1.0)

let greenColor = UIColor(red: 37/255, green: 133/255, blue: 83/255, alpha: 1.0)
var offTextColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
var gray = UIColor(red: 200/255, green: 205/255, blue: 215/255, alpha: 1.0)
let lightGreen = UIColor(red: 37/255, green: 133/255, blue: 83/255, alpha: 0.1)

let emptyParam  : Parameters = [:]
var accessToken = String()
var deviceTokenn = String()
var facebookToken = String()
var selectedCatId          : String?
var selectedCategoryName   : String?

var fromTo         : String?
var providerName   : String?
var industryName   : String?
var clientName     : String?
var clientPhone    : String?
var clientDesc     : String?
var clientGender   : Int?
var clientGendertxt: String?
var serviceId      : Int?
var staffId        : Int?
var appointmetID   : Int?
var acceptTheRules : String?

var serviceList           = [showProviderServices]()
var providerWorkingHors   = [showProviderWorkingHours]()
var imageGallery          : [showProviderGallery]?
var providerLat           : String?
var providerLng           : String?

var yes           = String()
var no           = String()

var userName = String()
var userNumberRegist = String()
var userAge = String()
var userGender = String()
//skipped, commented, no-comment
// pending, confirmed, no-show, done

let confirmIcon = UIImage(named: "confirmm")
let doneIcon = UIImage(named: "done")
let pendingIcon = UIImage(named: "pending")
let noShowIcon = UIImage(named: "notShowing")

let markIcon = UIImage(named: "mark.png")
let unMarkIcon = UIImage(named: "unmark.png")
var cellTag    = Int()

func getImage(urlStr: String, img: UIImageView) {
    let imageUrl = urlStr
    let url = NSURL(string: imageUrl)
    if url != nil {
        img.af_setImage(withURL: url! as URL, placeholderImage: UIImage(named: "user.png"), filter: nil, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
    }else{
        img.image = UIImage(named: "user.png")
    }
}


func fetchUserToken(){
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
    request.returnsObjectsAsFaults = false
    do{
        let results = try context.fetch(request)
        print(results.count)
        if (results.count) > 0 {
            for result in results as! [NSManagedObject] {
                if var token = result.value(forKey: "token") as? String {
                    token = accessToken
                    print("token: \(String(describing: accessToken))")
                }
            }
        }else{

        }
    }catch{
        //
    }
}

func setMessage(key: String)->String {
    let path = Bundle.main.path(forResource: resourceKey, ofType: "lproj")
    let bundal = Bundle.init(path: path!)
   return (bundal?.localizedString(forKey: key, value: nil, table: nil))!
}



func saveToken(token: String) {
    let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
    newUser.setValue(token, forKey: "token")
    do{
        try context.save()
        print("saved accessToken: \(String(describing: token))")
    }catch{

    }
}

func saveCategoryId(categoryId: Int) {
    let newUser = NSEntityDescription.insertNewObject(forEntityName: "Industry", into: context)
    newUser.setValue(categoryId, forKey: "categoryId")
    do{
        try context.save()
        print("saved categoryId: \(String(describing: selectedCatId))")
    }catch{

    }
}

func saveLanguage(language: String, languageCode: String) {
    let newUser = NSEntityDescription.insertNewObject(forEntityName: "Setting", into: context)
    newUser.setValue(language, forKey: "appLanguage")
    newUser.setValue(languageCode, forKey: "languageCode")
    do{
        try context.save()
        print("saved language: \(String(describing: language))")
        print("saved languageCode: \(String(describing: languageCode))")
    }catch{
        
    }
}


// 4C9773
// change language function
// Kurdish ckb  ---  English en  ---  Arabic ar

var appLang = "English"
var resourceKey = "en"

func setLabelLanguageData(label: UILabel, key: String) {
    let path = Bundle.main.path(forResource: resourceKey, ofType: "lproj")
    let bundal = Bundle.init(path: path!)
    // key ~> word in localizable.string
    label.text = bundal?.localizedString(forKey: key, value: nil, table: nil)
}

func setMessageLanguageData(_ message: inout String, key: String) {
    let path = Bundle.main.path(forResource: resourceKey, ofType: "lproj")
    let bundal = Bundle.init(path: path!)
    // key ~> word in localizable.string
    message = (bundal?.localizedString(forKey: key, value: nil, table: nil))!
}


func setButtonLanguageData(button: UIButton, key: String) {
    let path = Bundle.main.path(forResource: resourceKey, ofType: "lproj")
    let bundal = Bundle.init(path: path!)
    // key ~> word in localizable.string
    button.setTitle(bundal?.localizedString(forKey: key, value: nil, table: nil), for: .normal)
}

func setTextHintLanguageData(text: UITextField, key: String) {
    let path = Bundle.main.path(forResource: resourceKey, ofType: "lproj")
    let bundal = Bundle.init(path: path!)
    // key ~> word in localizable.string
    text.placeholder = bundal?.localizedString(forKey: key, value: nil, table: nil)
}

//func setTextHintLanguageData(textview: UITextView, key: String) {
//    let path = Bundle.main.path(forResource: resourceKey, ofType: "lproj")
//    let bundal = Bundle.init(path: path!)
//    // key ~> word in localizable.string
//    textview. = bundal?.localizedString(forKey: key, value: nil, table: nil)
//}


// ***********************************************************
var homePageTitle = String()
var bookingListPageTitle = String()
var providerPageTitle = String()
var commentsPageTitle = String()
var workingHoursPageTitle = String()
var galleryPageTitle = String()
var providerLocationPageTitle = String()
var showImagePageTitle = String()
var setDatePageTitle = String()
var userInformationPageTitle = String()
var submitAppointmentPageTitle = String()
var ratingPageTitle = String()
var myAppointmentPageTitle = String()
var appointmentDetailsPageTitle = String()
var editApptInfoPageTitle = String()
var profilePageTitle = String()
var contactusPageTitle = String()
var aboutusPageTitle = String()
var editProfilePageTitle = String()

var allCategory = String()


// token 7b6f9380577bd964d0702f6c7ff4d69f47f44ee3a6bfded40ea6ee3e9565df8e
