
//
//  showIndustryModel.swift
//  Umaass
//
//  Created by Hesam on 7/10/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import Foundation

struct ShowIndustryAvatar : Codable {
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

struct ShowIndustryCategory : Codable {
    let id : Int?
    let name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    
}


struct ShowIndustryGallery : Codable {
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

struct ShowIndustryImage : Codable {
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

struct ShowIndustryServices : Codable {
    let id : Int?
    let industry_id : Int?
    let title : String?
    let duration : Int?
    let price : Int?
    let notes_for_the_customer : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case industry_id = "industry_id"
        case title = "title"
        case duration = "duration"
        case price = "price"
        case notes_for_the_customer = "notes_for_the_customer"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        industry_id = try values.decodeIfPresent(Int.self, forKey: .industry_id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
        price = try values.decodeIfPresent(Int.self, forKey: .price)
        notes_for_the_customer = try values.decodeIfPresent(String.self, forKey: .notes_for_the_customer)
    }
    
}

struct ShowIndustryStaff : Codable {
    let id : Int?
    let industry_id : Int?
    let user_id : Int?
    let role : String?
    let name : String?
    let phone : String?
    let email : String?
    let avatar : ShowIndustryAvatar?
    let permissions : [Int]?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case industry_id = "industry_id"
        case user_id = "user_id"
        case role = "role"
        case name = "name"
        case phone = "phone"
        case email = "email"
        case avatar = "avatar"
        case permissions = "permissions"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        industry_id = try values.decodeIfPresent(Int.self, forKey: .industry_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        role = try values.decodeIfPresent(String.self, forKey: .role)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        avatar = try values.decodeIfPresent(ShowIndustryAvatar.self, forKey: .avatar)
        permissions = try values.decodeIfPresent([Int].self, forKey: .permissions)
    }
    
}

struct ShowIndustryWorkingHours : Codable {
    let day : Int?
    let start : String?
    let end : String?
    
    enum CodingKeys: String, CodingKey {
        
        case day = "day"
        case start = "start"
        case end = "end"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        day = try values.decodeIfPresent(Int.self, forKey: .day)
        start = try values.decodeIfPresent(String.self, forKey: .start)
        end = try values.decodeIfPresent(String.self, forKey: .end)
    }
    
}

struct ShowIndustryData : Codable {
    let id : Int?
    let title : String?
    let description : String?
    let phone : String?
    let address : String?
    let lat : Int?
    let lng : Int?
    let distance : String?
    let terms_and_condition : String?
    let tac_label : String?
    let is_favorited : Int?
    let image : ShowIndustryImage?
    let gallery : [ShowIndustryGallery]?
    let category : ShowIndustryCategory?
    let working_hours : [ShowIndustryWorkingHours]?
    let staff : [ShowIndustryStaff]?
    let services : [ShowIndustryServices]?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case title = "title"
        case description = "description"
        case phone = "phone"
        case address = "address"
        case lat = "lat"
        case lng = "lng"
        case distance = "distance"
        case terms_and_condition = "terms_and_condition"
        case tac_label = "tac_label"
        case is_favorited = "is_favorited"
        case image = "image"
        case gallery = "gallery"
        case category = "category"
        case working_hours = "working_hours"
        case staff = "staff"
        case services = "services"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        lat = try values.decodeIfPresent(Int.self, forKey: .lat)
        lng = try values.decodeIfPresent(Int.self, forKey: .lng)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
        terms_and_condition = try values.decodeIfPresent(String.self, forKey: .terms_and_condition)
        tac_label = try values.decodeIfPresent(String.self, forKey: .tac_label)
        is_favorited = try values.decodeIfPresent(Int.self, forKey: .is_favorited)
        image = try values.decodeIfPresent(ShowIndustryImage.self, forKey: .image)
        gallery = try values.decodeIfPresent([ShowIndustryGallery].self, forKey: .gallery)
        category = try values.decodeIfPresent(ShowIndustryCategory.self, forKey: .category)
        working_hours = try values.decodeIfPresent([ShowIndustryWorkingHours].self, forKey: .working_hours)
        staff = try values.decodeIfPresent([ShowIndustryStaff].self, forKey: .staff)
        services = try values.decodeIfPresent([ShowIndustryServices].self, forKey: .services)
    }
    
}

struct ShowIndustryModel : Codable {
    let data : [ShowIndustryData]?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([ShowIndustryData].self, forKey: .data)
    }
    
}
