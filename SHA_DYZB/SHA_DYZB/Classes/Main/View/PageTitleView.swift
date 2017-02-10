//
//  PageTitleView.swift
//  SHA_DYZB
//
//  Created by sha0530 on 17/2/7.
//  Copyright © 2017年 鼎. All rights reserved.
//

import UIKit

//代理定义协议
protocol PageTitleViewDelegate : class{
    
    func pageTitleView(_ titleView : PageTitleView, selectedIndex index : Int)
    
}

//定义常量

private let kScrollerLineH : CGFloat = 2
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectColor : (CGFloat,CGFloat,CGFloat) = (255,128,0)

//MARK: - 定义类
class PageTitleView: UIView {
 
    //定义属性
    fileprivate var titles:[String]
    fileprivate var currentIndex : Int = 0
    weak var delegate : PageTitleViewDelegate?
    
    //MARK: - 懒加载属性
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        
        return scrollView
    }()
    
    //MARK: - 懒加载存放Label的数组
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    //MARK: - 懒加载底部滚动线条
    fileprivate lazy var scrollLine : UIView = {
       
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        
        return scrollLine
        
    }()
    
   //MARK: - 自定义构造函数
    init(frame: CGRect,titles: [String]) {
        
        self.titles = titles
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//设置UI界面
extension PageTitleView{
    
     func setupUI(){
        //1.添加scrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        //2.添加title对应的Label
        setipTitleLabels()
        //3.设置label底部线条和滑块
        setupbottomMenuAndScrollLine()
    }
    
    private func setipTitleLabels(){
        
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollerLineH
      
        let labelY : CGFloat = 0
        for (index,title) in titles.enumerated(){
            
            //1.创建label
            let label = UILabel()
            //2.设置label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textAlignment = .center
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            
            //3.设置label的frame
              let labelX : CGFloat = labelW * CGFloat(index)
           
            
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            //4.将label添加到scrollerView上
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            //5.给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action:#selector(self.titleLabelClick(_:)))
            
            label.addGestureRecognizer(tapGes)
            
        }
        
    }
    
    
    private func setupbottomMenuAndScrollLine(){
        
        //添加底线
        let bottonLine = UIView()
        bottonLine.backgroundColor = UIColor.lightGray
        
        let lineH : CGFloat = 0.5
        bottonLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        
        addSubview(bottonLine)
        
        //2.添加scrollerLine
        
        //2.1获取第一个label
        guard let firstLabel = titleLabels.first else{ return }
        firstLabel.textColor = UIColor.orange
        
        
        //2.2设置scrollerLine的属性
        scrollView.addSubview(scrollLine)
        
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollerLineH, width: firstLabel.frame.width, height: kScrollerLineH)
        
        
    }
    
}


//mark - 监听label点击
extension PageTitleView{
    
    
    @objc fileprivate func titleLabelClick(_ tapGes : UITapGestureRecognizer){
        
        //1.获取当前label下表值
       guard let currentLabel = tapGes.view as? UILabel else {return}
        
        //2.获取之前的label
       let oldLabel = titleLabels[currentIndex]
        //3.切换文字颜色
        
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)

        //4.保存最新label
        currentIndex = currentLabel.tag
        //5.滚动条位置发生改变
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
    
        UIView.animate(withDuration: 0.12) {
            
            self.scrollLine.frame.origin.x = scrollLineX
        }
    
        //6.通知代理做事情
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
    
    
    }
    
}


//MARK: - 对外公开方法，改变title选中状态
extension PageTitleView{
    
    
    func setTitleWithProgress(progress : CGFloat,sourceIndex: Int,targetIndex: Int){
        //1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //2.处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
 
        
        // 3.颜色的渐变(复杂)
        // 3.1.取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        //4.记录最新的index
        currentIndex = targetIndex
        
        
      
        
        
    }
    
    
}





































