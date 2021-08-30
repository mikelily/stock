//
//  TickViewController.swift
//  stock
//
//  Created by 林華淵 on 2021/8/28.
//

import UIKit
import SnapKit

class TickViewController: UIViewController {
    
    var valueArray:[Double] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addTapGestureRecognizer { self.view.endEditing(true) }
        view.backgroundColor = .white
        setValueArray()
        setBasicViews()
    }
    
    func setValueArray(){
        var i = 1000
        while i < 30000 {
            valueArray.append(Double(i)/100)
            
            if i < 5000{
                i+=5
            }else if i < 10000{
                i+=10
            }else if i < 50000{
                i+=50
            }
        }
    }
    
    let targetTF = UITextField()
    let percentTF = UITextField()
    
    func setBasicViews(){
        view.addSubview(targetTF)
        targetTF.keyboardType = .decimalPad
        targetTF.textAlignment = .right
        targetTF.backgroundColor = .lightGray
        targetTF.snp.makeConstraints { makes in
            makes.top.left.equalToSuperview().offset(40)
            makes.height.equalTo(40)
            makes.width.equalTo(60)
        }
        
        view.addSubview(percentTF)
        percentTF.keyboardType = .numberPad
        percentTF.textAlignment = .right
        percentTF.backgroundColor = .lightGray
        percentTF.text = "35"
        percentTF.snp.makeConstraints { makes in
            makes.top.width.height.equalTo(targetTF)
            makes.left.equalTo(targetTF.snp.right).offset(30)
        }
        
        let calculateBtn = UIView()
        view.addSubview(calculateBtn)
        calculateBtn.backgroundColor = .systemPink
        calculateBtn.snp.makeConstraints { makes in
            makes.top.width.height.equalTo(targetTF)
            makes.left.equalTo(percentTF.snp.right).offset(30)
        }
        calculateBtn.addTapGestureRecognizer {
            self.calculate()
        }
    }
    
    var resultArray:[Any]=[]
    
    func calculate(){
        guard Double(targetTF.text!) != nil &&
                Int(percentTF.text!) != nil
        else {
              return
        }
        
        guard let index = valueArray.firstIndex(of: Double(targetTF.text!)!) else{
            return
        }
        
        resultArray = []    //init
        
        var lowIndex: Int?
        var highIndex: Int?
        
        lowIndex = index < 5 ? 0 : index - 4
        highIndex = index + 5
        if highIndex! > valueArray.count { highIndex = valueArray.count}
        
        //換成整數運算
        let intTarget = Int(Double(targetTF.text!)!*1000)
        let intPercent = Int(percentTF.text!)!
        let intFee = 1425   // 1000000
        let intTax = 150000 // 1000000
        
        let upBuyCost = intTarget*1000*(intFee*intPercent)
        let downSellCost = intTarget*1000*(intFee*intPercent+intTax)
        if lowIndex != nil && highIndex != nil{
            var upSellCost: Int?
            var downBuyCost: Int?
            
            for i in lowIndex!..<highIndex!{
                downBuyCost = Int(valueArray[i]*1000)*1000*(intFee*intPercent)
                upSellCost = Int(valueArray[i]*1000)*1000*(intFee*intPercent+intTax)
                // 做多
                let upResult = ((Int(valueArray[i]*1000) - intTarget)*100000000000 - upSellCost! - upBuyCost)/100000000000
                // 做空
                let downResult = ((intTarget - Int(valueArray[i]*1000))*100000000000 - downBuyCost! - downSellCost)/100000000000
                
//                print(valueArray[i],upResult,downResult)
//                resultArray.append(valueArray[i])
                resultArray.append(downResult)
                resultArray.append(upResult)
                resultArray.append(valueArray[i])
//                resultArray.append(downResult)
            }
            showResult()
        }
    }
    
    func showResult(){
        resultArray.reverse()
//        for r in resultArray{
//            print(r)
//        }
        let num = resultArray.count / 3
        
        let blackView = UIView()
        let upView = UIView()
        let downView = UIView()
        
        view.addSubview(upView)
        upView.backgroundColor = .red
        upView.snp.makeConstraints { makes in
            makes.top.equalTo(targetTF.snp.bottom).offset(40)
            makes.height.equalTo((40+1)*(num+1)+1)
            makes.width.equalTo(100)
            makes.centerX.equalToSuperview()
        }
        
        let upTitleView = UIView()
        upView.addSubview(upTitleView)
        upTitleView.backgroundColor = .white
        upTitleView.snp.makeConstraints { makes in
            makes.top.left.equalToSuperview().offset(1)
            makes.right.equalToSuperview().offset(-1)
            makes.height.equalTo(40)
        }
        
        let upLabel = UILabel()
        upLabel.text = "做多"
        upLabel.textColor = .red
        upTitleView.addSubview(upLabel)
        upLabel.snp.makeConstraints { makes in
            makes.center.equalToSuperview()
        }
        
        view.addSubview(blackView)
        blackView.backgroundColor = .black // for test
        blackView.snp.makeConstraints { makes in
            makes.width.top.height.equalTo(upView)
//            makes.top.equalTo(targetTF.snp.bottom).offset(40)
            makes.right.equalTo(upView.snp.left)
//            makes.height.equalTo(40*(num+1))
        }
        
        let blackTitleView = UIView()
        blackView.addSubview(blackTitleView)
        blackTitleView.backgroundColor = .white
        blackTitleView.snp.makeConstraints { makes in
            makes.top.left.equalToSuperview().offset(1)
            makes.right.equalToSuperview().offset(-1)
            makes.height.equalTo(40)
        }
        
        view.addSubview(downView)
        downView.backgroundColor = .green
        downView.snp.makeConstraints { makes in
            makes.width.top.height.equalTo(upView)
//            makes.top.equalTo(targetTF.snp.bottom).offset(40)
            makes.left.equalTo(upView.snp.right)
        }
        
        let downTitleView = UIView()
        downView.addSubview(downTitleView)
        downTitleView.backgroundColor = .white
        downTitleView.snp.makeConstraints { makes in
            makes.top.left.equalToSuperview().offset(1)
            makes.right.equalToSuperview().offset(-1)
            makes.height.equalTo(40)
        }
        
        let downLabel = UILabel()
        downLabel.text = "做空"
        downLabel.textColor = .green
        downTitleView.addSubview(downLabel)
        downLabel.snp.makeConstraints { makes in
            makes.center.equalToSuperview()
        }
        
        var targetIndex: Int?
        
        for index in 0..<resultArray.count{
//            var targetIndex: Int?
            
            switch index % 3{
            case 0:
                
                if resultArray[index] as! Double == Double(targetTF.text!)! {
                    targetIndex = index / 3
                }
                
                let bkView = UIView()
                blackView.addSubview(bkView)
                bkView.backgroundColor = .white
                let i = index/3
                bkView.snp.makeConstraints { makes in
                    makes.left.width.height.equalTo(blackTitleView)
                    makes.top.equalToSuperview().offset((i+1)*(40+1)+1)
                }
                
                let valueLabel = UILabel()
                if i == targetIndex{
                    valueLabel.font = UIFont.boldSystemFont(ofSize: 20)
                }
                valueLabel.text = "\(resultArray[index])"
                bkView.addSubview(valueLabel)
                valueLabel.snp.makeConstraints { makes in
                    makes.center.equalToSuperview()
                }
            case 1:
                let bkView = UIView()
                upView.addSubview(bkView)
                bkView.backgroundColor = .white
                let i = index/3
                bkView.snp.makeConstraints { makes in
                    makes.left.width.height.equalTo(upTitleView)
                    makes.top.equalToSuperview().offset((i+1)*(40+1)+1)
                }
                
                let valueLabel = UILabel()
                if i == targetIndex{
                    valueLabel.font = UIFont.boldSystemFont(ofSize: 18)
                }
                valueLabel.text = "\(resultArray[index])"
                bkView.addSubview(valueLabel)
                valueLabel.snp.makeConstraints { makes in
                    makes.center.equalToSuperview()
                }
            case 2:
                let bkView = UIView()
                downView.addSubview(bkView)
                bkView.backgroundColor = .white
                let i = index/3
                bkView.snp.makeConstraints { makes in
                    makes.left.width.height.equalTo(downTitleView)
                    makes.top.equalToSuperview().offset((i+1)*(40+1)+1)
                }
                
                let valueLabel = UILabel()
                if i == targetIndex{
                    valueLabel.font = UIFont.boldSystemFont(ofSize: 18)
                }
                valueLabel.text = "\(resultArray[index])"
                bkView.addSubview(valueLabel)
                valueLabel.snp.makeConstraints { makes in
                    makes.center.equalToSuperview()
                }
            default:
                print("error")
            }
        }
    }

}
