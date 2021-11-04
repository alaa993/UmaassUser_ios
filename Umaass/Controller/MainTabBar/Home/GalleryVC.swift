//
//  GalleryVC.swift
//  Umaass
//
//  Created by Hesam on 7/1/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit


class GalleryVC: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var galleryCollection  : UICollectionView!
    @IBOutlet weak var noItemLbl          : UILabel!
    var imageUrl                          = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        // ------------- banner view --------------
//        bannerView.adUnitID = unitId
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())

        noItemLbl.isHidden = true
        
        setLabelLanguageData(label: noItemLbl, key: "No item")
        setMessageLanguageData(&galleryPageTitle, key: "gallery")
        navigationItem.title = galleryPageTitle
        
        
        if (imageGallery?.count ?? 0) > 0 {
            galleryCollection.isHidden = false
            noItemLbl.isHidden = true
            galleryCollection.reloadData()
        }else{
            galleryCollection.isHidden = true
            noItemLbl.isHidden = false
        }
    }
    
    // ********************************* image Collection View ************************
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (galleryCollection.frame.width / 2) - 12
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageGallery?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionCell", for: indexPath) as! GalleryCollectionViewCell
        cell.layer.cornerRadius = 6.0
        cell.layer.masksToBounds = true
        cell.galleryImg.layer.cornerRadius = 6.0
        cell.galleryImg.layer.masksToBounds = true
        cell.layer.masksToBounds = false
        
        let imageUrl = imageGallery?[indexPath.row].url_sm ?? ""
        getImage(urlStr: imageUrl, img: cell.galleryImg)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageUrl = imageGallery?[indexPath.row].url_sm ?? ""
        performSegue(withIdentifier: "toShowImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowImage"{
            let destVC = segue.destination as! ShowImagesVC
            destVC.passedImageUrl = imageUrl
        }
    }
}
