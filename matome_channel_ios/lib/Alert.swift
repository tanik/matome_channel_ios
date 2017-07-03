//
//  Alert.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/07/03.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import UIKit

class Alert {

    var parent: UIViewController

    init(_ parent: UIViewController){
        self.parent = parent
    }

    func show(_ message: String){
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
        self.parent.present(alert, animated: true, completion: nil)
    }
}
