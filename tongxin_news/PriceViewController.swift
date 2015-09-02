//
//  PriceViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/24.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class PriceViewController: UIViewController, HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navPrice: UINavigationBar!
    @IBOutlet weak var tvPriceTableView: UITableView!
    var selectionData = [String]()
    var marketData = [(String, String)]()
    var selection: HTHorizontalSelectionList!
    var market = Dictionary<String, [(String, String)]>()
    
    var selectionList : Array<SelectionInfo> = []
    var marketList : Array<MarketInfo> = []
    var resMarketList : Array<MarketInfo> = []
//    var marketDataList : Array<MarketI>
    
    @IBOutlet weak var vSelectionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navPrice.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        selection = HTHorizontalSelectionList(frame: CGRect(x: 0, y: 0, width: vSelectionView.frame.width, height: vSelectionView.frame.height))
        selection?.delegate = self
        selection?.dataSource = self
        tvPriceTableView.delegate = self
        tvPriceTableView.dataSource = self
        
        self.selection.selectionIndicatorStyle = HTHorizontalSelectionIndicatorStyle.BottomBar
        self.selection.selectionIndicatorColor = UIColor.redColor()
        self.selection.bottomTrimHidden = true
        self.selection.showsEdgeFadeEffect = true
        self.selection.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        self.selection.selectionIndicatorHorizontalPadding = 5.0
        
        vSelectionView.addSubview(selection)
        
        //添加constraints
        let leading = NSLayoutConstraint(item: selection, attribute: NSLayoutAttribute.LeadingMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.vSelectionView, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1, constant: 0)
        
        let traling = NSLayoutConstraint(item: selection, attribute: NSLayoutAttribute.TrailingMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.vSelectionView, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: 0)
        
        let top = NSLayoutConstraint(item: selection, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.vSelectionView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        let bottom = NSLayoutConstraint(item: selection, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.vSelectionView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        selection.setTranslatesAutoresizingMaskIntoConstraints(false)
        NSLayoutConstraint.activateConstraints([leading, traling, top, bottom])
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        tvPriceTableView.addGestureRecognizer(leftSwipe)
        tvPriceTableView.addGestureRecognizer(rightSwipe)
        
        self.getProductHierarchy()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnRefresh(sender: AnyObject) {
        getProductHierarchy()
    }
    
    func getProductHierarchy()
    {
        var mobile : String? = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        request(.GET, EndPoints.GetProductHierarchy.rawValue, parameters: ["method": "getmarkets","mobile":mobile!])
            .responseJSON { (request, response, data, error) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

                if let anError = error
                {
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请点击右上角刷新按钮！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
                else if let data: AnyObject = data
                {
                    if let res1 = JSON(data).array
                    {
                        self.selectionList = []
                        self.resMarketList = []
//                        self.marketData.removeAll(keepCapacity: true)
//                        self.market.removeAll(keepCapacity: true)
//                        self.selectionData.removeAll(keepCapacity: true)
                        for r in res1
                        {
                            if let res2 = r.dictionary
                            {
                                var selection : SelectionInfo = SelectionInfo()
                                //selection.id = res2["id"]!.string!.toInt()
                                selection.name = res2["name"]!.string!
                                if let res3 = res2["markets"]?.array
                                {
                                   // var oneMarket = [(String, String)]()
                                    for r3 in res3
                                    {
                                        if let res4 = r3.dictionary
                                        {
                                            //oneMarket.append((res4["id"]!.stringValue, res4["name"]!.stringValue))
                                            var market : MarketInfo = MarketInfo()
                                            market.id = res4["id"]!.stringValue.toInt()
                                            market.name = res4["name"]!.stringValue
                                            if let res5 = res4["newPrices"]?.array
                                            {
                                                for r5 in res5
                                                {
                                                    if let res6 = r5.dictionary
                                                    {
                                                        var product : ProductInfo = ProductInfo()
                                                        product.name = res6["productName"]!.stringValue
                                                        product.id = (res6["productId"]!.stringValue).toInt()
                                                        product.date = res6["date"]!.stringValue
                                                        product.lPrice = res6["LPrice"]!.stringValue
                                                        product.hPrice = res6["HPrice"]!.stringValue
                                                        product.change = res6["change"]?.string!
                                                        market.proList.append(product)
                                                    }
                                                }
                                            }
//                                            self.marketList.append(market)
                                            selection.marketList.append(market)
                                        }
                                    }
                                    //self.market[res2["name"]!.string!] = oneMarket
                                }
                               self.selectionList.append(selection)
                            }
                        }
                        self.selection.reloadData()
                        self.selection.setSelectedButtonIndex(0, animated: true)
                        self.selectionList(self.selection, didSelectButtonWithIndex: 0)
                    }
                }
        }
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left && selection.selectedButtonIndex < selectionData.count - 1) {
            selection.selectedButtonIndex++
        }
        
        if (sender.direction == .Right && selection.selectedButtonIndex > 0) {
            selection.selectedButtonIndex--
        }
        selectionList(self.selection, didSelectButtonWithIndex: selection.selectedButtonIndex)
    }
    
    func numberOfItemsInSelectionList(selectionList: HTHorizontalSelectionList!) -> Int {
//        return selectionData.count
        return self.selectionList.count
    }
    
    func selectionList(selectionList: HTHorizontalSelectionList!, titleForItemWithIndex index: Int) -> String! {
        //return selectionData[index]
        return self.selectionList[index].name
    }
    
    func selectionList(selectionList: HTHorizontalSelectionList!, didSelectButtonWithIndex index: Int) {
//        let group = selectionData[index]
//        marketData.removeAll(keepCapacity: true)
//        for m in market[group]!
//        {
//            marketData.append(m)
//        }
        var selectionInfo : SelectionInfo = self.selectionList[index]
        self.resMarketList = []
        for m in selectionInfo.marketList
        {
            self.resMarketList.append(m)
        }
        self.tvPriceTableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.resMarketList.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var btn : UIButton = UIButton(frame: CGRect(x: 5, y: 5, width: tableView.frame.size.width - 10, height: 20))
        btn.setTitle(self.resMarketList[section].name!, forState: UIControlState.Normal)
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        btn.setTitleColor(UIColor.blackColor(), forState:UIControlState.Normal)
        btn.tag = section
        btn.addTarget(self, action: "sectionToClick:", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PriceCell", forIndexPath: indexPath) as! UITableViewCell
        (cell.viewWithTag(1) as! UILabel).text = self.resMarketList[indexPath.section].proList[indexPath.row].name
        (cell.viewWithTag(2) as! UILabel).text = self.resMarketList[indexPath.section].proList[indexPath.row].date
        (cell.viewWithTag(3) as! UILabel).text = self.resMarketList[indexPath.section].proList[indexPath.row].lPrice
        (cell.viewWithTag(4) as! UILabel).text = self.resMarketList[indexPath.section].proList[indexPath.row].hPrice
        (cell.viewWithTag(5) as! UILabel).text = self.resMarketList[indexPath.section].proList[indexPath.row].change
        return cell
    }
    
    func sectionToClick(sender:UIButton)
    {
            let mian = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc = mian.instantiateViewControllerWithIdentifier("PriceListInfoView") as! PriceDetailViewController
            vc.market = self.resMarketList[sender.tag].name!
            vc.marketId = String(self.resMarketList[sender.tag].id!)
            vc.mobile = NSUserDefaults.standardUserDefaults().stringForKey("mobile")!
            self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resMarketList[section].proList.count
    }
    
    @IBAction func unwindFromPriceDetail2Price(segue:UIStoryboardSegue){}
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "Price2PriceDetail"
//        {
//            if let des = segue.destinationViewController as? PriceDetailViewController
//            {
//                des.group = self.selectionData[self.selection.selectedButtonIndex]
//                if let cell = sender as? PriceVCTableViewCell
//                {
//                    des.market = cell.textLabel!.text!
//                    des.marketId = cell.lblPriceCellMarketId.text!
//                }
//                des.mobile = NSUserDefaults.standardUserDefaults().stringForKey("mobile")!
//            }
//        }
//    }
}

class SelectionInfo : NSObject
{
    var id : Int?
    var name :String?
    var marketList : Array<MarketInfo> = []
}

class MarketInfo : NSObject
{
    var id : Int?
    var name : String?
    var proList : Array<ProductInfo> = []
}

class ProductInfo : NSObject
{
    var id : Int?
    var name : String?
    var date : String?
    var lPrice : String?
    var hPrice : String?
    var change : String?
}
