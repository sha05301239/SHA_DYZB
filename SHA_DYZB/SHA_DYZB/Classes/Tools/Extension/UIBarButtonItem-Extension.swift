//
//  UIBarButtonItem-Extension.swift
//  SHA_DYZB
//
//  Created by sha0530 on 17/2/7.
//  Copyright © 2017年 鼎. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    /*
    class func creatItem(imageName:String,highImageName:String,size:CGSize) ->UIBarButtonItem {
        
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), for: .normal)
        
        btn.setImage(UIImage(named:highImageName), for: .highlighted)
        
        btn.frame = CGRect(origin:CGPoint.zero,size:size)
        
        
        
        return UIBarButtonItem(customView:btn)
        
 
    }
 
 */
    //便利构造函数 1>必须以convenience开头 2>在构造函数中必须调用一个设计构造函数(slef)
   convenience init(imageName:String,highImageName:String = "",size:CGSize = CGSize.zero) {
    
    //1.创建UIButton
    let btn = UIButton()
    //2.设置button的图片
    btn.setImage(UIImage(named:imageName), for: .normal)
    
    if highImageName != "" {
        btn.setImage(UIImage(named:highImageName), for: .highlighted)

    }
    
    //3.设置button的尺寸
    if size == CGSize.zero {
        
        btn.sizeToFit()
        
    }else{
        
         btn.frame = CGRect(origin:CGPoint.zero,size:size)
    }
    
  
    //4.创建buttonItem
    self.init(customView:btn)
    
    }
    
}
