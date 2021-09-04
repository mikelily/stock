//
//  CustomTabBarViewController.swift
//  stock
//
//  Created by 林華淵 on 2021/8/28.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    
    let tickVC = TickViewController()
    let findVC = FindViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitUI()
    }
    
    func setInitUI(){
        tickVC.tabBarItem = UITabBarItem(title: "Tick", image: UIImage(systemName: "pencil"), selectedImage: UIImage(systemName: "pencil"))
        findVC.tabBarItem = UITabBarItem(title: "Find", image: UIImage(systemName: "network"), selectedImage: UIImage(systemName: "network"))
        
        self.viewControllers = [tickVC, findVC]
    }

}
