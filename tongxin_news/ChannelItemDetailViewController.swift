//
//  ChannelItemDetailViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/9.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class ChannelItemDetailViewController: UIViewController {

    @IBAction func didCallClicked(sender: AnyObject) {
            UIApplication.sharedApplication().openURL(NSURL(string: ("tel://" + mobile))!)
    }
    @IBOutlet weak var btnMobile: UIButton!
    @IBOutlet weak var slideChannelItem: KASlideShow!
    @IBOutlet weak var txtChannelItemDesc: UITextView!
    @IBOutlet weak var lblChannelItemDeliver: UILabel!
    @IBOutlet weak var lblChannelItemLocation: UILabel!
    @IBOutlet weak var lblChannelItemContact: UILabel!
    @IBOutlet weak var lblChannelItemQty: UILabel!
    @IBOutlet weak var lblChannelItemName: UILabel!
    @IBOutlet weak var lblChannelItemCapt: UILabel!
    @IBOutlet weak var navChannelItemDetail: UINavigationBar!
    
    var itemId = "0"
    var navTitle = "未知"
    var mobile = ""
    var tap: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getChannelItemDetail()
        self.navChannelItemDetail.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        self.navChannelItemDetail.topItem?.title = navTitle
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.slideChannelItem.transitionDuration = 3.0
        self.slideChannelItem.transitionType = KASlideShowTransitionType.Slide
        self.slideChannelItem.imagesContentMode = UIViewContentMode.ScaleToFill
        btnMobile.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        tap = UITapGestureRecognizer(target: self, action: "tapOnSlide:")
        tap?.numberOfTapsRequired = 1
        self.slideChannelItem.addGestureRecognizer(tap!)
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
                            if i["type"]!.stringValue == "true"
                            {
                                self.lblChannelItemCapt.text = "采购："
                            }
                            else
                            {
                                self.lblChannelItemCapt.text = "销售："
                            }
                            if i["deliver"]!.stringValue == "true"
                            {
                                self.lblChannelItemDeliver.text = "自提"
                            }
                            else
                            {
                                self.lblChannelItemDeliver.text = "发货"
                            }
                            self.lblChannelItemContact.text = i["contact"]!.stringValue
                            self.lblChannelItemLocation.text = i["location"]!.stringValue
                            self.mobile = i["mobile"]!.stringValue
                            self.btnMobile.setTitle(self.mobile + "（点击拨打）", forState: UIControlState.Normal)
                            self.lblChannelItemName.text = i["name"]!.stringValue
                            self.lblChannelItemQty.text = i["quantity"]!.stringValue
                            self.txtChannelItemDesc.text = i["description"]!.stringValue
                            
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
