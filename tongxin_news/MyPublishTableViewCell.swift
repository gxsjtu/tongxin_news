//
//  MyPublishTableViewCell.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/10/20.
//  Copyright © 2015年 郭轩. All rights reserved.
//

import UIKit

class MyPublishTableViewCell: SWTableViewCell, SWTableViewCellDelegate {

    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblAvatar: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblApproval: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNameCapt: UILabel!
    weak var parentVC: MyPublishViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

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
            if let myPublishCell = cell as? MyPublishTableViewCell
            {
                if let id = myPublishCell.lblId.text
                {
                    (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.SPList.rawValue,parameters:["method": "deleteSupply", "id": id]).responseJSON{
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
                                        alert.showRedNotificationForString("删除失败，请重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                                    }
                                    else
                                    {
                                        if let nsindex = self.parentVC?.tvMyPublish.indexPathForCell(myPublishCell)
                                        {
                                            self.parentVC?.myPublish.removeAtIndex(index)
                                            self.parentVC?.tvMyPublish.deleteRowsAtIndexPaths([nsindex], withRowAnimation: UITableViewRowAnimation.Fade)
                                        }
                                    }
                                }
                            }
                            
                        case .Failure:
                            let alert = SKTipAlertView()
                            alert.showRedNotificationForString("删除失败，请重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                        }
                    }

                }
            }
        }
    }
}
