//
//  CommentsModel.swift
//  Umaass
//
//  Created by Hesam on 7/10/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//


import Foundation


struct commentsAvatar : Codable {
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


struct commentsLinks : Codable {
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

struct commentsMeta : Codable {
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

struct commentsData : Codable {
    let id : Int?
    let user_id : Int?
    let name : String?
    let avatar : commentsAvatar?
    let rate : Float?
    let content : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case user_id = "user_id"
        case name = "name"
        case avatar = "avatar"
        case rate = "rate"
        case content = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        avatar = try values.decodeIfPresent(commentsAvatar.self, forKey: .avatar)
        rate = try values.decodeIfPresent(Float.self, forKey: .rate)
        content = try values.decodeIfPresent(String.self, forKey: .content)
    }
    
}

struct commentsModel : Codable {
    let data : [commentsData]?
    let links : commentsLinks?
    let meta : commentsMeta?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
        case links = "links"
        case meta = "meta"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([commentsData].self, forKey: .data)
        links = try values.decodeIfPresent(commentsLinks.self, forKey: .links)
        meta = try values.decodeIfPresent(commentsMeta.self, forKey: .meta)
    }
    
}
