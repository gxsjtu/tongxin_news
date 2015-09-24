//
//  LogInViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/20.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btnLogInPwd: UITextField!
    @IBOutlet weak var btnLogInName: UITextField!
    @IBOutlet weak var imgLogInBg: UIImageView!
    @IBOutlet weak var imgLogInLogo: UIImageView!
    @IBOutlet weak var lblMobile: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imgLogInBg.image = UIImage(named: "background")
        imgLogInLogo.image = UIImage(named: "logo")
        btnLogInName.delegate = self
        btnLogInPwd.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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
        (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.SignIn.rawValue, parameters: ["mobile": mobile, "password": password, "method": "signin", "token": token!,])
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
