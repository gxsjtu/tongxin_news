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
    
    @IBOutlet weak var vSelectionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tvPriceTableView.rowHeight = 44.0
        self.navPrice.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        selection = HTHorizontalSelectionList()
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
        let leading = NSLayoutConstraint(item: selection, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.vSelectionView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        
        let trailing = NSLayoutConstraint(item: selection, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.vSelectionView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        
        let top = NSLayoutConstraint(item: selection, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.vSelectionView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        let bottom = NSLayoutConstraint(item: selection, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.vSelectionView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.vSelectionView.addConstraint(leading)
        self.vSelectionView.addConstraint(trailing)
        self.vSelectionView.addConstraint(top)
        self.vSelectionView.addConstraint(bottom)
        selection.translatesAutoresizingMaskIntoConstraints = false
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
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
         MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.GetProductHierarchy.rawValue, parameters: ["method": "getmarkets"])
            .responseJSON { response in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                switch response.result {
                case .Success:
                    if let data: AnyObject = response.result.value
                    {
                        if let res1 = JSON(data).array
                        {
                            self.marketData.removeAll(keepCapacity: true)
                            self.market.removeAll(keepCapacity: true)
                            self.selectionData.removeAll(keepCapacity: true)
                            for r in res1
                            {
                                if let res2 = r.dictionary
                                {
                                    self.selectionData.append(res2["name"]!.string!)
                                    if let res3 = res2["markets"]?.array
                                    {
                                        var oneMarket = [(String, String)]()
                                        for r3 in res3
                                        {
                                            if let res4 = r3.dictionary
                                            {
                                                oneMarket.append((res4["id"]!.stringValue, res4["name"]!.stringValue))
                                            }
                                        }
                                        self.market[res2["name"]!.string!] = oneMarket
                                    }
                                }
                            }
                            self.selection.reloadData()
                            self.selection.setSelectedButtonIndex(0, animated: true)
                            self.selectionList(self.selection, didSelectButtonWithIndex: 0)
                        }
                    }
                    
                case .Failure:
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请点击右上角刷新按钮！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
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
        return selectionData.count
    }
    
    func selectionList(selectionList: HTHorizontalSelectionList!, titleForItemWithIndex index: Int) -> String! {
        return selectionData[index]
    }
    
    func selectionList(selectionList: HTHorizontalSelectionList!, didSelectButtonWithIndex index: Int) {
        let group = selectionData[index]
        marketData.removeAll(keepCapacity: true)
        for m in market[group]!
        {
            marketData.append(m)
        }
        self.tvPriceTableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PriceCell", forIndexPath: indexPath) as! PriceVCTableViewCell
        cell.textLabel?.text = marketData[indexPath.row].1
        cell.lblPriceCellMarketId.text = marketData[indexPath.row].0
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marketData.count
    }
    
    @IBAction func unwindFromPriceDetail2Price(segue:UIStoryboardSegue){}
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Price2PriceDetail"
        {
            if let des = segue.destinationViewController as? PriceDetailViewController
            {
                des.group = self.selectionData[self.selection.selectedButtonIndex]
                if let cell = sender as? PriceVCTableViewCell
                {
                    des.market = cell.textLabel!.text!
                    des.marketId = cell.lblPriceCellMarketId.text!
                }
                des.mobile = NSUserDefaults.standardUserDefaults().stringForKey("mobile")!
            }
        }
    }
}