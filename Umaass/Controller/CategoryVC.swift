//
//  CategoryVC.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit


class CategoryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var slidersCollection: UICollectionView!
    
    
    var categoryList = [categoryData]()
    var catsImages   = CategoryImages?.self
    var allImage : String?
    var scrollingTimer = Timer()
    var sliders = [SliderData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    // ------------- banner view --------------
//        bannerView.adUnitID = unitId
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
        
        getAllCategory()
        getSliders()
        categoryCollection.isHidden = true
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
            print(categoryUrl)
            print(status)
            self.dismissLoding()
            if status == 200 {
                self.categoryList = model?.data ?? []
                print(self.categoryList)
                
                setMessageLanguageData(&allCategory, key: "all")
                self.categoryList.insert(categoryData(id: 0, name: allCategory, image: nil), at: 0)
                
                self.categoryCollection.isHidden = false
                self.categoryCollection.reloadData()
            }else{
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                self.displayAlertMsg(userMsg: someThingWentWrong)
            }
        }
    }
    
// ********************************* category Collection View ************************
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollection {
            return categoryList.count
        }
        if collectionView == slidersCollection {
            return sliders.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollection {
            let width = (categoryCollection.frame.width / 3) - 12
            return CGSize(width: width, height: 84)
        }
        
        if collectionView == slidersCollection {
            let width = slidersCollection.frame.width
            return CGSize(width: width, height: width / 2.4)
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoryCollection {
            return 8
        }
        return 0.1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == slidersCollection {
            return 8
        }
        return 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCollection {
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCollectionCell", for: indexPath) as! CatCollectionViewCell
            
            categoryCell.catView.layer.cornerRadius = 8.0
            categoryCell.catView.layer.masksToBounds = true
            categoryCell.catView.layer.borderColor = greenColor.cgColor
            categoryCell.catView.layer.borderWidth = 0.6
            
            categoryCell.catNameLbl.layer.cornerRadius = 6.0
            categoryCell.catNameLbl.layer.masksToBounds = true
            
            categoryCell.catNameLbl.text = self.categoryList[indexPath.row].name ?? "Category"
            
            let image = self.categoryList[indexPath.row].image?.url_sm ?? "service.png"
            getImage(urlStr: image, img: categoryCell.catIconImage)
            
            return categoryCell
        }
        
        if collectionView == slidersCollection {
            let sliderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlidersCollectionCell", for: indexPath) as! SlidersCollectionViewCell
            
            sliderCell.sliderTitleLabel.text = self.sliders[indexPath.row].title ?? ""
            sliderCell.slidersImage.topAnchor.constraint(equalTo: sliderCell.mainView.topAnchor).isActive = true
            let imageUrl = self.sliders[indexPath.row].image?.url_md ?? ""
            let url = NSURL(string: imageUrl)
            if url != nil {
                sliderCell.slidersImage.af_setImage(withURL: url! as URL, placeholderImage: UIImage(named: ""), filter: nil, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
            }else{
                sliderCell.slidersImage.image = UIImage(named: "")
            }
            
            var rowIndex = indexPath.row
            let numberOfRecord : Int = self.sliders.count - 1
            if (rowIndex < numberOfRecord) {
                rowIndex = (rowIndex + 1)
            }else{
                rowIndex = 0
            }
            scrollingTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(CategoryVC.startTimer(theTimer:)), userInfo: rowIndex, repeats: true)
            
            return sliderCell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollection {
            if indexPath.row == 0 {
                selectedCatId = ""
            }else{
                selectedCatId = "\(self.categoryList[indexPath.row].id ?? 1)"
            }
            let index : Int? = 0
            let myTabBar = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as! UITabBarController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = myTabBar
            myTabBar.selectedIndex = index!
        }
        
        if collectionView == slidersCollection {
            let sliderUrl = self.sliders[indexPath.row].url ?? ""
            if let link = URL(string: sliderUrl) {
                UIApplication.shared.open(link)
            }
        }
    }
    
    
    
//***************************** get Sliders *****************************
    func getSliders() {
        loading()
        let sliderUrl = baseUrl + "slider"
        print(sliderUrl)
        ServiceAPI.shared.fetchGenericData(urlString: sliderUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: SlidersModel?, error:Error?,status:Int?) in
            print(sliderUrl)
            print(status)
            self.dismissLoding()
            if status == 200 {
               self.sliders = model?.data ?? []
               print(self.sliders)
               self.slidersCollection.reloadData()
            }else{
                setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                self.displayAlertMsg(userMsg: someThingWentWrong)
            }
        }
    }
    
    
    
    @objc func startTimer(theTimer: Timer) {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            self.slidersCollection.scrollToItem(at: IndexPath(row: theTimer.userInfo as! Int, section: 0), at: .centeredHorizontally, animated: false)
        }, completion: nil)
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
