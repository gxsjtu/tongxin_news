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
        
        }
    }
}
