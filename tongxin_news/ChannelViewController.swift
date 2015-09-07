//
//  ChannelViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/7.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {

    var channelName = "未知"
    var channelId = 0
    @IBOutlet weak var segChannel: UISegmentedControl!
    @IBOutlet weak var btnChannelAdd: UIBarButtonItem!
    @IBOutlet weak var navChannel: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navChannel.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindFromChannelCatalog2Channel(segue: UIStoryboardSegue)
    {
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Channel2ChannelCatalog"
        {
            if let des = segue.destinationViewController as? ChannelCatalogViewController
            {
                des.channelName = self.channelName
                des.channelId = self.channelId
            }
        }

    }
}
