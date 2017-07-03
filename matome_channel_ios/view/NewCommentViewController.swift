//
//  NewCommentViewController.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/07/03.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import UIKit

class NewCommentViewController: UIViewController {
    var board: Board? = nil
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var contentField: UITextView!

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func post(_ sender: Any) {
        let name: String    = nameField.text!
        let content: String = contentField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(content.characters.count == 0){
            Alert(self).show("コメントは１文字以上入力してください。")
            return
        }
        MatomeChannelAPI().createComment(
            board_id: board!.id!,
            name: name,
            content: content,
            success: { (comment: Comment) in
                let showBoardView = self.presentingViewController as! ShowBoardViewController
                showBoardView.getBoard()
                self.dismiss(animated: true, completion: {
                })
        }, failure: { (error: Error) in
            Alert(self).show("エラーが発生しました。しばらくお待ちいただいてから再度お試しください。")
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentField.layer.borderWidth = 0.5
        contentField.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        contentField.layer.cornerRadius = 5
    }
}
