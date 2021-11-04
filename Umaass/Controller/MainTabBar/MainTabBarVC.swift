//
//  MainTabBarVC.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import CoreData

class MainTabBarVC: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        setMessageLanguageData(&HomeTab, key: "home")
        tabBar.items?[0].title = HomeTab
        
        setMessageLanguageData(&BookingTab, key: "book")
        tabBar.items?[1].title = BookingTab
        
        setMessageLanguageData(&ProfileTab, key: "profile")
        tabBar.items?[2].title = ProfileTab
         delegate = self
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if tabBarController.selectedIndex == 2 || tabBarController.selectedIndex == 1 {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            request.returnsObjectsAsFaults = false
            do{
                let results = try context.fetch(request)
                print(results.count)
                if (results.count) > 0 {
                    
                }else{
                    
                    tabBarController.selectedIndex = 0
                    let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.present(destVC, animated: false, completion: nil)
                }
            }catch{
                //
            }
            
        }
    }
}

var HomeTab = String()
var BookingTab = String()
var ProfileTab = String()
