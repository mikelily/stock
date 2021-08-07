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
    let outputTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLogViews()
        loadData.loadDataDelegate = self
        self.setActView(openOrClose: true)
        loadData.sendAPI()
    }
    
    func setLogViews(){
        outputTextView.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(outputTextView)
        outputTextView.snp.makeConstraints { makes in
            makes.top.left.equalToSuperview().offset(30)
            makes.bottom.right.equalToSuperview().offset(-20)
        }
    }
}

extension ViewController: LoadDataDelegate{
    func showData(){
        self.setActView(openOrClose: false)
        setLogViews()
        outputTextView.text = loadData.outputLogText
    }
    
    func showLoadingData() {
        outputTextView.text = loadData.outputLogText
    }
}

