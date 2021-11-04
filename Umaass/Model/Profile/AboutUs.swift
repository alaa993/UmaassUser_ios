//
//  AboutUs.swift
//  Umaass
//
//  Created by Hesam on 7/10/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//


import Foundation

struct AboutUsData : Codable {
    let version  : Int?
    let active   : Int?
    let required : Int?
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case active = "active"
        case required = "required"
    }
}


struct aboutUsModel : Codable {
    let data : AboutUsData?
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(AboutUsData.self, forKey: .data)
    }
}


struct rulseAboutModel : Codable {
    let rulesdata : String?
    
    enum CodingKeys: String, CodingKey {
        case rulesdata = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rulesdata = try values.decodeIfPresent(String.self, forKey: .rulesdata)
    }
    
}
