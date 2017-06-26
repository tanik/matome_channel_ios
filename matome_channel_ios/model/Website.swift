//
//  Website.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/25.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import ObjectMapper

public class Website: Mappable {
    var id: Int?
    var title: String?
    var original_url: String?
    var full_url: String?
    var thumbnail_url: String?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        id             <- map["id"]
        title          <- map["title"]
        original_url   <- map["original_url"]
        full_url       <- map["full_url"]
        thumbnail_url  <- map["thumbnail_url"]
    }
}
