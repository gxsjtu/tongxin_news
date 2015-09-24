//
//  CommentDetailVCTableViewCell.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/26.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class CommentDetailVCTableViewCell: SWTableViewCell, SWTableViewCellDelegate {
    
    weak var parentVC: CommentDetailViewController?
    
    @IBOutlet weak var lblCommentProductId: UILabel!
    @IBOutlet weak var lblCommentDetailTitle: UILabel!
    @IBOutlet weak var imgCommentDetailLogo: UIImageView!
    @IBOutlet weak var lblCommentDetailDate: UILabel!
    @IBOutlet weak var lblCommentDetailName: UILabel!
    @IBOutlet weak var lblCommentDetailUrl: UILabel!
    @IBOutlet weak var lblCommentDetailIsOrdered: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

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
            if let priceCell = cell as? CommentDetailVCTableViewCell
            {
                let mobile = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
                let productId = priceCell.lblCommentProductId.text
                var isorder = "YES"
                if priceCell.lblCommentDetailIsOrdered.text == "YES"
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
                                    priceCell.lblCommentDetailIsOrdered.text = isorder
                                    priceCell.hideUtilityButtonsAnimated(true)
                                    self.parentVC?.updateRowAtIndexPath((self.parentVC?.tvCommentDetail.indexPathForCell(priceCell))!, isorder: isorder)
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
