//
//  AllIndustry.swift
//  Umaass
//
//  Created by Hesam on 7/10/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import Foundation

struct AllIndustryLinks : Codable {
    let first : String?
    let last : String?
    let prev : String?
    let next : String?
    
    enum CodingKeys: String, CodingKey {
        
        case first = "first"
        case last = "last"
        case prev = "prev"
        case next = "next"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        first = try values.decodeIfPresent(String.self, forKey: .first)
        last = try values.decodeIfPresent(String.self, forKey: .last)
        prev = try values.decodeIfPresent(String.self, forKey: .prev)
        next = try values.decodeIfPresent(String.self, forKey: .next)
    }
    
}
struct AllIndustryMeta : Codable {
    let current_page : Int?
    let from : Int?
    let last_page : Int?
    let path : String?
    let per_page : Int?
    let to : Int?
    let total : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case current_page = "current_page"
        case from = "from"
        case last_page = "last_page"
        case path = "path"
        case per_page = "per_page"
        case to = "to"
        case total = "total"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        current_page = try values.decodeIfPresent(Int.self, forKey: .current_page)
        from = try values.decodeIfPresent(Int.self, forKey: .from)
        last_page = try values.decodeIfPresent(Int.self, forKey: .last_page)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        per_page = try values.decodeIfPresent(Int.self, forKey: .per_page)
        to = try values.decodeIfPresent(Int.self, forKey: .to)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }
    
}

struct AllIndustryData : Codable {
    let id : Int?
    let title : String?
    let phone : String?
    let description : String?
    let address : String?
    let lat : Int?
    let lng : Int?
    let distance : String?
    let service_label : String?
    let service_avg_time : Int?
    let terms_and_condition : String?
    let tac_label : String?
    let is_active : Int?
    let visits : Int?
    let is_favorited : Int?
    let image : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case title = "title"
        case phone = "phone"
        case description = "description"
        case address = "address"
        case lat = "lat"
        case lng = "lng"
        case distance = "distance"
        case service_label = "service_label"
        case service_avg_time = "service_avg_time"
        case terms_and_condition = "terms_and_condition"
        case tac_label = "tac_label"
        case is_active = "is_active"
        case visits = "visits"
        case is_favorited = "is_favorited"
        case image = "image"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        lat = try values.decodeIfPresent(Int.self, forKey: .lat)
        lng = try values.decodeIfPresent(Int.self, forKey: .lng)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
        service_label = try values.decodeIfPresent(String.self, forKey: .service_label)
        service_avg_time = try values.decodeIfPresent(Int.self, forKey: .service_avg_time)
        terms_and_condition = try values.decodeIfPresent(String.self, forKey: .terms_and_condition)
        tac_label = try values.decodeIfPresent(String.self, forKey: .tac_label)
        is_active = try values.decodeIfPresent(Int.self, forKey: .is_active)
        visits = try values.decodeIfPresent(Int.self, forKey: .visits)
        is_favorited = try values.decodeIfPresent(Int.self, forKey: .is_favorited)
        image = try values.decodeIfPresent(String.self, forKey: .image)
    }
    
}

struct AllIndustryModel : Codable {
    let data : [AllIndustryData]?
    let links : AllIndustryLinks?
    let meta : AllIndustryMeta?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
        case links = "links"
        case meta = "meta"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([AllIndustryData].self, forKey: .data)
        links = try values.decodeIfPresent(AllIndustryLinks.self, forKey: .links)
        meta = try values.decodeIfPresent(AllIndustryMeta.self, forKey: .meta)
    }
    
}
