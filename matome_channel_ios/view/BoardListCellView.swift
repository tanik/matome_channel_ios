//
//  BoardListCellView.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/24.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class BoardListCellView: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var first_comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCell(_ board :Board) {
        self.title.text = board.title
        self.first_comment.text = board.first_comment
        let url = URL(string: board.thumbnail_url!)
        let size = CGSize(width: 50.0, height: 50.0)
        let filter = AspectScaledToFitSizeFilter(size: size)
        self.thumbnail.af_setImage(withURL: url!, filter: filter)
    }
}
