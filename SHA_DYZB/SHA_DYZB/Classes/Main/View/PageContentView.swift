//
//  PageContentView.swift
//  SHA_DYZB
//
//  Created by sha0530 on 17/2/8.
//  Copyright © 2017年 鼎. All rights reserved.
//

import UIKit



protocol PageContentViewDelegate : class{
    
    func pageContentView(contentView : PageContentView,progress : CGFloat,sourceIndex : Int,targetIndex : Int)

}

private let identifier : String = "Cell"

class PageContentView: UIView {

    //自定义属性
    var childVcs : [UIViewController]
    weak var parentViewcontroller : UIViewController?
    var startOffsetX : CGFloat = 0
    weak var delegate : PageContentViewDelegate?
    var isForbidScrollDelegate : Bool = false
    
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
       
        //1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //2.创建
        let collertionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collertionView.showsHorizontalScrollIndicator = false
        collertionView.isPagingEnabled = true
        collertionView.bounces = false
        collertionView.dataSource = self
        collertionView.delegate = self
        collertionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        return collertionView
        
    }()
    
    //自定义构造函数
    init(frame: CGRect,childVcs : [UIViewController],parentViewcontroller : UIViewController) {
        
        self.childVcs = childVcs
        self.parentViewcontroller = parentViewcontroller
        
        super.init(frame: frame)
        // 设置UI界面
        setupUI()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


//MARK: - 设置UI界面
extension PageContentView{
    
        fileprivate func setupUI(){
        //1.将所有子控制器添加到父控制器中'
        for childVC in childVcs {
            
            parentViewcontroller?.addChildViewController(childVC)
            
            
        }
        
        //2.添加UIConllectionView,用于cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
        
    }
    
    
}


//MARK: - 遵守UICollectionViewDataSource
extension PageContentView : UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return childVcs.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        //给cell设置内容
        
        for view in cell.contentView.subviews {
            
            view .removeFromSuperview()
        }
        
        let  childVC = childVcs[indexPath.item]
        cell.contentView.addSubview(childVC.view)
        return cell
        
    }
    
    
}
//MARK: - 遵守UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate{
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
      isForbidScrollDelegate = false
      startOffsetX = scrollView.contentOffset.x
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
        //判断是否是点击事件
        
       if isForbidScrollDelegate {return}
        
        
        
        
        //先定义需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        
        //2.判断左滑还是右滑
        let currenOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currenOffsetX > startOffsetX {//左滑
            //1.计算progress
            progress = currenOffsetX/scrollViewW - floor(currenOffsetX / scrollViewW)
            //2.计算当前sourceIndex
            sourceIndex = Int(scrollView.contentOffset.x / scrollViewW)
            
            //3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                
                targetIndex = childVcs.count - 1
            }
            //4.如果完全滑过去
            if currenOffsetX - startOffsetX == scrollViewW {
                
                progress = 1
                targetIndex = sourceIndex
            }
            
        }else{//右滑
            
            //1.计算progress
             progress = 1 - (currenOffsetX/scrollViewW - floor(currenOffsetX / scrollViewW))
            
            //2.计算targetIndex
            targetIndex = Int(currenOffsetX / scrollViewW)
            //3.计算当前sourceIndex
         
            sourceIndex = targetIndex + 1
            
            if sourceIndex >= childVcs.count{
                
                sourceIndex = childVcs.count - 1
            }
 
        }
        
        //3.将progress/sourceIndex/targetIndex 传递给titleView
        
        print("progress:\(progress) sourceIndex:\(sourceIndex) targetIndex:\(targetIndex)")
        
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
       
    }
    
    
}

//MARK: - 代理滚动contentView (对外界暴露)
extension PageContentView{
    
    func setCurrentIndex(_ currentIndex : Int){
        
        
        //1.记录需要禁止实行代理方法
        isForbidScrollDelegate = true
        
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated:false)
    
        
    }
    
    
}









































