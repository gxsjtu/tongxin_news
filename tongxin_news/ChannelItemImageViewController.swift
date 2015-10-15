//
//  ChannelItemImageViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/10/12.
//  Copyright © 2015年 郭轩. All rights reserved.
//

import UIKit

class ChannelItemImageViewController: UIViewController {
    
    var image: UIImage?

    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet weak var channelItemImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.channelItemImage.contentMode = UIViewContentMode.ScaleToFill
        self.channelItemImage.image = self.image
        tap.numberOfTapsRequired = 1
        self.channelItemImage.userInteractionEnabled = true
        self.channelItemImage.addGestureRecognizer(tap)
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
