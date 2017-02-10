//
//  UIColorExtension.swift
//  SHA_DYZB
//
//  Created by sha0530 on 17/2/8.
//  Copyright © 2017年 鼎. All rights reserved.
//

import UIKit

extension UIColor{
    
   
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
        
    }
    
}





