//
//  loadingView.swift
//  stock
//
//  Created by 林華淵 on 2021/7/26.
//

import UIKit
import SnapKit

extension UIViewController{
    func setActView(openOrClose: Bool){
        if openOrClose{
            cleanSubViewsBy(superView: self.view, tag: 500)
            
            let actView = UIView()
            // for remove，注意別的地方不可把 tag 設為 500，以免被誤刪
            actView.tag = 500
            /** 環形進度圈，用來表示讀取資料中 */
            let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            actView.addSubview(activityIndicator)
            //轉圈圈 loading 圖示的設定
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.large
            activityIndicator.center = view.center
            activityIndicator.startAnimating()
            self.view.addSubview(actView)
            actView.snp.makeConstraints { (makes) in
                makes.edges.equalToSuperview()
            }
            actView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
        }else{
            cleanSubViewsBy(superView: self.view, tag: 500)
        }
        
    }
    
    /**
     clean subView by tag
     - Author:  Mike
     */
    func cleanSubViewsBy(superView: UIView,tag: Int){
        for sv in superView.subviews{
            if sv.tag == tag{
                sv.removeFromSuperview()
            }
        }
    }
}
