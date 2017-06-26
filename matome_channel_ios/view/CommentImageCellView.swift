//
//  CommentImageCellView.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/26.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import UIKit

class CommentImageCellView: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!

    func setImage(_ image: Image){
        let url = URL(string: image.thumbnail_url!)
        self.image.af_setImage(withURL: url!)
    }
}
