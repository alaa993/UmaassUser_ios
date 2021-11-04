//
//  showProviderModel.swift
//  Umaass
//
//  Created by Hesam on 7/10/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//


import Foundation

struct showProviderAvatar : Codable {
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

struct showProviderGallery : Codable {
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

struct showProviderCategory : Codable {
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

struct showProviderImage : Codable {
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


struct showProviderIndustry : Codable {
    let id : Int?
    let title : String?
    let description : String?
    let phone : String?
    let address : String?
    let lat : String?
    let lng : String?
    let terms_and_condition : String?
    let tac_label : String?
    let image : ShowIndustryImage?
    let gallery : [showProviderGallery]?
    let category : ShowIndustryCategory?
    let working_hours : [showProviderWorkingHours]?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case title = "title"
        case description = "description"
        case phone = "phone"
        case address = "address"
        case lat = "lat"
        case lng = "lng"
        case terms_and_condition = "terms_and_condition"
        case tac_label = "tac_label"
        case image = "image"
        case gallery = "gallery"
        case category = "category"
        case working_hours = "working_hours"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        lng = try values.decodeIfPresent(String.self, forKey: .lng)
        terms_and_condition = try values.decodeIfPresent(String.self, forKey: .terms_and_condition)
        tac_label = try values.decodeIfPresent(String.self, forKey: .tac_label)
        image = try values.decodeIfPresent(ShowIndustryImage.self, forKey: .image)
        gallery = try values.decodeIfPresent([showProviderGallery].self, forKey: .gallery)
        category = try values.decodeIfPresent(ShowIndustryCategory.self, forKey: .category)
        working_hours = try values.decodeIfPresent([showProviderWorkingHours].self, forKey: .working_hours)
    }
    
    
}


struct showProviderServices : Codable {
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


struct showProviderWorkingHours : Codable {
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


struct showProviderData : Codable {
    let id : Int?
    let industry_id : Int?
    let user_id : Int?
    let rate : Float?
    let first_exists_appt : String?
    let name : String?
    let desciption : String?
    let avatar : showProviderAvatar?
    let visits : Int?
    let is_favorited : Int?
    let category_name : String?
    let services : [showProviderServices]?
    let industry : showProviderIndustry?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case industry_id = "industry_id"
        case user_id = "user_id"
        case rate = "rate"
        case first_exists_appt = "first_exists_appt"
        case name = "name"
        case desciption = "desciption"
        case avatar = "avatar"
        case visits = "visits"
        case is_favorited = "is_favorited"
        case category_name = "category_name"
        case services = "services"
        case industry = "industry"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        industry_id = try values.decodeIfPresent(Int.self, forKey: .industry_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        rate = try values.decodeIfPresent(Float.self, forKey: .rate)
        first_exists_appt = try values.decodeIfPresent(String.self, forKey: .first_exists_appt)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        desciption = try values.decodeIfPresent(String.self, forKey: .desciption)
        avatar = try values.decodeIfPresent(showProviderAvatar.self, forKey: .avatar)
        visits = try values.decodeIfPresent(Int.self, forKey: .visits)
        is_favorited = try values.decodeIfPresent(Int.self, forKey: .is_favorited)
        category_name = try values.decodeIfPresent(String.self, forKey: .category_name)
        services = try values.decodeIfPresent([showProviderServices].self, forKey: .services)
        industry = try values.decodeIfPresent(showProviderIndustry.self, forKey: .industry)
    }
    
    
    
    init(id: Int?, industry_id: Int?, user_id: Int?, rate: Float?, first_exists_appt: String?, name: String?, desciption: String?, avatar: showProviderAvatar?, visits: Int?, is_favorited: Int?, category_name: String?, services: [showProviderServices]?, industry: showProviderIndustry?) {
        self.id = id
        self.industry_id = industry_id
        self.user_id = user_id
        self.rate = rate
        self.first_exists_appt = first_exists_appt
        self.name = name
        self.desciption = desciption
        self.avatar = avatar
        self.visits = visits
        self.is_favorited = is_favorited
        self.category_name = category_name
        self.services = services
        self.industry = industry
        
    }
    
}


struct showProviderModel : Codable {
    let data : showProviderData?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(showProviderData.self, forKey: .data)
    }
    
}
