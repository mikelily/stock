//
//  LoadData.swift
//  stock
//
//  Created by 林華淵 on 2021/7/26.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol LoadDataDelegate: AnyObject{
    func showData()
    func showLoadingData()
}

class LoadData: Any {
    weak var loadDataDelegate: LoadDataDelegate?
    
    let API: String = "https://www.twse.com.tw/exchangeReport/MI_INDEX?type=ALL&date="
    var nDaysDatas: [ String : [StockDatas] ] = [:]
    /// 要抓總共幾日的資料
    var nNum: Int = 6{
        didSet{
            // 防呆，For 兩日五日線
            if nNum < 6 {
                nNum = 6
            }
        }
    }
    var secForDays: Int = 0
    var dayNum: Int = 1{
        didSet{
            secForDays = (dayNum - 1) * 60 * 60 * 24
        }
    }
    
    var price30Low:[String] = []
    var price30_50:[String] = []
    var price50_100:[String] = []
    var price100_200:[String] = []
    var price200_300:[String] = []
    var price300Up:[String] = []
    
    var outputLogText = ""
    
    func getDatString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return(dateFormatter.string(from: Date(timeIntervalSinceNow: TimeInterval(-secForDays))))
    }

    func sendAPI() {
        AF.request("\(API)\(getDatString())", method: .get)
            .responseJSON { [self] (response) in
                if response.value != nil {
                    let swiftyJsonVar = JSON(response.value!)
                    /**
                     OK : 有抓到
                     很抱歉，沒有符合條件的資料! : 休市 or 本日尚未結算
                    */
                    guard swiftyJsonVar["stat"] == "OK" else {
                        if self.nDaysDatas["2002"] == nil{
                            print("\(getDatString()) no data")
                            outputLogText.append("\(getDatString()) no data\n")
                            loadDataDelegate?.showLoadingData()
                            dayNum += 1
                            sendAPI()
                        }else if self.nDaysDatas["2002"]!.count < nNum{
                            print("\(getDatString()) no data")
                            outputLogText.append("\(getDatString()) no data\n")
                            loadDataDelegate?.showLoadingData()
                            dayNum += 1
                            sendAPI()
                        }
//                        completion()
                        return
                    }
                    let dataJson = JSON(swiftyJsonVar["data9"])
                    let dataArray = dataJson.arrayObject
                    
                    for data in dataArray!{
                        let singleArray = JSON(data)
                        
                        // 過濾編號四碼以外的，加快處理速度
                        if singleArray[0].string!.count == 4{
                            var tempStockDatas: StockDatas = StockDatas()
                            tempStockDatas.name = singleArray[1].string
                            tempStockDatas.openPrice = Float(singleArray[5].string!)
                            tempStockDatas.highPrice = Float(singleArray[6].string!)
                            tempStockDatas.lowPrice = Float(singleArray[7].string!)
                            tempStockDatas.endPrice = Float(singleArray[8].string!)
                            
                            var stockDatas: [StockDatas] = nDaysDatas[singleArray[0].string!] ?? []
                            stockDatas.append(tempStockDatas)
                            nDaysDatas[singleArray[0].string!] = stockDatas
                        }
                    }
                    
                    print("\(getDatString()) 共\(dataJson.count)筆資料 編號四碼的有 \(self.nDaysDatas.count)筆")
                    outputLogText.append("\(getDatString()) Store  \(self.nDaysDatas.count) datas\n")
//                    DispatchQueue.main.async {
//                        loadDataDelegate?.showLoadingData()
//                    }
                    loadDataDelegate?.showLoadingData()
                    
                    if self.nDaysDatas["2002"]!.count < nNum{
                        dayNum += 1
                        sendAPI()
                    }else if self.nDaysDatas["2002"]!.count == nNum{
                        self.afterLoading()
                    }
//                    completion()
                }else{
                    print("send fail")
//                    completion()
                }
            }
    }
    /// Do something after loading datas
    func afterLoading(){
        /// calc done
        upTo5DayLine3{
//            self.sendLog()
            self.appendLog()
            self.loadDataDelegate?.showData()
        }
    }
    
    /**
     目標為：
     1. 今日紅 K，昨日綠 K
     2. 今日突破五日線，昨天還在五日線下
     note : for loop 撈 dict datas, 用 guard 似乎會讓 for loop 直接停下
     以 20210722 來跑，會有 785 筆資料符合，太多了 XDa
     更新，補上限制股票代碼為四位數，筆數減少至 102
     */
    func upTo5DayLine(){
        print("upTo5DayLine")
        for (num,stockDatas) in nDaysDatas{
            if stockDatas.count != 6 || num.count != 4{
                // stockDatas Error
                // 補上限制股票代碼4位數
            }else{
                if stockDatas[0].kType == nil ||
                    stockDatas[1].kType == nil ||
                    stockDatas[2].kType == nil ||
                    stockDatas[3].kType == nil ||
                    stockDatas[4].kType == nil ||
                    stockDatas[5].kType == nil {
                    // kType Error
                }else{
                    if stockDatas[0].kType == .red && stockDatas[1].kType == .green{
                        // first condition ok
                        
                        var today5 : Float = 0.0
                        var yesterday5 : Float = 0.0
                        for j in 0..<5{
                            today5 += stockDatas[j].endPrice!
                        }
                        today5 /= 5
                        
                        for j in 1..<6{
                            yesterday5 += stockDatas[j].endPrice!
                        }
                        yesterday5 /= 5
                        
                        if stockDatas[0].endPrice! > today5 && stockDatas[1].endPrice! < yesterday5{
                            print("\(num) two condition ok!!")
                        }
                    }
                }
            }
        }
    }
    
    /**
     目標為：
     1. 今日紅 K，昨日綠 K
     2. 今日突破五日線，昨天還在五日線下
     3. 五日線向上
     note : for loop 撈 dict datas, 用 guard 似乎會讓 for loop 直接停下
     以 20210722 來跑，會有 344 筆資料符合，太多了 XDa
     更新，補上限制股票代碼為四位數，筆數減少至 61
     更新，用股價稍微分類一下
     */
    func upTo5DayLine2(){
        print("upTo5DayLine2")
        for (num,stockDatas) in nDaysDatas{
            if stockDatas.count != 6 || num.count != 4{
                // stockDatas Error
                // 補上限制股票代碼4位數
            }else{
                if stockDatas[0].kType == nil ||
                    stockDatas[1].kType == nil ||
                    stockDatas[2].kType == nil ||
                    stockDatas[3].kType == nil ||
                    stockDatas[4].kType == nil ||
                    stockDatas[5].kType == nil {
                    // kType Error
                }else{
                    if stockDatas[0].kType == .red && stockDatas[1].kType == .green{
                        // first condition ok
                        
                        var today5 : Float = 0.0
                        var yesterday5 : Float = 0.0
                        for j in 0..<5{
                            today5 += stockDatas[j].endPrice!
                        }
                        today5 /= 5
                        
                        for j in 1..<6{
                            yesterday5 += stockDatas[j].endPrice!
                        }
                        yesterday5 /= 5
                        
                        if stockDatas[0].endPrice! > today5 && stockDatas[1].endPrice! < yesterday5 &&
                            today5 > yesterday5 {
//                            print("\(num) three condition ok!!")
                            
                            let p = stockDatas[0].endPrice!
                            if p < 30{
                                price30Low.append(num)
                            }else if p < 50 {
                                price30_50.append(num)
                            }else if p < 100{
                                price50_100.append(num)
                            }else if p < 200{
                                price100_200.append(num)
                            }else if p < 300{
                                price200_300.append(num)
                            }else{
                                price300Up.append(num)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /**
     目標為：
     1. 今/昨日紅 K，前天綠 K
     2. 今日突破五日線，昨天還在五日線下
     3. 五日線向上
     note : for loop 撈 dict datas, 用 guard 似乎會讓 for loop 直接停下
     以 20210722 來跑，會有 344 筆資料符合，太多了 XDa
     更新，補上限制股票代碼為四位數，筆數減少至 61
     更新，用股價稍微分類一下
     */
    func upTo5DayLine3(completion : @escaping ()->()){
        print("upTo5DayLine3")
        outputLogText.append("""
            
            目標為：
              1. 今/昨日紅 K，前天綠 K
              2. 今日突破五日線
              3. 昨天還在五日線下
              4. 五日線向上
            
            """)
        for (num,stockDatas) in nDaysDatas{
            if stockDatas.count != nNum || num.count != 4{
                // stockDatas Error
                // 補上限制股票代碼4位數
            }else{
                if stockDatas[0].kType == nil ||
                    stockDatas[1].kType == nil ||
                    stockDatas[2].kType == nil ||
                    stockDatas[3].kType == nil ||
                    stockDatas[4].kType == nil ||
                    stockDatas[5].kType == nil {
                    // kType Error
                }else{
                    // first condition ok
                    if stockDatas[0].kType == .red && stockDatas[1].kType == .red &&
                        stockDatas[2].kType == .green {
                        
                        var today5 : Float = 0.0
                        var yesterday5 : Float = 0.0
                        for j in 0..<5{
                            today5 += stockDatas[j].endPrice!
                        }
                        today5 /= 5
                        
                        for j in 1..<6{
                            yesterday5 += stockDatas[j].endPrice!
                        }
                        yesterday5 /= 5
                        
                        if stockDatas[0].endPrice! > today5 && stockDatas[1].endPrice! < yesterday5 &&
                            today5 > yesterday5 {
                            
                            let p = stockDatas[0].endPrice!
                            if p < 30{
                                price30Low.append(num)
                            }else if p < 50 {
                                price30_50.append(num)
                            }else if p < 100{
                                price50_100.append(num)
                            }else if p < 200{
                                price100_200.append(num)
                            }else if p < 300{
                                price200_300.append(num)
                            }else{
                                price300Up.append(num)
                            }
                        }
                    }
                }
            }
        }
        
        completion()
    }
    
    func appendLog(){
        outputLogText.append("""
            === price30Low ===
            \(price30Low)
            === price30_50 ===
            \(price30_50)
            === price50_100 ===
            \(price50_100)
            === price100_200 ===
            \(price100_200)
            === price200_300 ===
            \(price200_300)
            === price300Up ===
            \(price300Up)
            """)
    }
    
//    func sendLog(){
//        print("=== price30Low ===")
//        print(price30Low)
//        print("=== price30_50 ===")
//        print(price30_50)
//        print("=== price50_100 ===")
//        print(price50_100)
//        print("=== price100_200 ===")
//        print(price100_200)
//        print("=== price200_300 ===")
//        print(price200_300)
//        print("=== price300Up ===")
//        print(price300Up)
//    }
}
