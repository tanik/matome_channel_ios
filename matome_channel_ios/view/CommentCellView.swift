//
//  CommentCellView.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/25.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class CommentCellView: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var created_at: UILabel!
    @IBOutlet weak var hash_id: UILabel!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var imageList: UICollectionView!

    var comment: Comment?
    var imageObjects: [HasImageObject] = []

    var constraintHeight: NSLayoutConstraint?

    override func layoutSubviews() {
        super.layoutSubviews()
        imageList.dataSource = self
        imageList.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(_ comment :Comment) {
        self.comment = comment
        self.num.text = comment.num?.description
        self.name.text = comment.name!
        self.content.text = comment.content!
        self.hash_id.text = "ID: \(comment.hash_id!)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
        self.created_at.text = formatter.string(for: comment.created_at)
        guard let images: [HasImageObject] = self.comment?.images else { return }
        guard let websites: [HasImageObject] = self.comment?.websites else { return }
        self.imageObjects = images + websites
        let count = self.imageObjects.count
        let height = CGFloat((count > 0) ? 50 : 0)
        if(constraintHeight != nil){
            self.imageList.removeConstraint(constraintHeight!)
        }
        constraintHeight = NSLayoutConstraint(
            item: self.imageList,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.height,
            multiplier: 1.0,
            constant: height
        )
        self.imageList.addConstraint(constraintHeight!)
        self.imageList.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.imageObjects.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CommentImageCellView = collectionView.dequeueReusableCell(
            withReuseIdentifier: "commentImage", for: indexPath) as! CommentImageCellView
        let image = self.imageObjects[indexPath.row]
        cell.setImage(image)
        return cell
    }
}
