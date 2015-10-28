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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guideImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.height, height: self.view.frame.width))
        guideImage?.userInteractionEnabled = true
        self.view.addSubview(guideImage!)
        
        guideTap = UITapGestureRecognizer()
        guideTap?.numberOfTapsRequired = 1
        guideTap?.delegate = self
        self.guideImage?.addGestureRecognizer(self.guideTap!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName("Badge", object: nil, userInfo: nil)
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
