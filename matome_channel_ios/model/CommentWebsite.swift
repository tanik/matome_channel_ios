//
//  CommentWebsite.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/07/03.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import ObjectMapper

public class CommentWebsite: Mappable {
    var id: Int?
    var comment_id: Int?
    var website: Website?

    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        id             <- map["id"]
        comment_id     <- map["comment_id"]
        website        <- map["website"]
    }
}
