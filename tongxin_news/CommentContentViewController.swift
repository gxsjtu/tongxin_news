//
//  CommentContentViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/27.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class CommentContentViewController: UIViewController {
    
    var navTitle = "未知"
    var url = "http://app.shtx.com.cn/404.html"

    @IBOutlet weak var wvCommentContent: UIWebView!
    @IBOutlet weak var navCommentContent: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navCommentContent.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        self.navCommentContent.topItem?.title = navTitle
        self.wvCommentContent.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
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
