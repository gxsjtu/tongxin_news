//
//  ChannelCatalogTableViewCell.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/7.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class ChannelCatalogTableViewCell: UITableViewCell {

    @IBOutlet weak var vChannelCatalogCell: UIView!
    @IBOutlet weak var lblChannelCatalogId: UILabel!
    @IBOutlet weak var lblChannelCatalogDesc: UILabel!
    @IBOutlet weak var lblChannelCatalogName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        let cellSelectionView = UIView(frame: vChannelCatalogCell.frame)
        cellSelectionView.backgroundColor = UIColor(red: 180/255, green: 138/255, blue: 171/255, alpha: 0.5)
        cellSelectionView.layer.cornerRadius = 10.0
        self.selectedBackgroundView = cellSelectionView
    }
}
