//
//  BoardWebsiteViewController.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/07/04.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class BoardWebsiteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var board_websites: [BoardWebsite] = []
    var hasMoreWebsites: Bool = true

    @IBOutlet weak var websiteList: UITableView!

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        websiteList.dataSource = self
        websiteList.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// TableView delegate
extension BoardWebsiteViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return board_websites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BoardWebsiteCellView = tableView.dequeueReusableCell(withIdentifier: "boardWebsite", for: indexPath as IndexPath) as! BoardWebsiteCellView
        let website = self.board_websites[indexPath.row].website!
        cell.setCell(website)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.board_websites.count
        if count >= 20 && (count - indexPath.row) == 10 && self.hasMoreWebsites {
            print("more websites")
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let website = self.board_websites[indexPath.row].website!
        let url: URL = URL(string: website.original_url!)!
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
