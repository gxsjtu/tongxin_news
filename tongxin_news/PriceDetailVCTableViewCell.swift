//
//  PriceDetailVCTableViewCell.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/25.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class PriceDetailVCTableViewCell: SWTableViewCell, SWTableViewCellDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var lblPriceDetailChange: UILabel!
    @IBOutlet weak var lblPriceDetailName: UILabel!
    @IBOutlet weak var lblPriceDetailDate: UILabel!
    @IBOutlet weak var lblPriceDetailLow: UILabel!
    @IBOutlet weak var lblPriceDetailHigh: UILabel!
    @IBOutlet weak var lblPriceDetailId: UILabel!
    @IBOutlet weak var lblPriceDetailIsOrdered: UILabel!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        if index == 0
        {
            if let priceCell = cell as? PriceDetailVCTableViewCell
            {
                var mobile = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
                var productId = priceCell.lblPriceDetailId.text
                if priceCell.lblPriceDetailIsOrdered.text == "yes"
                {
                    //取消订阅
                }
                else
                {
                    //订阅
                }
            }
        }
    }

}
