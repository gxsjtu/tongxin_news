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
    
    weak var parentVC: PriceDetailViewController?

    @IBOutlet weak var lblPriceDetailChange: UILabel!
    @IBOutlet weak var lblPriceDetailName: UILabel!
    @IBOutlet weak var lblPriceDetailDate: UILabel!
    @IBOutlet weak var lblPriceDetailLow: UILabel!
    @IBOutlet weak var lblPriceDetailHigh: UILabel!
    @IBOutlet weak var lblPriceDetailId: UILabel!
    @IBOutlet weak var lblPriceDetailIsOrdered: UILabel!
    @IBOutlet weak var lblPriceDetailChangeCapt: UILabel!
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
                let mobile = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
                let productId = priceCell.lblPriceDetailId.text
                var isorder = "YES"
                if priceCell.lblPriceDetailIsOrdered.text == "YES"
                {
                    //取消订阅
                    isorder = "NO"
                }
                else
                {
                    //订阅
                    isorder = "YES"
                }
                
                (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.OrderProduct.rawValue,parameters:["mobile": mobile!, "method": "order", "productId": productId!, "isOrder": isorder]).responseJSON{
                    response in
                    switch response.result {
                    case .Success:
                        if let data: AnyObject = response.result.value
                        {
                            let res = JSON(data)
                            if let result = res["result"].string
                            {
                                if result == "error"
                                {
                                    let alert = SKTipAlertView()
                                    alert.showRedNotificationForString("订阅失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                                }
                                else
                                {
                                    priceCell.lblPriceDetailIsOrdered.text = isorder
                                    priceCell.hideUtilityButtonsAnimated(true)
                                    if let index = self.parentVC?.tvPriceDetail.indexPathForCell(priceCell)
                                    {
                                        self.parentVC?.updateRowAtIndexPath(index, isorder: isorder)
                                    }
                                }
                            }
                        }
                        
                    case .Failure:
                        let alert = SKTipAlertView()
                        alert.showRedNotificationForString("订阅失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                    }
                }

            }
        }
    }

}
