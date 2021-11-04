//
//  CategoryModel.swift
//  Umaass
//
//  Created by Hesam on 7/10/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import Foundation

struct CategoryImages : Codable {
    let id : Int?
    let url_lg : String?
    let url_md : String?
    let url_sm : String?
    let url_xs : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case url_lg = "url_lg"
        case url_md = "url_md"
        case url_sm = "url_sm"
        case url_xs = "url_xs"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        url_lg = try values.decodeIfPresent(String.self, forKey: .url_lg)
        url_md = try values.decodeIfPresent(String.self, forKey: .url_md)
        url_sm = try values.decodeIfPresent(String.self, forKey: .url_sm)
        url_xs = try values.decodeIfPresent(String.self, forKey: .url_xs)
    }
    
    init(id: Int?, url_lg: String? , url_md: String?, url_sm: String?, url_xs: String?) {
        self.id = id
        self.url_lg = url_lg
        self.url_md = url_md
        self.url_sm = url_sm
        self.url_xs = url_xs
    }
}


struct categoryData : Codable {
    let id : Int?
    let name : String?
    let image : CategoryImages?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case image = "image"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        image = try values.decodeIfPresent(CategoryImages.self, forKey: .image)
    }
    
    init(id: Int?, name: String? , image: CategoryImages?) {
        self.id = id
        self.name = name
        self.image = image
    }
}



struct categoryModel : Codable {
    let data : [categoryData]?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([categoryData].self, forKey: .data)
    }
    
}

