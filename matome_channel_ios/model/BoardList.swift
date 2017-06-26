//
//  BoardList.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/24.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import ObjectMapper

public class BoardList: Mappable {
    var boards: [Board]?
    var pagination: Pagination?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        boards     <- map["boards"]
        pagination <- map["pagination"]
    }
}
