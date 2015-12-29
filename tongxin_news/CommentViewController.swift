//
//  CommentViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/25.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit
import SnapKit

class CommentViewController: UIViewController, HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBAction func btnMoreClicked(sender: AnyObject) {
        self.ChannelView4Comment?.view.hidden = false
        self.ChannelView4Comment?.cvBase.reloadData()
//        self.ChannelView4Comment?.cvInBucket.reloadData()
//        self.ChannelView4Comment?.cvOutBucket.reloadData()
//        self.ChannelView4Comment?.consInViewHeight.constant = (self.ChannelView4Comment?.cvInBucket.collectionViewLayout.collectionViewContentSize().height)! + 40
//        let h1 = self.ChannelView4Comment?.cvInBucket.collectionViewLayout.collectionViewContentSize().height
//        let h2 = self.ChannelView4Comment?.cvOutBucket.collectionViewLayout.collectionViewContentSize().height
//        self.ChannelView4Comment?.consBaseViewHeight.constant = h1! + h2! + 180
    }
    @IBOutlet weak var more: UIButton!
    @IBOutlet weak var navComment: UINavigationBar!
    @IBOutlet weak var tvComment: UITableView!
    @IBOutlet weak var vSelectionView: UIView!
    var ChannelView4Comment: ChannelView4PricesVC?
    
    var selectionData = [String]()
    var marketData = [(String, String)]()
    var selection: HTHorizontalSelectionList!
    var market = Dictionary<String, [(String, String)]>()
    var inBucket = [(id: Int, name: String)]()
    var outBucket = [(id: Int, name: String)]()
    
    @IBAction func btnRefresh(sender: AnyObject) {
        getCommentHierarchy()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.ChannelView4Comment = UIStoryboard(name: "ChannelLayer4Prices", bundle: nil).instantiateViewControllerWithIdentifier("ChannelView4PricesVC") as? ChannelView4PricesVC
        self.ChannelView4Comment?.view.hidden = true
        self.ChannelView4Comment?.parentVC = self
        self.view.addSubview((self.ChannelView4Comment?.view)!)
        self.ChannelView4Comment?.view.snp_makeConstraints(closure: {(make) -> Void in
            make.edges.equalTo(self.view)
        })
        
        self.more.hidden = true
        
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
        self.selection.setTitleFont(UIFont.boldSystemFontOfSize(15), forState: UIControlState.Normal)
        self.selection.setTitleFont(UIFont.boldSystemFontOfSize(17), forState: UIControlState.Selected)
        
        vSelectionView.addSubview(selection)
        
        //添加constraints
        self.selection.snp_makeConstraints(closure: {(make) -> Void in
            make.edges.equalTo(self.vSelectionView).inset(EdgeInsets(top: 0, left: 0, bottom: 0, right: self.more.frame.width))
        })
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
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
         MBProgressHUD.showHUDAddedTo(self.view, animated: true)
         let mobile : String? = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
        (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.GetCommentHierarchy.rawValue, parameters: ["method": "getmarkets", "mobile": mobile!])
            .responseJSON {response in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                switch response.result {
                case .Success:
                    self.more.hidden = false
                    if let data: AnyObject = response.result.value
                    {
                        if let res1 = JSON(data).array
                        {
                            self.marketData.removeAll(keepCapacity: true)
                            self.market.removeAll(keepCapacity: true)
                            self.selectionData.removeAll(keepCapacity: true)
                            self.inBucket.removeAll(keepCapacity: true)
                            self.outBucket.removeAll(keepCapacity: true)
                            for r in res1
                            {
                                if let res2 = r.dictionary
                                {
                                    if let bucket = res2["inBucket"]!.string
                                    {
                                        if bucket == "true"
                                        {
                                            self.inBucket.append((res2["id"]!.int!, res2["name"]!.string!))
                                            self.selectionData.append(res2["name"]!.string!)
                                        }
                                        else
                                        {
                                            self.outBucket.append((res2["id"]!.int!, res2["name"]!.string!))
                                        }
                                    }
                                    
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
                            
                            self.ChannelView4Comment?.inBucket = self.inBucket
                            self.ChannelView4Comment?.outBucket = self.outBucket
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
