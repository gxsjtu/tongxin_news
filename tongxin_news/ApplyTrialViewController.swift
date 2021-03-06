//
//  ApplyTrialViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/24.
//  Copyright © 2015年 郭轩. All rights reserved.
//

import UIKit

class ApplyTrialViewController: UIViewController {

    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet weak var navApplyTrial: UINavigationBar!
    
    @IBAction func didRegisterClicked(sender: AnyObject) {
        let mobile = txtMobile.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if mobile == ""
        {
            let alert = SKTipAlertView()
            alert.showRedNotificationForString("手机号不能为空！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
            return
        }
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.Register.rawValue, parameters: ["mobile": mobile, "method": "trial"])
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
                            alert.showGreenNotificationForString("申请成功，请返回登陆页！", forDuration: 4.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                        }
                        else
                        { 
                            let alert = SKTipAlertView()
                            alert.showRedNotificationForString(result, forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                        }
                    }
                case .Failure:
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("注册失败，请重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
        }

    }
    
    @IBOutlet weak var txtMobile: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.txtMobile.leftViewMode = UITextFieldViewMode.Always
        self.txtMobile.leftView = UIImageView(image: UIImage(named: "mobile.png"))
        self.txtDesc.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
                self.txtMobile.endEditing(false)
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
