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
//        loadData.nNum = 6
        loadData.loadDataDelegate = self
        self.setActView(openOrClose: true)
        loadData.sendAPI()
    }
    
    func setLogViews(){
        let outputLogText = """
            目標為：
              1. 今/昨日紅 K，前天綠 K
              2. 今日突破五日線
              3. 昨天還在五日線下
              4. 五日線向上
            
            === price30Low ===
            \(loadData.price30Low)
            === price30_50 ===
            \(loadData.price30_50)
            === price50_100 ===
            \(loadData.price50_100)
            === price100_200 ===
            \(loadData.price100_200)
            === price200_300 ===
            \(loadData.price200_300)
            === price300Up ===
            \(loadData.price300Up)
            """
        
        let outputTextView = UITextView()
        outputTextView.text = outputLogText
//        outputTextView.textAlignment = .center
        outputTextView.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(outputTextView)
        outputTextView.snp.makeConstraints { makes in
            makes.top.left.equalToSuperview().offset(20)
            makes.bottom.right.equalToSuperview().offset(-20)
        }
    }
}

extension ViewController: LoadDataDelegate{
    func showData(){
        self.setActView(openOrClose: false)
        loadData.sendLog()
        setLogViews()
    }
}

