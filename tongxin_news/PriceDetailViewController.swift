//
//  PriceDetailViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/25.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class PriceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    var products = [(String, String, String, String, String, String, String)]()
    var market = "未知"
    var group = "未知"
    var mobile = ""
    var marketId = ""
    var searchKey = ""
    var isSearch : Bool = false
    var marketList : Array<Market> = []
    var proList : Array<ProPrices> = []
    @IBOutlet weak var tvPriceDetail: UITableView!
    @IBOutlet weak var navBarPriceDetail: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(self.isSearch)
        {
            self.navBarPriceDetail.topItem?.title = "查询结果"
            getSearchResults()
        }
        else
        {
            self.navBarPriceDetail.topItem?.title = group + " - " + market
            getProducts()
        }
        tvPriceDetail.dataSource = self
        tvPriceDetail.delegate = self
    }

    @IBAction func btnRefresh(sender: AnyObject) {
        if(self.isSearch)
        {
            getSearchResults()
        }
        else
        {
            getProducts()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(self.isSearch)
        {
            return self.marketList.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView
        {
            header.contentView.backgroundColor = UIColor(red: 82/255, green: 166/255, blue: 192/255, alpha: 1.0)
            header.textLabel?.textColor = UIColor.whiteColor()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.isSearch)
        {
            return self.marketList[section].priceList.count
        }
        else
        {
            return self.proList.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(self.isSearch)
        {
            return self.marketList[section].Name
        }
        else
        {
            return ""
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(self.isSearch)
        {
            return 40
        }else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("PriceDetail2PriceHistory", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    func updateRowAtIndexPath(indexPath: NSIndexPath, isorder: String)
    {
        if(self.isSearch)
        {
            self.marketList[indexPath.section].priceList[indexPath.row].IsOrder = isorder
//            self.proList[indexPath.row].IsOrder = isorder
//            tvPriceDetail.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        else
        {
        self.proList[indexPath.row].IsOrder = isorder
        }
        tvPriceDetail.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCellWithIdentifier("PriceDetailCell", forIndexPath: indexPath) as! PriceDetailVCTableViewCell
        cell.delegate = cell
        cell.parentVC = self
        if(self.isSearch)
        {
            self.proList = []
            self.proList = self.marketList[indexPath.section].priceList
            cell.lblPriceMarketName.text = self.marketList[indexPath.section].Name
        }
        else
        {
            cell.lblPriceMarketName.text = self.market
        }
        cell.lblPriceDetailName.text = self.proList[indexPath.row].ProName//products[indexPath.row].0
        cell.lblPriceDetailDate.text = self.proList[indexPath.row].Date//products[indexPath.row].4
        cell.lblPriceDetailLow.text =  self.proList[indexPath.row].LPrice//products[indexPath.row].2
        cell.lblPriceDetailHigh.text = self.proList[indexPath.row].HPrice//products[indexPath.row].3
        cell.lblPriceDetailId.text = self.proList[indexPath.row].ProId//products[indexPath.row].1
        cell.lblPriceDetailIsOrdered.text = self.proList[indexPath.row].IsOrder//products[indexPath.row].6
        if self.proList[indexPath.row].Change == ""//products[indexPath.row].5 == ""
        {
            cell.lblPriceDetailChange.text = ""
            cell.lblPriceDetailChangeCapt.text = ""
        }
        else
        {
            let change = NSString(string: self.proList[indexPath.row].Change!).floatValue//NSString(string: products[indexPath.row].5).floatValue
            
            if change == 0
            {
                cell.lblPriceDetailChange.textColor = UIColor.blackColor()
                cell.lblPriceDetailChangeCapt.textColor = UIColor.blackColor()
                cell.lblPriceDetailChange.text = "一"
                cell.lblPriceDetailChangeCapt.text = "平"
            }
            else if change > 0
            {
                cell.lblPriceDetailChange.textColor = UIColor.redColor()
                cell.lblPriceDetailChangeCapt.textColor = UIColor.redColor()
                cell.lblPriceDetailChange.text = String(stringInterpolationSegment: change) + "▲"
                cell.lblPriceDetailChangeCapt.text = "涨"
            }
            else
            {
                cell.lblPriceDetailChange.textColor = UIColor(red: 35/255, green: 124/255, blue: 2/255, alpha: 1.0)
                cell.lblPriceDetailChangeCapt.textColor = UIColor(red: 35/255, green: 124/255, blue: 2/255, alpha: 1.0)
                cell.lblPriceDetailChange.text = String(stringInterpolationSegment: -change) + "▼"
                cell.lblPriceDetailChangeCapt.text = "跌"
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
//                            self.products.removeAll(keepCapacity: true)
                            self.proList = []
                            for item in res
                            {
                                if let i = item.dictionary
                                {
                                    let pro : ProPrices = ProPrices()
                                    pro.ProName = i["ProductName"]!.stringValue
                                    pro.ProId = i["ProductId"]!.stringValue
                                    pro.LPrice = i["LPrice"]!.stringValue
                                    pro.HPrice = i["HPrice"]!.stringValue
                                    pro.Change = i["Change"]!.stringValue
                                    pro.Date = i["Date"]!.stringValue
                                    pro.IsOrder = i["isOrder"]!.stringValue
                                    
                                    self.proList.append(pro)
//                                    self.products.append((i["ProductName"]!.stringValue, i["ProductId"]!.stringValue, i["LPrice"]!.stringValue, i["HPrice"]!.stringValue, i["Date"]!.stringValue, i["Change"]!.stringValue, i["isOrder"]!.stringValue))
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
                    print(cell.lblPriceDetailId.text)
                    des.navTitle = cell.lblPriceMarketName.text! + " - " + cell.lblPriceDetailName.text!
                    des.productId = cell.lblPriceDetailId.text!
                }
            }
        }
    }
    
    func getSearchResults()
    {
             MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.POST, EndPoints.GetSearchPrices.rawValue, parameters: ["mobile": mobile, "searchKey": self.searchKey, "method": "getSearchResult"])
                .responseJSON { response in
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    
                    switch response.result {
                    case .Success:
                        if let data: AnyObject = response.result.value
                        {
                            if let dataList : NSArray = data as? NSArray
                            {
                                self.marketList = []
                                for (var i = 0; i < dataList.count; i++)
                                {
                                    let res = JSON(dataList[i])
                                    let market : Market = Market()
                                    market.Id = res["id"].stringValue
                                    market.Name = res["name"].stringValue
                                    let proRes  = res["products"].array!
                                    
                                    for(var j = 0;j < proRes.count; j++)
                                    {
                                        let pro = proRes[j]
                                        let price : ProPrices = ProPrices()
                                        price.ProId = pro["ProductId"].stringValue
                                        price.ProName = pro["ProductName"].string
                                        price.LPrice = pro["LPrice"].string
                                        price.HPrice = pro["HPrice"].string
                                        price.Date = pro["Date"].string
                                        price.Change = pro["Change"].string
                                        price.IsOrder = pro["isOrder"].string
                                        market.priceList.append(price)
                                    }
                                    self.marketList.append(market)
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
}

class Market : NSObject
{
    var Id : String?
    var Name : String?
    var priceList : Array<ProPrices> = []
}

class ProPrices : NSObject
{
    var ProId : String?
    var ProName : String?
    var LPrice : String?
    var HPrice : String?
    var Date : String?
    var Change : String?
    var IsOrder : String?
}
