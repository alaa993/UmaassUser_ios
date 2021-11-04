//
//  ExtensionDesign.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import Foundation
import UIKit

func cornerViews(view: UIView, cornerValue: Float, maskToBounds: Bool) {
    view.layer.cornerRadius = CGFloat(cornerValue)
    view.layer.masksToBounds = maskToBounds
}

func cornerLabel(label: UILabel, cornerValue: Float, maskToBounds: Bool) {
    label.layer.cornerRadius = CGFloat(cornerValue)
    label.layer.masksToBounds = maskToBounds
}

func cornerImage(image: UIImageView, cornerValue: Float, maskToBounds: Bool) {
    image.layer.cornerRadius = CGFloat(cornerValue)
    image.layer.masksToBounds = maskToBounds
}

func cornerButton(button: UIButton, cornerValue: Float, maskToBounds: Bool) {
    button.layer.cornerRadius = CGFloat(cornerValue)
    button.layer.masksToBounds = maskToBounds
}
