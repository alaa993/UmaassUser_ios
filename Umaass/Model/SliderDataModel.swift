//
//  SliderDataModel.swift
//  Umaass
//
//  Created by Hesam on 8/11/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import Foundation

struct SliderImage : Codable {
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


struct SliderData : Codable {
    let title : String?
    let url : String?
    let description : String?
    let image : SliderImage?
    
    enum CodingKeys: String, CodingKey {
        
        case title = "title"
        case url = "url"
        case description = "description"
        case image = "image"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        image = try values.decodeIfPresent(SliderImage.self, forKey: .image)
    }
    
}

struct SlidersModel : Codable {
    let data : [SliderData]?
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([SliderData].self, forKey: .data)
    }
    
}
