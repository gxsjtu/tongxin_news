//
//  ForgetPasswordViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/25.
//  Copyright © 2015年 郭轩. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBAction func didSendPasswodClicked(sender: AnyObject) {
        let mobile = txtMobile.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if mobile == ""
        {
            let alert = SKTipAlertView()
            alert.showRedNotificationForString("请输入注册的手机号码！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
            return
        }
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.Register.rawValue, parameters: ["mobile": mobile, "method": ""])
            .responseJSON { response in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                switch response.result {
                case .Success:
                    let res = JSON(response.result.value!)
                    if let result = res["result"].string
                    {
                        if result == "ok"
                        {
                            let alert = SKTipAlertView()
                            alert.showGreenNotificationForString("密码已发送至该手机，请查收！", forDuration: 4.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                        }
                        else
                        {
                            let alert = SKTipAlertView()
                            alert.showRedNotificationForString("该手机号尚未注册，请使用有效手机号码！", forDuration: 4.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                        }
                    }
                case .Failure:
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("短信发送失败，请重试！", forDuration: 4.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
        }
    }
    
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var navForgetPassword: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navForgetPassword.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
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
