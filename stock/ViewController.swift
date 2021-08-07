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
    let systemLogTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setSubViews()
        loadData.loadDataDelegate = self
//        self.setActView(openOrClose: true)
//        loadData.sendAPI()
    }
    
    func setSubViews(){
        let sendView = UIView()
        sendView.backgroundColor = .yellow
        view.addSubview(sendView)
        sendView.snp.makeConstraints { makes in
            makes.top.equalToSuperview().offset(50)
            makes.left.equalToSuperview().offset(30)
            makes.right.equalToSuperview().offset(-30)
            makes.height.equalTo(50)
        }
        sendView.addTapGestureRecognizer {
            self.setActView(openOrClose: true)
            self.loadData.sendAPI()
        }
        let sendLabel = UILabel()
        sendLabel.text = "Send"
        sendLabel.font = UIFont.boldSystemFont(ofSize: 20)
        sendView.addSubview(sendLabel)
        sendLabel.snp.makeConstraints { makes in
            makes.center.equalToSuperview()
        }
        
        outputTextView.isSelectable = false
        outputTextView.isEditable = false
        outputTextView.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(outputTextView)
        outputTextView.snp.makeConstraints { makes in
            makes.top.equalTo(sendView.snp.bottom).offset(10)
            makes.left.equalToSuperview().offset(30)
            makes.bottom.right.equalToSuperview().offset(-30)
        }
        
        systemLogTextView.backgroundColor = .lightGray
        systemLogTextView.isSelectable = false
        systemLogTextView.isEditable = false
        systemLogTextView.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(systemLogTextView)
        systemLogTextView.snp.makeConstraints { makes in
            makes.bottom.equalToSuperview().offset(-50)
            makes.height.equalTo(50)
            makes.left.equalToSuperview().offset(30)
            makes.right.equalToSuperview().offset(-30)
        }
    }
}

extension ViewController: LoadDataDelegate{
    func showData(){
        self.setActView(openOrClose: false)
//        setLogViews()
        outputTextView.text = loadData.outputLogText
    }
    
    func showLoadingData() {
        systemLogTextView.text = loadData.systemLogText
        
        // Scrolls to end
        let bottom = NSMakeRange(systemLogTextView.text.count - 1, 1)
        systemLogTextView.scrollRangeToVisible(bottom)
    }
}

