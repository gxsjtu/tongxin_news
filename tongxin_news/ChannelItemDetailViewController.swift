//
//  ChannelItemDetailViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/9.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class ChannelItemDetailViewController: UIViewController {

    @IBOutlet weak var txtChannelItemDesc: UITextView!
    @IBOutlet weak var lblChannelItemDeliver: UILabel!
    @IBOutlet weak var lblChannelItemLocation: UILabel!
    @IBOutlet weak var lblChannelItemContact: UILabel!
    @IBOutlet weak var lblChannelItemMobile: UILabel!
    @IBOutlet weak var lblChannelItemQty: UILabel!
    @IBOutlet weak var lblChannelItemName: UILabel!
    @IBOutlet weak var lblChannelItemCapt: UILabel!
    
    var itemId = 0
    var navTitle = "未知"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
