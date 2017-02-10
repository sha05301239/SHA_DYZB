//
//  HomeViewController.swift
//  SHA_DYZB
//
//  Created by sha0530 on 17/2/7.
//  Copyright © 2017年 鼎. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {

    // MARK - 懒加载属性
    fileprivate lazy var pageTitleView : PageTitleView = { [weak self] in
        
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kWindowW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
        
    }()
    
    
    // MARK - 懒加载pageViewController
    fileprivate lazy var pageContentView:PageContentView = {[weak self] in
        
        //确定内容的frame
        let contentH = kWindowH - kStatusBarH - kNavigationBarH - kTitleViewH
        let contentFrame = CGRect(x: 0, y: kStatusBarH+kNavigationBarH+kTitleViewH, width:kWindowW, height: contentH)
        
        //确定所有子控制器
        
        var childVcs = [UIViewController]()
        
        for _ in 0..<4 {
            
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            
            childVcs.append(vc)
        }
        
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewcontroller: self!)
        
        contentView.delegate = self
        
        return contentView
        
        
    }()
    
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置UI界面
        
        setupUI()
        
        
    }

   
}

//MARK: - 设置UI界面
extension HomeViewController{
    
      func setupUI(){
        
        //0.不需要scrollerView自动调整
        automaticallyAdjustsScrollViewInsets = false
        
        //1.设置导航栏
        setupNavigationBar()
        
        //2.添加titleView
        view.addSubview(pageTitleView)
        
        //3.添加contentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.orange
        
    }
    
    
    private func setupNavigationBar(){
        
        //1.设置左侧item
//        let btn = UIButton()
//        btn.setImage(UIImage(named:"logo"), for:.normal)
//        btn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        
        
        //2.设置右侧item
        
        let size = CGSize(width: 40 , height: 40)
        
//        let historyBtn = UIButton()
//        historyBtn.setImage(UIImage(named:"Image_my_history"), for: .normal)
//        historyBtn.setImage(UIImage(named:"Image_my_history_click"), for: .highlighted)
//        historyBtn.sizeToFit()
//        historyBtn.frame = CGRect(origin: CGPoint.zero,size: size)
        
        
        /*
        
        let historyItem = UIBarButtonItem.creatItem(imageName: "Image_my_history", highImageName: "Image_my_history_click", size: size)
        
 
        let searchItem = UIBarButtonItem.creatItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
       
     
        let qrcodeItem = UIBarButtonItem.creatItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        */
        
        let historyItem = UIBarButtonItem(imageName: "Image_my_history", highImageName: "Image_my_history_click", size: size)
        
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)

        
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
        
    }
    
    
}


//Mark: - 遵守PageTitleViewDelegate
extension HomeViewController : PageTitleViewDelegate{
    
    internal func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
        
        print(index)
        
        pageContentView.setCurrentIndex(index)
    }
}


//Mark: - 遵守PageContentViewDelegate
extension HomeViewController : PageContentViewDelegate{
    
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        
        
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
    }
    
}




