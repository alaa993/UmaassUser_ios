//
//  ModelNotificationMessage.swift
//  SnabulProvider
//
//  Created by kavos khajavi on 11/5/20.
//  Copyright © 2020 Hesam. All rights reserved.
//

import Foundation
struct ModelNotificationMessage : Codable {
    let data : [DataNotification]?

    enum CodingKeys: String, CodingKey {

        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([DataNotification].self, forKey: .data)
    }

}


struct DataNotification : Codable {
    let id : String?
    let title : String?
    let message : String?
    let read : Bool?
    let created_at : String?
    let app : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case message = "message"
        case read = "read"
        case created_at = "created_at"
        case app = "app"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        read = try values.decodeIfPresent(Bool.self, forKey: .read)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        app = try values.decodeIfPresent(String.self, forKey: .app)
    }

}
