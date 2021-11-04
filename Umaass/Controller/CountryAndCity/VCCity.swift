//
//  VCCity.swift
//  outn
//
//  Created by kavos khajavi on 2/4/20.
//  Copyright © 2020 Allan. All rights reserved.
//

import UIKit

protocol DelegateCity {
    func city(model:CityData)
}

class VCCity: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var lbTitleStatusBar: UILabel!

    var delegate:DelegateCity?
    var modelSearch = [CityData]()
    var modelTemp = [CityData]()
    var model = [CityData]()
    var id:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        search.delegate = self

        lbTitleStatusBar.text = setMessage(key: "City")
        getData(id: id)


    }


    @IBAction func actionClose(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

               modelTemp.removeAll()
               for item in modelSearch {
                   if (item.name)?.lowercased().contains(searchText.lowercased()) ?? false {
                       modelTemp.append(item)
                   }
               }

               if searchText == "" {
                   putModel(model: modelSearch)
               }else {
                  putModel(model: modelTemp)
               }
    }

    func putModel(model:[CityData])  {

        self.model = model
        self.tableView.reloadData()

    }


    func getData(id:Int)  {

        self.loading()
        let url = baseUrl + "cities?province_id=\(id)"
         ServiceAPI.shared.fetchGenericData(urlString:url, parameters: [:], methodInput: .get) { (result:cityModel?,error,status) in
            self.dismissLoding()
                 if status == 200  {
                    self.putModel(model:result?.data ?? [])
                    self.modelSearch = result?.data ?? []
                    self.tableView.reloadData()

                 }
         }
     }
}

extension VCCity:UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCity", for: indexPath) as! CellCity
        cell.lbNameCity.text = model[indexPath.item].name ?? ""
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.city(model: model[indexPath.item])
        self.dismiss(animated: true, completion: nil)
    }


}
