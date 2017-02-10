//
//  MainViewController.swift
//  SHA_DYZB
//
//  Created by sha0530 on 17/2/7.
//  Copyright © 2017年 鼎. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         addChildVC(storyName: "Home")
         addChildVC(storyName: "Live")
         addChildVC(storyName: "Follow")
         addChildVC(storyName: "Me")
 
        
    }

    private func addChildVC(storyName:String){
        
        //1.通过storyboard获取控制器
        let childVC = UIStoryboard(name:storyName,bundle:nil).instantiateInitialViewController()!
        
        
        //2.将childVC作为子控制器
        addChildViewController(childVC)

    }
}
