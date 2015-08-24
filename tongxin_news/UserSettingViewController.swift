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
    else
    {
           var mobile : String? = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
        
            request(.GET, EndPoints.UserSet.rawValue, parameters:["mobile":mobile!,"method":"getUserInfo"])
                .responseJSON { (request,response,data,error) in
                
                if let anError = error
                {
                    println(anError)
                }
                else if let data: AnyObject = data
                {
                    let res = JSON(data)
                    if let result = res["endDate"].string
                    {
                        self.TxtDateValue.text = result
                        self.TxtMobile.text = mobile
                    }
                }
                
           }
    }
    }
    
    @IBAction func LoginOutClick(sender: AnyObject) {
        //点击退出按钮删除存储的登录用户信息
        NSUserDefaults.standardUserDefaults().removeObjectForKey("isLoggedIn")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("mobile")
        //转向login页面
        if let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
        {
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
    }
}