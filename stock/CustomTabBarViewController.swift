//
//  CustomTabBarViewController.swift
//  stock
//
//  Created by 林華淵 on 2021/8/28.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    
    let tickVC = TickViewController()
    let vc = ViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitUI()
    }
    
    func setInitUI(){
        vc.tabBarItem = UITabBarItem(title: "1", image: UIImage(systemName: "network"), selectedImage: UIImage(systemName: "network"))
        tickVC.tabBarItem = UITabBarItem(title: "2", image: UIImage(systemName: "pencil"), selectedImage: UIImage(systemName: "pencil"))
        self.viewControllers = [vc, tickVC]
    }

}
