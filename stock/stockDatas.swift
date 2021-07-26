//
//  stockDatas.swift
//  stock
//
//  Created by 林華淵 on 2021/7/21.
//

import Foundation

struct StockDatas {
    
    enum KLineType {
        case red, green, gray
    }
    var kType: KLineType?
    
//    var num: String?
    var name: String?
    var openPrice: Float?
    var highPrice: Float?
    var lowPrice: Float?
    var endPrice: Float?
    // 如果需要計算 k 棒顏色，打開下面這塊
    {
        didSet{
            guard endPrice != nil else { return }
            /**
             莫名其妙 20210720 測試撈了幾次
             6669 緯穎 的開盤價都存不進去
             例外情形會導致 kType 為 nil
             */
            guard openPrice != nil else { return }
            
            if endPrice! > openPrice! {
                kType = .red
            }else if endPrice! == openPrice!{
                kType = .gray
            }else{
                kType = .green
            }
        }
    }
}

//"fields9": [
//    "證券代號", 0
//    "證券名稱", 1
//    "成交股數", 2
//    "成交筆數", 3
//    "成交金額", 4
//    "開盤價", 5
//    "最高價", 6
//    "最低價", 7
//    "收盤價", 8
//    "漲跌(+/-)", 9  這個是跟前日收盤價比較
//    "漲跌價差", 10
//    "最後揭示買價", 11
//    "最後揭示買量", 12
//    "最後揭示賣價", 13
//    "最後揭示賣量", 14
//    "本益比" 15
//  ],
