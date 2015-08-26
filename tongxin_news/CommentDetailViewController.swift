//
//  CommentDetailViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/26.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class CommentDetailViewController: UIViewController {
    
    var products = [(String, String, String, String, String)]()
    var market = "未知"
    var group = "未知"
    var mobile = ""
    var marketId = ""

    @IBOutlet weak var navBarCommentetail: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navBarCommentetail.topItem?.title = group + " - " + market
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
