//
//  ViewController.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension UIViewController : NVActivityIndicatorViewable {
    
    func loading(){
        setMessageLanguageData(&pleaseWait, key: "Please wait")
        let size = CGSize(width: 60, height: 60)
        startAnimating(size, message: pleaseWait, type: NVActivityIndicatorType.ballClipRotateMultiple)
    }
    func dismissLoding(){
        stopAnimating()
    }
    
}

var pleaseWait = String()

