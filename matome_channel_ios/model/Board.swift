//
//  Board.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/25.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import ObjectMapper

public class Board: Mappable {
    var id: Int?
    var title: String?
    var score: Int?
    var fav_count: Int?
    var res_count: Int?
    var first_comment: String?
    var thumbnail_url: String?
    var category_tree: [Category]?
    var favorite_user_ids: [Int]?
    var board_images: [BoardImage]?
    var board_websites: [BoardWebsite]?
    var comments: [Comment]?

    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        id                <- map["id"]
        title             <- map["title"]
        score             <- map["score"]
        fav_count         <- map["fav_count"]
        res_count         <- map["res_count"]
        first_comment     <- map["first_comment"]
        thumbnail_url     <- map["thumbnail_url"]
        category_tree     <- map["category_tree"]
        favorite_user_ids <- map["favorite_user_ids"]
        board_websites    <- map["websites"]
        board_images      <- map["images"]
        comments          <- map["comments"]
    }
}
