//
//  CustomSlideView.swift
//  COLLE
//
//  Created by tal on 2017/7/22.
//  Copyright © 2017年 tal. All rights reserved.
//

import UIKit

protocol CustomTableViewDataSource:NSObjectProtocol {
    func CustomTableView(_ customTableView: NKCustomTableView, viewForRow itemView:UIView, and index:Int) ->UIView
}

class NKCustomTableView: UIView {
    
    var first = true
    
    lazy var views:Set<UIView> = {
        
        let size = self.frame.size
        
        var view1 = UIView()
        view1.backgroundColor = UIColor.blue
        view1.frame.size = size
        view1.tag = 1
        
        var view2 = UIView()
        view2.backgroundColor = UIColor.orange
        view2.frame.size = size
        view2.tag = 1
        
        return NSSet(array: [view1,view2]) as! Set<UIView>
    }()//初始化view,这里写的同屏最多只能看到2个所以初始化2个足够
    
    var contentOffset:CGFloat = 0 //屏幕左边到原点的距离
    
    var currentItem = 0

    var dataSource:CustomTableViewDataSource?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if first{
            for view in views {
                view.frame.origin = CGPoint(x: 0, y: 0)
                view.tag = 0
                dataSource?.CustomTableView(self, viewForRow: view, and: currentItem)
                self.addSubview(view)
                break
            }
            first = false
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //获取每次调用该方法相对上次调用时的手指偏移量
        let offset = (touches.first?.previousLocation(in: self).x)! - (touches.first?.location(in: self).x)!
        //记录当前屏幕左边到原点的距离
        contentOffset += offset

        //记录当已经显示view的左右两个边界
        var rightBound:CGFloat = 0
        var leftBound:CGFloat = CGFloat(MAXFLOAT)
        //遍历哈希表找到当前以显示的view
        for view in views {
            if view.tag == 0 {
                //将所有以显示的view进行偏移
                view.frame.origin.x = view.frame.origin.x - offset
                //判断如果该view的左边界大于屏幕最左边，或者屏幕右边界小于屏幕最右边时当前View不可见可以移除
                if view.frame.origin.x > self.frame.size.width || view.frame.origin.x < -self.frame.size.width{
                    //移除该View并将其置为可重用
                    view.removeFromSuperview()
                    for subView in view.subviews{
                        subView.removeFromSuperview()
                    }
                    view.tag = 1
                }else{
                    //当该view不会被移除时记录左右边界值
                    rightBound = max(rightBound, view.frame.origin.x + view.frame.width)
                    leftBound = min(leftBound, view.frame.origin.x)
                }
            }
        }
        //如果view可显示的右边界小于屏幕右边界意味着将有新的view出现
        if rightBound < self.frame.size.width {
            currentItem += 1
            //便利哈希表找到可重用的view
            for view in views {
                if 1 == view.tag {
                    //将该view的位置定在右边界处，并将view置为不可重用
                    view.frame.origin = CGPoint(x: rightBound, y: CGFloat(0))
                    if dataSource != nil {
                        dataSource?.CustomTableView(self, viewForRow: view, and: currentItem)
                    }
                    self.addSubview(view)
                    view.tag = 0
                    break
                }
            }
        }else if leftBound > 0{//如果view可显示的左边界大于屏幕左边界意味着将有新的view出现
            currentItem -= 1
            for view in views {
                if 1 == view.tag {
                    if dataSource != nil {
                        dataSource?.CustomTableView(self, viewForRow: view, and: currentItem)
                    }
                    view.frame.origin = CGPoint(x: leftBound - self.frame.size.width, y: CGFloat(0))
                    self.addSubview(view)
                    view.tag = 0
                    break
                }
            }
        }
    }
    
    
}
