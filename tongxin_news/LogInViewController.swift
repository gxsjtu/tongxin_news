//
//  LogInViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/20.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    var isForcedLogout = false
    
    @IBAction func didCallClicked(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://021-62156169")!)
    }
    @IBOutlet weak var btnApplyTrial: UIButton!
    @IBOutlet weak var btnLogInPwd: UITextField!
    @IBOutlet weak var btnLogInName: UITextField!
    @IBOutlet weak var imgLogInBg: UIImageView!
    @IBOutlet weak var imgLogInLogo: UIImageView!
    @IBOutlet weak var lblMobile: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.btnLogInName.endEditing(false)
        self.btnLogInPwd.endEditing(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imgLogInLogo.image = UIImage(named: "logo")
        btnApplyTrial.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
       
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if isForcedLogout == true
        {
            let alert = SKTipAlertView()
            alert.showRedNotificationForString("该账号已从其他客户端登录，您已被强制下线！", forDuration: 4.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindFromApplyTrial2Login(segue: UIStoryboardSegue)
    {

    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func didLogInClicked(sender: AnyObject) {
        let mobile = lblMobile.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let password = lblPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let token = NSUserDefaults.standardUserDefaults().stringForKey("token")
        
        if mobile == ""
        {
            let alert = SKTipAlertView()
            alert.showRedNotificationForString("手机号不能为空！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
            return
        }
        
        if password == ""
        {
            let alert = SKTipAlertView()
            alert.showRedNotificationForString("密码不能为空！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
            return
        }
        
        if token == nil
        {
            let alert = SKTipAlertView()
            alert.showRedNotificationForString("获取设备码失败，请重新登录！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
            return
        }
        
         MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.SignIn.rawValue, parameters: ["mobile": mobile, "password": password, "method": "signin", "token": token!])
            .responseJSON { response in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                switch response.result {
                case .Success:
                    let res = JSON(response.result.value!)
                    if let result = res["result"].string
                    {
                        if result == "error"
                        {
                            let alert = SKTipAlertView()
                            alert.showRedNotificationForString("账号密码错误，请重新输入！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                        }
                        else
                        {
                            NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "isLoggedIn")
                            NSUserDefaults.standardUserDefaults().setObject(mobile, forKey: "mobile")
                            NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password")
                            //转向home页面
                            if let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeTabBarVC") as? HomeTabBarViewController
                            {
                                self.presentViewController(homeVC, animated: true, completion: nil)
                            }
                        }
                    }
                case .Failure:
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
        }
    }
}
