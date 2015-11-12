//
//  InboxTableViewCell.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/11/2.
//  Copyright © 2015年 郭轩. All rights reserved.
//

import UIKit

class InboxTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var vCellMain: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        let selection = UIView(frame: self.vCellMain.frame)
        selection.layer.cornerRadius = 8.0
        selection.backgroundColor = UIColor(red: 180/255, green: 138/255, blue: 171/255, alpha: 0.5)
        self.selectedBackgroundView = selection
    }
}
