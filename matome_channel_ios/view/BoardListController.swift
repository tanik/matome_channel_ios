//
//  ViewController.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/23.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import UIKit

class BoardListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var boards: [Board] = []
    var selectedCategory: Category = Category.root
    var selectedBoard: Board? = nil

    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var boardList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBAction func showSearchBar(_ sender: Any) {
        self.searchBar.isHidden = false
    }

    @IBAction func refresh(_ sender: Any) {
        getBoards()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getBoards()
        boardList.dataSource = self
        boardList.delegate = self
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getBoards() {
        var params: Dictionary<String, Any> = [:]
        if let category_id = selectedCategory.id {
            params["category_id"] = category_id
        }
        if let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if !query.isEmpty {
                params["q"] = query
            }
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

    // TableView delegate
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

    // Search Bar delegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        self.searchBar.endEditing(true)
        self.searchBar.isHidden = true
        getBoards()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        getBoards()
    }
}

