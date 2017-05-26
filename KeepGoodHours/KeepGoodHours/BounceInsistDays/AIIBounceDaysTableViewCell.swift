//
//  AIIBounceDaysTableViewCell.swift
//  SleepEarly
//
//  Created by JustinChou on 5/22/17.
//  Copyright © 2017 JustinChou. All rights reserved.
//

import UIKit

class AIIBounceDaysTableViewCell: UITableViewCell {

    var number: String? {
        didSet {
            numberLabel.text = number
        }
    }
    
    var numberLabel: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        xmt_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 历史遗留问题，由于初始化时 cell 的默认 宽 高 就是320 44 如果需要自定大小或者控件，必须放在这里面才行
        print("contentView:\(contentView.frame)")
        addSubview(numberLabel)
    }

}

extension AIIBounceDaysTableViewCell {
    func xmt_setupUI() {
        numberLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 40))
        numberLabel.textAlignment = .center
        contentView.backgroundColor = UIColor.randomColor()
    }
}









