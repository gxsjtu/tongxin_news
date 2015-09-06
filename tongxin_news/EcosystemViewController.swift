//
//  EcosystemViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/6.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class EcosystemViewController: UIViewController {
    
    var channels: Dictionary<String, String> = Dictionary<String, String>()
    var channelCount = 0
    @IBOutlet weak var navEco: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vEcoChannels.showsVerticalScrollIndicator = true
        self.navEco.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        getChannels()
    }
    @IBOutlet weak var vEcoChannels: UIScrollView!

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
    
    func getChannels()
    {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        request(.GET, EndPoints.Channel.rawValue, parameters: ["method": "getchannel"])
            .responseJSON { (request, response, data, error) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if let anError = error
                {
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
                else if let data: AnyObject = data
                {
                    if let res = JSON(data).array
                    {
                        self.channels.removeAll(keepCapacity: true)
                        for item in res
                        {
                            if let i = item.dictionary
                            {
                                self.channels[i["id"]!.stringValue] = i["Name"]!.stringValue
                            }
                        }
                        for(id, name) in self.channels
                        {
                            let dk = DKCircleButton(frame: CGRect(x: (self.channelCount % 3) * 105 + 10, y: (self.channelCount / 3) * 105 + 10, width: 90, height: 90))
                            self.vEcoChannels.addSubview(dk)
                            dk.setTitle(name, forState: UIControlState.Normal)
                            dk.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                            dk.backgroundColor = UIColor.redColor()
                            self.channelCount++
                        }
                        self.vEcoChannels.contentSize = CGSize(width: Double(self.view.frame.width), height: Double((self.channelCount / 3) * 135))
                    }
                }
        }
    }


}
