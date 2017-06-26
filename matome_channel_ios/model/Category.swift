//
//  Category.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/25.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import ObjectMapper

public class Category: Mappable {
    var id: Int?
    var name: String?
    var parent_id: Int?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        id            <- map["id"]
        name          <- map["name"]
        parent_id     <- map["parent_id"]
    }
}
