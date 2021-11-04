//
//  Login.swift
//  Umaass
//
//  Created by Hesam on 7/10/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import Foundation

import Foundation
struct LoginEntry : Codable {
    let id : Int?
    let fname : String?
    let lname : String?
    let phone : String?
    let email : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case fname = "fname"
        case lname = "lname"
        case phone = "phone"
        case email = "email"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        fname = try values.decodeIfPresent(String.self, forKey: .fname)
        lname = try values.decodeIfPresent(String.self, forKey: .lname)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        email = try values.decodeIfPresent(String.self, forKey: .email)
    }
    
}


import Foundation
struct LoginModel : Codable {
    let error : Int?
    let entry : LoginEntry?
    let token : String?
    
    enum CodingKeys: String, CodingKey {
        
        case error = "error"
        case entry = "entry"
        case token = "token"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decodeIfPresent(Int.self, forKey: .error)
        entry = try values.decodeIfPresent(LoginEntry.self, forKey: .entry)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
    
}
