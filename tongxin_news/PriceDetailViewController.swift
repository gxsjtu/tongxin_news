//
//  PriceDetailViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/25.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class PriceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var products = [(String, String, String, String, String, String, String)]()
    var market = "未知"
    var group = "未知"
    var mobile = ""
    var marketId = ""

    @IBOutlet weak var tvPriceDetail: UITableView!
    @IBOutlet weak var navBarPriceDetail: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navBarPriceDetail.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        self.navBarPriceDetail.topItem?.title = group + " - " + market
        getProducts()
        tvPriceDetail.dataSource = self
        tvPriceDetail.delegate = self
    }

    @IBAction func btnRefresh(sender: AnyObject) {
        getProducts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("PriceDetail2PriceHistory", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    func updateRowAtIndexPath(indexPath: NSIndexPath, isorder: String)
    {
        products[indexPath.row].6 = isorder
        tvPriceDetail.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PriceDetailCell", forIndexPath: indexPath) as! PriceDetailVCTableViewCell
        cell.delegate = cell
        cell.parentVC = self
        cell.lblPriceDetailName.text = products[indexPath.row].0
        cell.lblPriceDetailDate.text = products[indexPath.row].4
        cell.lblPriceDetailLow.text = "最低 " + products[indexPath.row].2
        cell.lblPriceDetailHigh.text = "最高 " + products[indexPath.row].3
        cell.lblPriceDetailId.text = products[indexPath.row].1
        cell.lblPriceDetailIsOrdered.text = products[indexPath.row].6
        if products[indexPath.row].5 == ""
        {
            cell.lblPriceDetailChange.hidden = true
        }
        else if products[indexPath.row].5 == "***"
        {
            cell.lblPriceDetailChange.textColor = UIColor.blackColor()
            cell.lblPriceDetailChange.text = "涨跌 ***"
        }
        else
        {
            let change = NSString(string: products[indexPath.row].5).floatValue
            
            if change == 0
            {
                cell.lblPriceDetailChange.textColor = UIColor.blackColor()
                cell.lblPriceDetailChange.text = "平"
            }
            else if change > 0
            {
                cell.lblPriceDetailChange.textColor = UIColor.redColor()
                cell.lblPriceDetailChange.text = "涨 " + String(stringInterpolationSegment: change)
            }
            else
            {
                cell.lblPriceDetailChange.textColor = UIColor(red: 35/255, green: 124/255, blue: 2/255, alpha: 1.0)
                cell.lblPriceDetailChange.text = "跌 " + String(stringInterpolationSegment: -change)
            }
            
        }
        
        var rightButtons : [AnyObject] = [AnyObject]()
        
        let rightSubBtn = UIButton()
        
        if cell.lblPriceDetailIsOrdered.text == "YES"
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
    
    @IBAction func unwindFromPriceHistory2PriceDetail(segue: UIStoryboardSegue)
    {
    
    }
    
    func getProducts()
    {
         MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.GetPrices.rawValue, parameters: ["mobile": mobile, "marketId": marketId, "method": "getPrices"])
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
                                {self.products.append((i["ProductName"]!.stringValue, i["ProductId"]!.stringValue, i["LPrice"]!.stringValue, i["HPrice"]!.stringValue, i["Date"]!.stringValue, i["Change"]!.stringValue, i["isOrder"]!.stringValue))
                                }
                            }
                            self.tvPriceDetail.reloadData()
                        }

                    }
                    
                case .Failure:
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请点击右上角刷新按钮！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PriceDetail2PriceHistory"
        {
            if let cell = sender as? PriceDetailVCTableViewCell
            {
                if let des = segue.destinationViewController as? PriceHistoryViewController
                {
                    des.navTitle = market + " - " + cell.lblPriceDetailName.text!
                    des.productId = cell.lblPriceDetailId.text!
                }
            }
        }
    }
}
