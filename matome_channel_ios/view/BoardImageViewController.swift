//
//  BoardImageViewController.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/07/04.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import UIKit

class BoardImageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var board_images: [BoardImage] = []
    var hasMoreImages: Bool = true

    @IBOutlet weak var imageList: UICollectionView!

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageList.dataSource = self
        self.imageList.delegate = self
        self.imageList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BoardImageViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.board_images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BoardImageCellView = collectionView.dequeueReusableCell(
            withReuseIdentifier: "boardImage", for: indexPath) as! BoardImageCellView
        let image = self.board_images[indexPath.row].image!
        cell.setImage(image)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = self.board_images[indexPath.row].image!
        let url: URL = URL(string: image.full_url!)!
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}
