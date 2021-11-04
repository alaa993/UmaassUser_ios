
//
//  Providers.swift
//  Umaass
//
//  Created by Hesam on 7/10/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//


import Foundation

struct ProvidersAvatar : Codable {
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
    
}

struct ProvidersLinks : Codable {
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

struct ProvidersMeta : Codable {
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

struct ProvidersData : Codable {
    let id : Int?
    let industry_id : Int?
    let user_id : Int?
    let first_exists_appt : String?
    let name : String?
    let avatar : ProvidersAvatar?
    let rate : Float?
    let visits : Int?
    let is_favorited : Int?
    let distance : String?
    let category_name : String?
    let industry_title : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case industry_id = "industry_id"
        case user_id = "user_id"
        case first_exists_appt = "first_exists_appt"
        case name = "name"
        case avatar = "avatar"
        case rate = "rate"
        case visits = "visits"
        case is_favorited = "is_favorited"
        case distance = "distance"
        case category_name = "category_name"
        case industry_title = "industry_title"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        industry_id = try values.decodeIfPresent(Int.self, forKey: .industry_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        first_exists_appt = try values.decodeIfPresent(String.self, forKey: .first_exists_appt)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        avatar = try values.decodeIfPresent(ProvidersAvatar.self, forKey: .avatar)
        rate = try values.decodeIfPresent(Float.self, forKey: .rate)
        visits = try values.decodeIfPresent(Int.self, forKey: .visits)
        is_favorited = try values.decodeIfPresent(Int.self, forKey: .is_favorited)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
        category_name = try values.decodeIfPresent(String.self, forKey: .category_name)
        industry_title = try values.decodeIfPresent(String.self, forKey: .industry_title)
    }
    
}


struct ProvidersModel : Codable {
    let data  : [ProvidersData]?
    let links : ProvidersLinks?
    let meta  : ProvidersMeta?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
        case links = "links"
        case meta = "meta"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([ProvidersData].self, forKey: .data)
        links = try values.decodeIfPresent(ProvidersLinks.self, forKey: .links)
        meta = try values.decodeIfPresent(ProvidersMeta.self, forKey: .meta)
    }
    
}
