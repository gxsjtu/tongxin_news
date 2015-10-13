//
//  ChannelVCTableViewCell.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/8.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class ChannelVCTableViewCell: UITableViewCell {

    @IBOutlet weak var lblChannelItemId: UILabel!
    @IBOutlet weak var lblChannelCellDate: UILabel!
    @IBOutlet weak var lblChannelCellContact: UILabel!
    @IBOutlet weak var lblChannelCellName: UILabel!
    @IBOutlet weak var lblChannelCellLocation: UILabel!
    @IBOutlet weak var imgChannelCellAvatar: UIImageView!
    @IBOutlet weak var lblChannelCellIsChecked: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {

        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
