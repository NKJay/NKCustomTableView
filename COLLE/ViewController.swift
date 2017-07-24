//
//  ViewController.swift
//  COLLE
//
//  Created by tal on 2017/7/21.
//  Copyright © 2017年 tal. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CustomTableViewDataSource {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cutomView = NKCustomTableView()
        cutomView.frame = self.view.frame
        cutomView.dataSource = self
        cutomView.backgroundColor = UIColor.white

        self.view.addSubview(cutomView)
    }
    
    
    func CustomTableView(_ customTableView: NKCustomTableView, viewForRow itemView:UIView, and index:Int) ->UIView {
        let textView = UITextView()
        textView.text = "index" + String(index)
        textView.sizeToFit()
        textView.center = view.center
        itemView.addSubview(textView)
        return view
    }
}

