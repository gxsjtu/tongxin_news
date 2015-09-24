//
//  CommentDetailViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/26.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class CommentDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //avatar, url, title, date, id, productname, isOrder
    var products = [(String, String, String, String, String, String, String)]()
    var market = "未知"
    var group = "未知"
    var mobile = ""
    var marketId = ""

    @IBOutlet weak var tvCommentDetail: UITableView!
    @IBOutlet weak var navBarCommentetail: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navBarCommentetail.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        self.navBarCommentetail.topItem?.title = group + " - " + market
        getComments()
    }
    
    func updateRowAtIndexPath(indexPath: NSIndexPath, isorder: String)
    {
        products[indexPath.row].6 = isorder
        tvCommentDetail.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("CommentDetail2CommentContent", sender: tableView.cellForRowAtIndexPath(indexPath))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentDetailCell", forIndexPath: indexPath) as! CommentDetailVCTableViewCell
        cell.delegate = cell
        cell.parentVC = self
        cell.lblCommentDetailTitle.preferredMaxLayoutWidth = cell.lblCommentDetailTitle.frame.width
        cell.imgCommentDetailLogo.sd_setImageWithURL(NSURL(string: products[indexPath.row].0), placeholderImage: UIImage(named: "index"))
        cell.lblCommentDetailDate.text = products[indexPath.row].3
        cell.lblCommentDetailTitle.text = products[indexPath.row].2
        cell.lblCommentDetailName.text = products[indexPath.row].5
        cell.lblCommentDetailUrl.text = products[indexPath.row].1
        cell.lblCommentProductId.text = products[indexPath.row].4
        cell.lblCommentDetailIsOrdered.text = products[indexPath.row].6
        
        var rightButtons : [AnyObject] = [AnyObject]()
        
        let rightSubBtn = UIButton()
        
        if cell.lblCommentDetailIsOrdered.text == "YES"
        {
            rightSubBtn.setTitle("取消关注", forState: UIControlState.Normal)
            rightSubBtn.backgroundColor = UIColor.redColor()
            rightSubBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        else
        {
            rightSubBtn.setTitle("添加关注", forState: UIControlState.Normal)
            rightSubBtn.backgroundColor = UIColor(red: 35/255, green: 124/255, blue: 2/255, alpha: 1.0)
            rightSubBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        
        rightButtons.append(rightSubBtn)
        
        cell.setRightUtilityButtons(rightButtons, withButtonWidth: 90)

        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CommentDetail2CommentContent"
        {
            if let des = segue.destinationViewController as? CommentContentViewController
            {
                if let cell = sender as? CommentDetailVCTableViewCell
                {
                    des.navTitle = market + " - " + cell.lblCommentDetailName.text!
                    des.url = cell.lblCommentDetailUrl.text!
                }
            }
        }
    }

//    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
//        if identifier == "CommentDetail2CommentContent"
//        {
//            if let cell = sender as? CommentDetailVCTableViewCell
//            {
//                if cell.lblCommentDetailIsOrdered.text == "NO"
//                {
//                    let alert = SKTipAlertView()
//                    alert.showRedNotificationForString("您尚未订阅该产品，无法查看详细内容！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
//                    return false
//                }
//            }
//        }
//        return true
//    }
    
    @IBAction func commentContent2CommentDetail(segue: UIStoryboardSegue)
    {
        
    }
    
    @IBAction func btnRefresh(sender: AnyObject) {
        getComments()
    }
    
    func getComments()
    {
         MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.GetCommentHierarchy.rawValue, parameters: ["method": "getproducts", "marketId": marketId, "mobile": mobile])
            .responseJSON { response in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                switch response.result {
                case .Success:
                    if let data: AnyObject = response.result.value
                    {
                        if let res = JSON(data).array
                        {
                            self.products.removeAll(keepCapacity: true)
                            for item in res
                            {
                                if let i = item.dictionary
                                {
                                    print(i["isOrder"]!.stringValue)
                                    self.products.append((i["avatar"]!.stringValue, i["url"]!.stringValue, i["title"]!.stringValue, i["date"]!.stringValue, i["id"]!.stringValue, i["productname"]!.stringValue, i["isOrder"]!.stringValue))
                                }
                            }
                            self.tvCommentDetail.reloadData()
                        }

                    }
                    
                case .Failure:
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请点击右上角刷新按钮！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
        }
    }

}
