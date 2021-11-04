//
//  VCCategory.swift
//  QdorUser
//
//  Created by AlaanCo on 9/25/20.
//  Copyright © 2020 Hesam. All rights reserved.
//
import UIKit

protocol DelegateCategory {
    func category(category:categoryData)
}

class VCCategory: UIViewController,UISearchBarDelegate {

    @IBOutlet var lbTitleStatusBar: UILabel!
    @IBOutlet var search: UISearchBar!
    @IBOutlet var tableView: UITableView!

    var modelMain = [categoryData]()
    var model = [categoryData]()
    var modelTempSearch = [categoryData]()
    var delegate:DelegateCategory?


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        search.delegate = self
        lbTitleStatusBar.text = setMessage(key: "category")



    }

    override func viewWillAppear(_ animated: Bool) {
          getAllCategory()
    }

    @IBAction func btnClose(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        print(searchText.lowercased())

        modelTempSearch.removeAll()
        for item in model {
            if (item.name)?.lowercased().contains(searchText.lowercased()) ?? false {
                modelTempSearch.append(item)
            }
        }

        if searchText == "" {
            putModel(model: self.modelMain)
        }else {
           putModel(model: modelTempSearch)
        }

    }
    
    
    func getAllCategory() {
           loading()
           var categoryUrl = String()
           if resourceKey == "ckb" {
               categoryUrl = baseUrl + "categories?lang=ku"
           }else{
               categoryUrl = baseUrl + "categories?lang=" + resourceKey
           }
           print(categoryUrl)
           ServiceAPI.shared.fetchGenericData(urlString: categoryUrl, parameters: emptyParam, methodInput: .get, isHeaders: true) { (model: categoryModel?, error:Error?,status:Int?) in

               self.dismissLoding()
               if status == 200 {
                   self.modelMain = model?.data ?? []
                 
                   setMessageLanguageData(&allCategory, key: "all")
                self.modelMain.insert(categoryData(id: 0, name: allCategory, image: nil), at: 0)
                  self.putModel(model:self.modelMain )
                
                   self.tableView.reloadData()
               }else{
                   setMessageLanguageData(&someThingWentWrong, key: "something went wrong")
                  // self.displayAlertMsg(userMsg: someThingWentWrong)
               }
           }
       }


    func putModel(model:[categoryData]){

        self.model = model
        tableView.reloadData()

    }

}

extension VCCategory:UITableViewDataSource,UITableViewDelegate {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCategory", for: indexPath) as! CellCategory
        cell.lbNameCountry.text = model[indexPath.item].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.category(category: model[indexPath.item])
        self.dismiss(animated: true, completion: nil)
    }

}
