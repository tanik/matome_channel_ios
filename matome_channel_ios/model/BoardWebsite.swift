//
//  BoardWebsite.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/26.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import ObjectMapper

public class BoardWebsite: Mappable {
    var id: Int?
    var board_id: Int?
    var website: Website?

    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        id               <- map["id"]
        board_id         <- map["board_id"]
        website          <- map["website"]
    }
}
