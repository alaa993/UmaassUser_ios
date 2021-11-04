//
//  VCCountry.swift
//  outn
//
//  Created by AlaanCo on 2/3/20.
//  Copyright © 2020 Allan. All rights reserved.
//

import UIKit

protocol DelegateCountry {
    func country(country:ProvineData)
}

class VCCountry: UIViewController,UISearchBarDelegate {

    @IBOutlet var lbTitleStatusBar: UILabel!
    @IBOutlet var search: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var modelMain = [ProvineData]()
    var model = [ProvineData]()
    var modelTempSearch = [ProvineData]()
    var delegate:DelegateCountry?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        search.delegate = self
        lbTitleStatusBar.text = setMessage(key: "countryFilter")
        
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          getData()
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
    
    func getData()  {
        
        self.loading()
        let url = baseUrl+"provinces"
        
        ServiceAPI.shared.fetchGenericData(urlString: url, parameters: [:], methodInput: .get) { (result:ProvinceModel?,error,status)  in
            self.dismissLoding()
            if status == 200  {
                self.putModel(model: result?.data ?? [])
                self.modelMain = result?.data ?? []
                self.tableView.reloadData()
            } else {

            }

        }
        
        
    }
    
    func putModel(model:[ProvineData]){
        
        self.model = model
        tableView.reloadData()
        
    }
    
}

extension VCCountry:UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCountry", for: indexPath) as! CellCountry
        cell.lbNameCountry.text = model[indexPath.item].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        delegate?.country(country: model[indexPath.item])
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
