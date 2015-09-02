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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PriceDetailCell", forIndexPath: indexPath) as! PriceDetailVCTableViewCell
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
            if let change = products[indexPath.row].5.toInt()
            {
                if change == 0
                {
                    cell.lblPriceDetailChange.textColor = UIColor.blackColor()
                    cell.lblPriceDetailChange.text = "平"
                }
                else if change > 0
                {
                    cell.lblPriceDetailChange.textColor = UIColor.redColor()
                    cell.lblPriceDetailChange.text = "涨 " + String(change)
                }
                else
                {
                    cell.lblPriceDetailChange.textColor = UIColor.greenColor()
                    cell.lblPriceDetailChange.text = "跌 " + String(-change)
                }
            }
        }
        return cell
    }
    
    @IBAction func unwindFromPriceHistory2PriceDetail(segue: UIStoryboardSegue)
    {
    
    }
    
    func getProducts()
    {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        request(.GET, EndPoints.GetPrices.rawValue, parameters: ["mobile": mobile, "marketId": marketId, "method": "getPrices"])
            .responseJSON { (request, response, data, error) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if let anError = error
                {
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请点击右上角刷新按钮！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
                else if let data: AnyObject = data
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
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "PriceDetail2PriceHistory"
        {
            if let cell = sender as? PriceDetailVCTableViewCell
            {
                if cell.lblPriceDetailIsOrdered.text == "NO"
                {
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("您尚未订阅该产品，无法查阅历史数据！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                    return false
                }
            }
        }
        return true
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
