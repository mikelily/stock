//
//  FindViewController.swift
//  stock
//
//  Created by 林華淵 on 2021/9/4.
//

import UIKit
import SnapKit

class FindViewController: UIViewController {
    
    let loadData = LoadData()
    let outputTextView = UITextView()
    let systemLogTextView = UITextView()
    
    enum State{
        case beforeLoading, afterLoading
    }
    
    var state: State = .beforeLoading{
        didSet{
            switch state {
            case .afterLoading:
//                actionLabel.text = "Count"
                self.actionView.isHidden = true
                self.actionView.snp.updateConstraints { makes in
                    makes.height.equalTo(0)
                }
            default:
                print("do not thing")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setSubViews()
        loadData.loadDataDelegate = self
    }
    
    let actionView = UIView()
    let actionLabel = UILabel()
    
    func setSubViews(){
        
        actionView.backgroundColor = .yellow
        view.addSubview(actionView)
        actionView.snp.makeConstraints { makes in
            makes.top.equalToSuperview().offset(50)
            makes.left.equalToSuperview().offset(30)
            makes.right.equalToSuperview().offset(-30)
            makes.height.equalTo(50)
        }
        actionView.addTapGestureRecognizer {
            if self.state == .beforeLoading{
                self.setActView(openOrClose: true)
                self.loadData.sendAPI()
            }
        }
            
//        let actionLabel = UILabel()
        actionLabel.text = "Load Data"
        actionLabel.textColor = .black
        actionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        actionView.addSubview(actionLabel)
        actionLabel.snp.makeConstraints { makes in
            makes.center.equalToSuperview()
        }
        
        outputTextView.isSelectable = false
        outputTextView.isEditable = false
        outputTextView.backgroundColor = .white
        outputTextView.textColor = .black
        outputTextView.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(outputTextView)
        outputTextView.snp.makeConstraints { makes in
            makes.top.equalTo(actionView.snp.bottom).offset(10)
            makes.left.equalToSuperview().offset(30)
            makes.right.equalToSuperview().offset(-30)
            makes.bottom.equalToSuperview().offset(-80)
        }
        
        systemLogTextView.backgroundColor = .lightGray
        systemLogTextView.isSelectable = false
        systemLogTextView.isEditable = false
        systemLogTextView.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(systemLogTextView)
        systemLogTextView.snp.makeConstraints { makes in
            makes.bottom.equalToSuperview().offset(-100)
            makes.height.equalTo(50)
            makes.left.equalToSuperview().offset(30)
            makes.right.equalToSuperview().offset(-30)
        }
    }
}

extension FindViewController: LoadDataDelegate{
    func showData(){
        self.setActView(openOrClose: false)
//        setLogViews()
        self.state = .afterLoading
        outputTextView.text = loadData.outputLogText
    }
    
    func showLoadingData() {
        systemLogTextView.text = loadData.systemLogText
        
        // Scrolls to end
        let bottom = NSMakeRange(systemLogTextView.text.count - 1, 1)
        systemLogTextView.scrollRangeToVisible(bottom)
    }
}
