//
//  FuturesViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/14.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class FuturesViewController: UIViewController {

    @IBOutlet weak var navFutures: UINavigationBar!
    @IBOutlet weak var wvFutures: UIWebView!
    var url = "http://222.73.7.157:81/html5qh/index.html?a=12345"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navFutures.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        self.wvFutures.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
    }

    @IBAction func didrefreshFutures(sender: AnyObject) {
                self.wvFutures.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
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
