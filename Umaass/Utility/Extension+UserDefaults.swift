//
//  Extension+UserDefaults.swift
//  QDorProvider
//
//  Created by Hesam on 2/25/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//


import Foundation
import UIKit

extension UserDefaults {

    enum UserDefaultsKeys:String {
    
        case MessageCount
    }

    func setMessageCount(value:Int)  {
        set(value, forKey: UserDefaultsKeys.MessageCount.rawValue)
        synchronize()
    }

    func getMessageCount() -> Int  {
        return integer(forKey: UserDefaultsKeys.MessageCount.rawValue) 
    }

}
