//
//  BoardWebsiteCellView.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/07/04.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class BoardWebsiteCellView: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCell(_ website :Website) {
        self.title.text = website.title
        let url = URL(string: website.thumbnail_url!)
        let size = CGSize(width: 70.0, height: 70.0)
        let filter = AspectScaledToFitSizeFilter(size: size)
        self.thumbnail.af_setImage(withURL: url!, filter: filter)
    }
}
