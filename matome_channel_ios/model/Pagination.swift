//
//  Pagination.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/25.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import ObjectMapper

public class Pagination: Mappable {
    var total: Int?
    var current: Int?
    var next: Int?
    var prev: Int?
    var per: Int?
    
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        total   <- map["total"]
        current <- map["current"]
        next    <- map["next"]
        prev    <- map["prev"]
        per     <- map["per"]
    }
}
