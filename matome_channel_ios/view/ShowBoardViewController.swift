//
//  ShowBoardViewController.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/25.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import UIKit

class ShowBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var board: Board?
    var comments: [Comment]?

    @IBOutlet weak var commentList: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.title = board?.title
        // Do any additional setup after loading the view, typically from a nib.
        commentList.estimatedRowHeight = 90
        commentList.rowHeight = UITableViewAutomaticDimension
        getBoard()
        commentList.dataSource = self
        commentList.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBoard(){
        guard let board_id = board?.id else {
            print("getBoard: board_id is nil")
            return
        }
        MatomeChannelAPI().getBoard(board_id, success: { (board: Board) in
            self.board = board
            self.comments = board.comments
            self.commentList.reloadData()
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = comments?.count else{
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentCellView = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath as IndexPath) as! CommentCellView
        guard let comment = self.board?.comments?[indexPath.row] else {
            print("comment not found")
            return cell
        }
        cell.setCell(comment)
        return cell
        
    }


}
