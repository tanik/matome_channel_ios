//
//  NewBoardViewController.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/07/01.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import UIKit

class NewBoardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIToolbarDelegate {

    var selectedCategory: Category?
    var categories: [Category] = []
    var categoryPickerToolBar: UIToolbar!
    var categoryPicker: UIPickerView!

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var contentField: UITextView!

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func post(_ sender: Any) {
        let title: String = titleField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let category_id: Int = selectedCategory!.id!
        let name: String    = nameField.text!
        let content: String = contentField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(title.characters.count == 0 || content.characters.count == 0){
            self.showAlert("タイトルとコメントは１文字以上入力してください。")
            return
        }
        MatomeChannelAPI().createBoard(
            title: title,
            category_id: category_id,
            name: name,
            content: content,
            success: { (board: Board) in
            let boardListView = self.presentingViewController as! BoardListViewController
            boardListView.getBoards()
            self.dismiss(animated: true, completion: {
                boardListView.openBoard(board)
            })
        }, failure: { (error: Error) in
            self.showAlert("エラーが発生しました。しばらくお待ちいただいてから再度お試しください。")
        })
    }
    func showAlert(_ message: String){
        let alert: UIAlertController = UIAlertController(
            title: "エラー",
            message: message,
            preferredStyle:  .alert)
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler:{ (action: UIAlertAction!) -> Void in }
        )
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getCategories()
        createCategoryPicker()
        contentField.layer.borderWidth = 0.5
        contentField.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        contentField.layer.cornerRadius = 5
    }

    func getCategories(){
        MatomeChannelAPI().getCategories(success: { (categories:[Category]) in
            self.categories = categories
            self.selectedCategory = categories.first
            self.categoryField.text = self.selectedCategory?.nested_name
            self.categoryPicker.reloadAllComponents()
        })
    }

    func createCategoryPicker(){
        categoryPicker = UIPickerView()
        categoryPicker.showsSelectionIndicator = true
        categoryPicker.delegate = self
        categoryPicker.dataSource = self

        categoryPickerToolBar = UIToolbar(
            frame: CGRect(
                    x: 0,
                    y: self.view.frame.size.height/6,
                    width: self.view.frame.size.width,
                    height: 40.0)
        )
        categoryPickerToolBar.layer.position = CGPoint(
            x: self.view.frame.size.width/2,
            y: self.view.frame.size.height-20.0
        )
        let myToolBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                              target: self,
                                              action: #selector(self.onClick(sender:)))
        myToolBarButton.tag = 1
        categoryPickerToolBar.items = [myToolBarButton]

        categoryField.inputView = categoryPicker
        categoryField.inputAccessoryView = categoryPickerToolBar
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].nested_name!
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
        categoryField.text = selectedCategory?.nested_name
    }

    func onClick(sender: UIBarButtonItem) {
        categoryField.endEditing(true)
    }


}
