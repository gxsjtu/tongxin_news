//
//  ChannelItemDetailViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/9.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class ChannelItemDetailViewController: UIViewController {

    @IBOutlet weak var txtChannelItemDesc: UITextView!
    @IBOutlet weak var lblChannelItemDeliver: UILabel!
    @IBOutlet weak var lblChannelItemLocation: UILabel!
    @IBOutlet weak var lblChannelItemContact: UILabel!
    @IBOutlet weak var lblChannelItemMobile: UILabel!
    @IBOutlet weak var lblChannelItemQty: UILabel!
    @IBOutlet weak var lblChannelItemName: UILabel!
    @IBOutlet weak var lblChannelItemCapt: UILabel!
    @IBOutlet weak var navChannelItemDetail: UINavigationBar!
    
    var itemId = "0"
    var navTitle = "未知"
    var images = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getChannelItemDetail()
        self.navChannelItemDetail.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        self.navChannelItemDetail.topItem?.title = navTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        getChannelItemDetail()
    }
    
    func getChannelItemDetail()
    {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        request(.GET, EndPoints.SPList.rawValue, parameters: ["method": "getitem", "id": itemId])
            .responseJSON { (request, response, data, error) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                println(request)
                if let anError = error
                {
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请点击右上角刷新重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
                else if let data: AnyObject = data
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
                        self.lblChannelItemMobile.text = i["mobile"]!.stringValue
                        self.lblChannelItemName.text = i["name"]!.stringValue
                        self.lblChannelItemQty.text = i["quantity"]!.stringValue
                        self.txtChannelItemDesc.text = i["description"]!.stringValue
                    }
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
