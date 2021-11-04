//
//  Registration.swift
//  Umaass
//
//  Created by Hesam on 7/10/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import Foundation
struct RegistrationData : Codable {
    let phone : String?
    let email : String?
    let token : String?
    
    enum CodingKeys: String, CodingKey {
        case phone = "phone"
        case email = "email"
        case token = "token"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
}

struct RegistrationModel : Codable {
    let data : RegistrationData?
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(RegistrationData.self, forKey: .data)
    }
    
}
