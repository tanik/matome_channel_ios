//
//  ShowBoardViewController.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/25.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import UIKit
import ActionCableClient
import SwiftyJSON
import ObjectMapper

class ShowBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var board: Board?
    var comments: [Comment] = []
    var hasMoreComments: Bool = true
    var cable: ActionCableClient?
    var boardChannel: Channel?

    @IBOutlet weak var commentList: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!

    @IBAction func back(_ sender: Any) {
        self.boardChannel?.unsubscribe()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func refresh(_ sender: Any) {
        getBoard()
        /*
        guard let board_id = board?.id else { return }
        guard let gt_id = comments?.first?.id else { return }
        MatomeChannelAPI().getBoardComments(board_id, gt_id: gt_id, success: { (comments: [Comment]) in
            self.comments = comments + self.comments!
            self.commentList.reloadData()
        })
        */
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
        setUpCable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newComment" {
            let newComment: NewCommentViewController = segue.destination as! NewCommentViewController
            newComment.board = self.board
        }
    }

    func getBoard(){
        guard let board_id = board?.id else {
            print("getBoard: board_id is nil")
            return
        }
        MatomeChannelAPI().getBoard(board_id, success: { (board: Board) in
            self.board = board
            self.comments = board.comments!
            self.hasMoreComments = (board.comments?.last?.num != 1)
            self.commentList.reloadData()
        })
    }

    func getMoreComments(){
        guard let board_id = board?.id else { return }
        guard let lt_id = comments.last?.id else { return }
        MatomeChannelAPI().getBoardComments(board_id, lt_id: lt_id, success: { (comments: [Comment]) in
            self.comments = self.comments + comments
            self.hasMoreComments = (self.comments.last?.num != 1)
            self.commentList.reloadData()
        })
    }

}

// TableView delegate
extension ShowBoardViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentCellView = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath as IndexPath) as! CommentCellView
        let comment: Comment = self.comments[indexPath.row]
        cell.setCell(comment)
        return cell

    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.comments.count
        if count >= 20 && (count - indexPath.row) == 10 && self.hasMoreComments {
            getMoreComments()
        }
    }
}

// Extension for Action Cable
extension ShowBoardViewController{
    func setUpCable(){
        let url = URL(string: "wss://m-ch.xyz/backend/cable")!
        self.cable = ActionCableClient(url: url)
        let cable = self.cable!
        cable.headers = [
            "Host": "m-ch.xyz",
            "Origin": "https://m-ch.xyz"
        ]
        cable.onConnected = {
            self.boardChannel = cable.create("BoardChannel")
            self.boardChannel?.onReceive = { (data: Any?, error: Error?) in
                if((error) != nil){
                    print("board channel receive error", error!)
                }else{
                    self.board_channel_dispatcher(data)
                }
            }

            self.boardChannel?.onSubscribed = {
                self.boardChannel?.action("start_observe", with: ["board_id": self.board!.id!])
            }
            self.boardChannel?.onUnsubscribed = {
                self.cable?.disconnect()
            }
        }
        cable.connect()
    }

    func board_channel_dispatcher(_ data: Any?){
        if(data == nil){
            print("json is nil")
            return
        }
        let json = JSON(data!)
        let action = json["action"].string!
        switch(action){
        case "comment_added":
            let comment = Mapper<Comment>().map(JSON: json["comment"].dictionaryObject!)
            self.comments.insert(comment!, at: 0)
            self.commentList.reloadData()
        case "board_image_added":
            let board_image = Mapper<BoardImage>().map(JSON: json["board_image"].dictionaryObject!)
            self.board?.board_images?.insert(board_image!, at: 0)
        case "board_website_added":
            let board_website = Mapper<BoardWebsite>().map(JSON: json["board_website"].dictionaryObject!)
            self.board?.board_websites?.insert(board_website!, at: 0)
        case "comment_image_added":
            let comment_image = Mapper<CommentImage>().map(JSON: json["comment_image"].dictionaryObject!)!
            let target_index = self.comments.index(where: { (comment) -> Bool in
                return(comment.id == comment_image.comment_id)
            })
            if( target_index != nil ){
                self.comments[target_index!].images?.insert(comment_image.image!, at: 0)
                self.commentList.reloadData()
            }
        case "comment_website_added":
            let comment_website = Mapper<CommentWebsite>().map(JSON: json["comment_website"].dictionaryObject!)!
            let target_index = self.comments.index(where: { (comment) -> Bool in
                return(comment.id == comment_website.comment_id)
            })
            if( target_index != nil ){
                self.comments[target_index!].websites?.insert(comment_website.website!, at: 0)
                self.commentList.reloadData()
            }
        case "board_favorited":
            let favorite_board = Mapper<FavoriteBoard>().map(JSON: json["favorite"].dictionaryObject!)!
            self.board?.favorite_user_ids?.append(favorite_board.user_id!)
        case "comment_favorited":
            let favorite_comment = Mapper<FavoriteComment>().map(JSON: json["favorite"].dictionaryObject!)!
            let target_index = self.comments.index(where: { (comment) -> Bool in
                return(comment.id == favorite_comment.comment_id)
            })
            if( target_index != nil ){
                self.comments[target_index!].favorite_user_ids?.append(favorite_comment.user_id!)
                self.commentList.reloadData()
            }
        default:
            print("unknown action:", action)
        }
    }
}
