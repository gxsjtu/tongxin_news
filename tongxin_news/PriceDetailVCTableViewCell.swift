//
//  PriceDetailVCTableViewCell.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/25.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class PriceDetailVCTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var lblPriceDetailName: UILabel!
    @IBOutlet weak var lblPriceDetailDate: UILabel!
    @IBOutlet weak var lblPriceDetailLow: UILabel!
    @IBOutlet weak var lblPriceDetailHigh: UILabel!
    @IBOutlet weak var lblPriceDetailId: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
