//
//  CommentImageCellView.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/26.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class CommentImageCellView: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!

    var object: HasImageObject?

    func setImage(_ obj: HasImageObject){
        object = obj
        let url = URL(string: obj.thumbnail_url!)
        let size = CGSize(width: 50.0, height: 50.0)
        let filter = AspectScaledToFitSizeFilter(size: size)
        self.image.af_setImage(withURL: url!, filter: filter )
    }
}
