//
//  MyFocusTableViewCell.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/10/20.
//  Copyright © 2015年 郭轩. All rights reserved.
//

import UIKit

class MyFocusTableViewCell: SWTableViewCell, SWTableViewCellDelegate {

    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblMarket: UILabel!
    @IBOutlet weak var lblProduct: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    weak var parentVC: MyFocusViewController?

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.delegate = self
    }
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        if index == 0
        {
            if let myFocusCell = cell as? MyFocusTableViewCell
            {
                if let id = myFocusCell.lblId.text
                {
                    let mobile = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
                    (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.OrderProduct.rawValue,parameters:["mobile": mobile!, "method": "order", "productId": id, "isOrder": false]).responseJSON{
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
                                        alert.showRedNotificationForString("取消关注失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                                    }
                                    else
                                    {
                                        if let nsindex = self.parentVC?.tvMyFocus.indexPathForCell(myFocusCell)
                                        {
                                            self.parentVC?.myFocus.removeAtIndex(index)
                                            self.parentVC?.tvMyFocus.deleteRowsAtIndexPaths([nsindex], withRowAnimation: UITableViewRowAnimation.Fade)
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
}
