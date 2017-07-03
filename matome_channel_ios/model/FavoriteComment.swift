//
//  FavoriteComment.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/07/03.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import ObjectMapper

public class FavoriteComment: Mappable {
    var id: Int?
    var comment_id: Int?
    var user_id: Int?

    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        id             <- map["id"]
        comment_id     <- map["comment_id"]
        user_id        <- map["user_id"]
    }
}
