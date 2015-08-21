//
//  UserSettingViewController.swift
//  tongxin_news
//
//  Created by 上海益润 on 15/8/21.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import Foundation

class UserSettingViewController : UIViewController
{
   @IBOutlet weak var TxtMoblie: UITextField!
    
   @IBOutlet weak var TxtDateValue: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 加载判断登陆状态
        IsLogin()
        
        //设置文本为只读
        self.TxtMoblie.enabled = false
        self.TxtDateValue.enabled = false
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func IsLogin(){
        var isLogined : String? = NSUserDefaults.standardUserDefaults().stringForKey("isLoggedIn")
        if(isLogined != "yes")
        {
            //转向login页面
            if let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
            {
                self.presentViewController(loginVC, animated: true, completion: nil)
            }
        }
    }

}
