    //
//  AIIBounceInsistDaysView.swift
//  SleepEarly
//
//  Created by JustinChou on 5/22/17.
//  Copyright © 2017 JustinChou. All rights reserved.
//

import UIKit

class AIIBounceInsistDaysView: UIView {
    
    let kTableViewCellID = "kTableViewCellID"
    
    var days: String? {
        didSet {
            // todo:-
            transferFromDaysToNumberArray()
            bounceToCorrentDays()
        }
    }
    
    var numberArray: [String] = ["0", "0", "0", "0"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xmt_setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AIIBounceInsistDaysView: UITabBarDelegate,UITableViewDataSource,UITableViewDelegate {
    /// initialize the children view
    func xmt_setupUI() {
        
        backgroundColor = UIColor.lightGray
        let w = frame.size.width / 4
        let h = frame.size.height
        
        for i in 0...3 {
            let tableView: UITableView = UITableView.init(frame: CGRect.init(x: CGFloat(i) * w, y: 0, width: w, height: h), style: .plain)
            print("\(tableView.frame)")
            tableView.register(AIIBounceDaysTableViewCell.self, forCellReuseIdentifier: kTableViewCellID)
            
            tableView.tag = 1000 + i
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.delegate = self
            tableView.dataSource = self
            addSubview(tableView)
        }
    }
    
    // MARK:- TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AIIBounceDaysTableViewCell = tableView.dequeueReusableCell(withIdentifier: kTableViewCellID, for: indexPath) as! AIIBounceDaysTableViewCell
        cell.number = "\(indexPath.row)"
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.size.height
    }
    
    
    /// 跳到正确天数
    public func bounceToCorrentDays() {
        let length = numberArray.count
        for i in 0...(length - 1) {
            let tableView: UITableView = viewWithTag(1000 + i) as! UITableView
            let number = CGFloat((numberArray[i] as NSString).floatValue)
            let point: CGPoint = CGPoint(x: 0, y: number * frame.size.height)
            print("\(point)")
            tableView.setContentOffset(point, animated: true)
        }
    }
    
    /// 将数字分割成单个字符存储在数组中
    func transferFromDaysToNumberArray() {
        
        // 清零
        numberArray = ["0", "0", "0", "0"]
        
        let count: Int = (days?.characters.count)!
        let difference = numberArray.count - count
        
        guard let numberDays = days else {
            return
        }
        
        for i in (0...(count - 1)).reversed(){
            let singleNumber = numberDays[numberDays.index(numberDays.startIndex, offsetBy: i)]
            numberArray[difference + i] = "\(singleNumber)"
        }
    }
}
