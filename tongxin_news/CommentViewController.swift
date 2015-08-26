//
//  CommentViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/25.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tvComment: UITableView!
    @IBOutlet weak var vSelectionView: UIView!
    
    var selectionData = [String]()
    var marketData = [(String, String)]()
    var selection: HTHorizontalSelectionList!
    var market = Dictionary<String, [(String, String)]>()
    
    @IBAction func btnRefresh(sender: AnyObject) {
        getCommentHierarchy()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selection = HTHorizontalSelectionList(frame: CGRect(x: 0, y: 0, width: vSelectionView.frame.width, height: vSelectionView.frame.height))
        selection?.delegate = self
        selection?.dataSource = self
        tvComment.delegate = self
        tvComment.dataSource = self
        
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
        
        tvComment.addGestureRecognizer(leftSwipe)
        tvComment.addGestureRecognizer(rightSwipe)
        
        self.getCommentHierarchy()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCommentHierarchy()
    {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        request(.GET, EndPoints.GetCommentHierarchy.rawValue, parameters: ["method": "getmarkets"])
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
        self.tvComment.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentVCTableViewCell
        cell.textLabel?.text = marketData[indexPath.row].1
        cell.lblCommentMarketId.text = marketData[indexPath.row].0
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marketData.count
    }
    
    @IBAction func unwindFromCommentDetail2Comment(segue:UIStoryboardSegue){}


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Comment2CommentDetail"
        {
            if let des = segue.destinationViewController as? CommentDetailViewController
            {
                des.group = self.selectionData[self.selection.selectedButtonIndex]
                if let cell = sender as? CommentVCTableViewCell
                {
                    des.market = cell.textLabel!.text!
                    des.marketId = cell.lblCommentMarketId.text!
                }
                des.mobile = NSUserDefaults.standardUserDefaults().stringForKey("mobile")!
            }
        }
    }
}
