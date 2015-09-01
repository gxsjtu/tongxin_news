//
//  PriceHistoryTableViewCell.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/28.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class PriceHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPriceHistoryChange: UILabel!
    @IBOutlet weak var lblPriceHistoryDate: UILabel!
    @IBOutlet weak var lblPriceHistoryLow: UILabel!
    @IBOutlet weak var lblPriceHistoryHigh: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
