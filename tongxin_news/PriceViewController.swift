//
//  PriceViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/24.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class PriceViewController: UIViewController, HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBAction func btnRefreshPrice(sender: AnyObject) {

        
    }
    
    @IBOutlet weak var tvPriceTableView: UITableView!
    var selectionData = [String]()
    var marketData = [(String, String)]()
    var selection: HTHorizontalSelectionList!
    var market = Dictionary<String, [(String, String)]>()
    
    @IBOutlet weak var vSelectionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func getProductHierarchy()
    {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        request(.GET, EndPoints.GetProductHierarchy.rawValue, parameters: ["method": "getmarkets"])
            .responseJSON { (request, response, data, error) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

                if let anError = error
                {
                    println(anError)
                }
                else if let data: AnyObject = data
                {
                    if let res1 = JSON(data).array
                    {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("PriceCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = marketData[indexPath.row].1
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marketData.count
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
