//
//  CommentDetailVCTableViewCell.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/26.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class CommentDetailVCTableViewCell: UITableViewCell {
    @IBOutlet weak var lblCommentDetailTitle: UILabel!
    @IBOutlet weak var imgCommentDetailLogo: UIImageView!
    @IBOutlet weak var lblCommentDetailDate: UILabel!
    @IBOutlet weak var lblCommentDetailName: UILabel!
    @IBOutlet weak var lblCommentDetailUrl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
