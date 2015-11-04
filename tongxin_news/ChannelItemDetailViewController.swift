//
//  ChannelItemDetailViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/9.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class ChannelItemDetailViewController: UITableViewController {

    @IBOutlet weak var cellDesc: UITableViewCell!
    @IBOutlet weak var cellMobile: UITableViewCell!
    @IBOutlet weak var cellDelivery: UITableViewCell!
    @IBOutlet weak var cellLocation: UITableViewCell!
    @IBOutlet weak var cellContact: UITableViewCell!
    @IBOutlet weak var cellPrice: UITableViewCell!
    @IBOutlet weak var cellQty: UITableViewCell!
    @IBOutlet weak var cellSP: UITableViewCell!
    @IBOutlet weak var slideChannelItem: KASlideShow!
    
    var itemId = "0"
    var navTitle = "未知"
    var mobile = ""
    var tap: UITapGestureRecognizer?
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.rowHeight = 100
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        getChannelItemDetail()
        self.title = navTitle
        self.slideChannelItem.transitionDuration = 3.0
        self.slideChannelItem.transitionType = KASlideShowTransitionType.Slide
        self.slideChannelItem.imagesContentMode = UIViewContentMode.ScaleToFill
        
        tap = UITapGestureRecognizer(target: self, action: "tapOnSlide:")
        tap?.numberOfTapsRequired = 1
        self.slideChannelItem.addGestureRecognizer(tap!)
        
        self.cellSP.imageView?.image = UIImage(named: "sp_name")
        self.cellPrice.imageView?.image = UIImage(named: "sp_price")
        self.cellLocation.imageView?.image = UIImage(named: "sp_location")
        self.cellDelivery.imageView?.image = UIImage(named: "sp_delivery")
        self.cellContact.imageView?.image = UIImage(named: "sp_contact")
        self.cellQty.imageView?.image = UIImage(named: "sp_qty")
        self.cellMobile.imageView?.image = UIImage(named: "sp_mobile")
        self.cellDesc.imageView?.image = UIImage(named: "sp_desc")
        
        self.cellDesc.textLabel?.font = UIFont.systemFontOfSize(15)
        self.cellDesc.textLabel?.numberOfLines = 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 5
        {
            UIApplication.sharedApplication().openURL(NSURL(string: ("tel://" + mobile))!)
        }
    }
    
    func tapOnSlide(recognizer:UITapGestureRecognizer) {
        
        let channelItemImage = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelItemImageVC") as! ChannelItemImageViewController
        channelItemImage.image = slideChannelItem.images[(Int)(self.slideChannelItem.currentIndex)] as? UIImage
        self.presentViewController(channelItemImage, animated: true, completion: nil)
    }

    @IBAction func didRefreshChannelItems(sender: AnyObject) {
        getChannelItemDetail()
    }
    
    @IBAction func unwindFromImage2Detail(segue: UIStoryboardSegue)
    {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindFromDetail2List"
        {
            self.slideChannelItem.stop()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        getChannelItemDetail()
    }
    
    func getChannelItemDetail()
    {
         MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.SPList.rawValue, parameters: ["method": "getitem", "id": itemId])
            .responseJSON { response in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                switch response.result {
                case .Success:
                    if let data: AnyObject = response.result.value
                    {
                        if let i = JSON(data).dictionary
                        {
                            if i["deliver"]!.stringValue == "true"
                            {
                                self.cellDelivery.textLabel?.text = "自提"
                            }
                            else
                            {
                                self.cellDelivery.textLabel?.text = "发货"
                            }
                            self.cellContact.textLabel?.text = i["contact"]!.stringValue
                            self.cellLocation.textLabel?.text = i["location"]!.stringValue
                            self.mobile = i["mobile"]!.stringValue
                            self.cellMobile.textLabel?.text = self.mobile + "（点击拨打）"
                            self.cellSP.textLabel?.text  = i["name"]!.stringValue
                            self.cellQty.textLabel?.text = i["quantity"]!.stringValue
                            self.cellDesc.textLabel?.text = i["description"]!.stringValue
                            self.cellPrice.textLabel?.text = i["price"]!.stringValue
          
                            self.slideChannelItem.images.removeAllObjects()
                            for avatars in i["avatars"]!.arrayValue
                            {
                                if let avatar = avatars.dictionary
                                {
                                    MBProgressHUD.showHUDAddedTo(self.slideChannelItem, animated: true)
                                    SDWebImageDownloader.sharedDownloader().downloadImageWithURL(NSURL(string: avatar["avatar"]!.stringValue), options: SDWebImageDownloaderOptions(), progress: nil, completed: { (image: UIImage!, data: NSData!, error: NSError!, finished: Bool) -> Void in
                                        if finished == true
                                        {
                                            self.slideChannelItem.addImage(image)
                                            MBProgressHUD.hideAllHUDsForView(self.slideChannelItem, animated: true)
                                            self.slideChannelItem.start()
                                        }})
                                }
                            }
                        }
                    }
                    
                case .Failure:
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请点击右上角刷新重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
        }
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
