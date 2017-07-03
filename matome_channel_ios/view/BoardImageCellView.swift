//
//  BoardImageCellView.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/07/04.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class BoardImageCellView: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    var image: Image? = nil

    func setImage(_ image: Image){
        self.image = image
        let url = URL(string: image.thumbnail_url!)
        let size = CGSize(width: 50.0, height: 50.0)
        let filter = AspectScaledToFitSizeFilter(size: size)
        self.imageView.af_setImage(withURL: url!, filter: filter )
    }
}
