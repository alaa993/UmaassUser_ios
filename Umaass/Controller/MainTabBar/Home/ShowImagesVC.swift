//
//  ShowImagesVC.swift
//  Umaass
//
//  Created by Hesam on 7/1/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit

class ShowImagesVC: UIViewController, UIScrollViewDelegate {
    
    
    
    @IBOutlet weak var scrollView  : UIScrollView!
    @IBOutlet weak var img         : UIImageView!
    
    var gestureRecognizer: UITapGestureRecognizer!
    var passedImageUrl : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMessageLanguageData(&showImagePageTitle, key: "Image")
        navigationItem.title = showImagePageTitle
        getImage(urlStr: passedImageUrl ?? "", img: img)
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 8.0
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap))
        tapRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapRecognizer)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return img
    }
    
    @objc func onDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        let scale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)
        
        if scale != scrollView.zoomScale {
            let point = gestureRecognizer.location(in: img)
            let scrollSize = scrollView.frame.size
            let size = CGSize(width: scrollSize.width / scale,
                              height: scrollSize.height / scale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            scrollView.zoom(to:CGRect(origin: origin, size: size), animated: true)
            print(CGRect(origin: origin, size: size))
        }
    }
}

