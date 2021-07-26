//
//  ViewController.swift
//  stock
//
//  Created by 林華淵 on 2021/7/21.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let loadData = LoadData()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData.nNum = 7
        loadData.sendAPI() {
            
        }
    }
}

