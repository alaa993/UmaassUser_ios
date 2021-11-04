//
//  Profile.swift
//  Umaass
//
//  Created by Hesam on 7/10/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import Foundation
struct AvatarModel : Codable {
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

struct LastDoneAppt : Codable {
    let id : Int?
    let user_commenting_status : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case user_commenting_status = "user_commenting_status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        user_commenting_status = try values.decodeIfPresent(String.self, forKey: .user_commenting_status)
    }
    
}


import Foundation
struct profileData : Codable {
    let id : Int?
    let name : String?
    let birthdate : String?
    let age : Int?
    let gender : Int?
    let description : String?
    let phone : String?
    let email : String?
    let avatar : AvatarModel?
    let last_done_appt : LastDoneAppt?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case birthdate = "birthdate"
        case age = "age"
        case gender = "gender"
        case description = "description"
        case phone = "phone"
        case email = "email"
        case avatar = "avatar"
        case last_done_appt = "last_done_appt"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        birthdate = try values.decodeIfPresent(String.self, forKey: .birthdate)
        age = try values.decodeIfPresent(Int.self, forKey: .age)
        gender = try values.decodeIfPresent(Int.self, forKey: .gender)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        avatar = try values.decodeIfPresent(AvatarModel.self, forKey: .avatar)
        last_done_appt = try values.decodeIfPresent(LastDoneAppt.self, forKey: .last_done_appt)
    }
}


import Foundation
struct profileModell : Codable {
    let data : profileData?
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(profileData.self, forKey: .data)
    }
    
}
