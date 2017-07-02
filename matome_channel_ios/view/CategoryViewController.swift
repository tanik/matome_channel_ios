//
//  CategoryViewController.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/28.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var categories: [Category] = []
    var selectedCategory: Category = Category.root

    @IBOutlet weak var categoriesTable: UITableView!

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesTable.dataSource = self
        categoriesTable.delegate = self
        getCategories()
    }

    func getCategories(){
        MatomeChannelAPI().getCategories(success: { (categories:[Category]) in
            self.categories = [Category.root] + categories
            self.categoriesTable.reloadData()
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath as IndexPath)
        let category = self.categories[indexPath.row]
        cell.textLabel?.text = category.nested_name!
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedCategory = categories[indexPath.row]
        if ((self.presentingViewController as? BoardListViewController) != nil) {
            let boardListView = self.presentingViewController as! BoardListViewController
            boardListView.selectedCategory = selectedCategory
            boardListView.getBoards()
        }else{
            print("not board list")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
