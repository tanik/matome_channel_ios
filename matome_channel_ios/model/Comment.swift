//
//  Comment.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/25.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import ObjectMapper

public class Comment: Mappable {
    var id: Int?
    var user_id: Int?
    var board_id: Int?
    var board: Board?
    var num: Int?
    var name: String?
    var content: String?
    var hash_id: String?
    var created_at: Date?
    var images: [Image]?
    var websites: [Website]?
    var favorite_user_ids: [Int]?
    
    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        id                <- map["id"]
        user_id           <- map["user_id"]
        board_id          <- map["board_id"]
        board             <- map["board"]
        num               <- map["num"]
        name              <- map["name"]
        content           <- map["content"]
        hash_id           <- map["hash_id"]
        created_at        <- (map["created_at"],
                              CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:SS.sssZ"))
        images            <- map["images"]
        websites          <- map["websites"]
        favorite_user_ids <- map["favorite_user_ids"]
    }
}
