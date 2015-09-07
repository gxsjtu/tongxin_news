//
//  EcosystemViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/6.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class EcosystemViewController: UIViewController {
    
    var channels = [(String, String)]()
    var channelCount = 0
    @IBOutlet weak var navEco: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func  unwindFromChannel2Ecosystem(segue: UIStoryboardSegue)
    {
        
    }
    
    func channelButtonClicked(sender: UIButton)
    {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = Int(sender.tag)
        des.channelName = sender.titleLabel!.text!
        self.presentViewController(des, animated: true, completion: nil)
    }
    
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
                                self.channels.append((i["id"]!.stringValue, i["Name"]!.stringValue))
                            }
                        }
                        for(id, name) in self.channels
                        {
                            var dk: DKCircleButton?
                            let delta = (Int)(self.view.frame.width - 90 * 3 - 15 * 2) / 2
                            
                            if self.channelCount % 3 == 0
                            {
                                dk = DKCircleButton(frame: CGRect(x: delta, y: (self.channelCount / 3) * 105 + 20, width: 90, height: 90))
                            }
                            else if self.channelCount % 3 == 1
                            {
                                dk = DKCircleButton(frame: CGRect(x: 105 + delta, y: (self.channelCount / 3) * 105 + 20, width: 90, height: 90))
                            }
                            else if self.channelCount % 3 == 2
                            {
                                dk = DKCircleButton(frame: CGRect(x: 2 * 105 + delta, y: (self.channelCount / 3) * 105 + 20, width: 90, height: 90))
                            }
                            self.vEcoChannels.addSubview(dk!)
                            dk!.setTitle(name, forState: UIControlState.Normal)
                            dk!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                            dk!.backgroundColor = UIColor.randomFlatDarkColor()
                            dk!.addTarget(self, action: "channelButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                            dk!.tag = id.toInt()!
                            self.channelCount++
                        }
                        self.vEcoChannels.contentSize = CGSize(width: Double(self.view.frame.width), height: Double((self.channelCount / 3) * 135))
                    }
                }
        }
    }


}
