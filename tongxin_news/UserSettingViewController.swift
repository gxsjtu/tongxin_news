//
//  UserSettingController.swift
//  tongxin_news
//
//  Created by 上海益润 on 15/8/21.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class UserSettingViewController : UIViewController
{

    @IBOutlet weak var TxtMobile: UITextField!
    
    @IBOutlet weak var imgUserBackground: UIImageView!
    @IBOutlet weak var imgUserLogo: UIImageView!
    @IBOutlet weak var TxtDateValue: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TxtMobile.enabled = false
        self.TxtDateValue.enabled = false
        
        imgUserBackground.image = UIImage(named: "background")
        imgUserLogo.image = UIImage(named: "logo")
        
        IsLogin()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func IsLogin()
    {
        let isLogined : String? = NSUserDefaults.standardUserDefaults().stringForKey("isLoggedIn")

        if(isLogined != "yes")
        {
            //转向login页面
            if let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
            {
                self.presentViewController(loginVC, animated: true, completion: nil)
            }
        }
        else
        {
            let mobile : String? = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.UserSet.rawValue, parameters:["mobile":mobile!,"method":"getUserInfo"])
                .responseJSON { response in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    
                    switch response.result {
                    case .Success:
                        let res = JSON(response.result.value!)
                        if let result = res["endDate"].string
                        {
                            self.TxtDateValue.text = result
                            self.TxtMobile.text = mobile
                        }
                    case .Failure:
                        let alert = SKTipAlertView()
                        alert.showRedNotificationForString("加载失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
                    
            }
        }
    }
    
    @IBAction func LoginOutClick(sender: AnyObject) {
        //点击退出按钮删除存储的登录用户信息
        NSUserDefaults.standardUserDefaults().removeObjectForKey("isLoggedIn")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("mobile")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
        //转向login页面
        if let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
        {
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
    }
}