//
//  HomeTabBarViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/21.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController, UIGestureRecognizerDelegate {
    
    var guideTap: UITapGestureRecognizer?
    var guideImage: UIImageView?
    var guideImages = ["g_inbox", "g_price", "g_comment", "g_circle", "g_futures"]
    var isFromLoggin = false
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guideImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        guideImage?.userInteractionEnabled = false
        self.view.addSubview(guideImage!)
        
        guideTap = UITapGestureRecognizer()
        guideTap?.numberOfTapsRequired = 1
        guideTap?.delegate = self
        guideTap?.addTarget(self, action: Selector("tapOnMain:"))
        self.guideImage?.addGestureRecognizer(self.guideTap!)
        
        if isFromLoggin == true
        {
             if let isFirstLogged = NSUserDefaults.standardUserDefaults().stringForKey("isFirstLogged")
             {
                if isFirstLogged == "yes"
                {
                    self.guideImage?.userInteractionEnabled = true
                    count = 0
                    guideImage?.image = UIImage(named: guideImages[count])
                }
                else
                {
                    //播放广告
                }
             }
        }
    }
    
    func tapOnMain(tap: UITapGestureRecognizer)
    {
        count++;
        if self.guideImages.count <= count
        {
            self.guideImage?.image = nil
            self.guideImage?.userInteractionEnabled = false
            self.guideTap?.removeTarget(self, action: Selector("tapOnMain:"))
        }
        else
        {
            self.guideImage?.image = UIImage(named: guideImages[count])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName("Badge", object: nil, userInfo: nil)
        print("home will appear")
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
