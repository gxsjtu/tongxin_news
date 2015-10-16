//
//  EcosystemViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/6.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class EcosystemViewController: UIViewController {
    
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var svBase: UIScrollView!
    @IBOutlet weak var navEco: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func jibenjinshu(sender: AnyObject) {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = 1
        des.channelName = "基本金属"
        self.presentViewController(des, animated: true, completion: nil)
    }
    
    
    @IBAction func feijiuyouse(sender: AnyObject) {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = 2
        des.channelName = "废旧有色"
        self.presentViewController(des, animated: true, completion: nil)
    }
    @IBOutlet weak var feijiuyouse: UIButton!
    
    @IBAction func guijinshu(sender: AnyObject) {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = 3
        des.channelName = "贵金属"
        self.presentViewController(des, animated: true, completion: nil)
    }
    @IBOutlet weak var guijinshu: UIButton!
    @IBAction func  unwindFromChannel2Ecosystem(segue: UIStoryboardSegue)
    {
        
    }
    
    @IBAction func qita(sender: AnyObject) {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = 15
        des.channelName = "其他"
        self.presentViewController(des, animated: true, completion: nil)
    }
    @IBAction func zaishengsuoliao(sender: AnyObject) {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = 14
        des.channelName = "再生塑料"
        self.presentViewController(des, animated: true, completion: nil)
    }
    @IBAction func feizhi(sender: AnyObject) {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = 13
        des.channelName = "废纸"
        self.presentViewController(des, animated: true, completion: nil)
    }
    @IBAction func xiyouxiaojinshu(sender: AnyObject) {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = 12
        des.channelName = "稀有小金属"
        self.presentViewController(des, animated: true, completion: nil)
    }
    @IBOutlet weak var xiyouxiaojinshu: UIButton!
    @IBAction func tiehejin(sender: AnyObject) {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = 11
        des.channelName = "铁合金"
        self.presentViewController(des, animated: true, completion: nil)
    }
    @IBAction func tiekuangshi(sender: AnyObject) {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = 10
        des.channelName = "铁矿石"
        self.presentViewController(des, animated: true, completion: nil)
    }
    @IBAction func shengtie(sender: AnyObject) {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = 9
        des.channelName = "生铁"
        self.presentViewController(des, animated: true, completion: nil)
    }
    @IBAction func buxiugang(sender: AnyObject) {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = 8
        des.channelName = "不锈钢"
        self.presentViewController(des, animated: true, completion: nil)
    }
    @IBAction func feibuxiugang(sender: AnyObject) {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = 7
        des.channelName = "废不锈钢"
        self.presentViewController(des, animated: true, completion: nil)
    }
    @IBAction func gangpi(sender: AnyObject) {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = 6
        des.channelName = "钢坯"
        self.presentViewController(des, animated: true, completion: nil)
    }
    @IBAction func jiancai(sender: AnyObject) {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = 5
        des.channelName = "建材"
        self.presentViewController(des, animated: true, completion: nil)
    }
    @IBAction func feigang(sender: AnyObject) {
        let des = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
        des.channelId = 4
        des.channelName = "废钢"
        self.presentViewController(des, animated: true, completion: nil)
    }
}
