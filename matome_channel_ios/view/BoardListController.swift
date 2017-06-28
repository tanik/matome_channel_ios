//
//  ViewController.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/23.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import UIKit

class BoardListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var boards: [Board] = []
    var selectedCategory: Category = Category.root
    var selectedBoard: Board? = nil

    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var boardList: UITableView!

    @IBAction func refresh(_ sender: Any) {
        print("refresh")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getBoards()
        boardList.dataSource = self
        boardList.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getBoards() {
        var params: Dictionary<String, Any> = [:]
        if let category_id = selectedCategory.id {
            params = ["category_id": category_id]
        }
        self.navBar.title = selectedCategory.name!
        MatomeChannelAPI().getBoards(params: params,
            success: { (boardList: BoardList) in
                self.boards = (boardList.boards)!
                self.boardList.reloadData()
            }
        )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBoard" {
            let showBoard: ShowBoardViewController = segue.destination as! ShowBoardViewController
            showBoard.board = selectedBoard!
        } else if segue.identifier == "category" {
            let categoryList: CategoryViewController = segue.destination as! CategoryViewController
            categoryList.selectedCategory = self.selectedCategory
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BoardListCellView = tableView.dequeueReusableCell(withIdentifier: "board", for: indexPath as IndexPath) as! BoardListCellView
        cell.setCell(self.boards[indexPath.row])
        return cell
        
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        selectedBoard = boards[indexPath.row]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
}

