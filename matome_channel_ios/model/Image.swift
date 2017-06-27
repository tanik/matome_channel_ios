//
//  Image.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/25.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import ObjectMapper

public class Image: HasImageObject {
    var width: Int?
    var height: Int?
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        width          <- map["width"]
        height         <- map["height"]
    }
}
