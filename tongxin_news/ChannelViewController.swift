//
//  ChannelViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/7.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,UISearchBarDelegate {

    var channelName = "未知"
    var channelId = 0
    var fromAdd = false
    //avatar, name, location, contact, date, type, id
    var pdata = [(String, String, String, String, String, String, String)]()
    var sdata = [(String, String, String, String, String, String, String)]()
    var pdataRes = [(String, String, String, String, String, String, String)]()
    var sdataRes = [(String, String, String, String, String, String, String)]()
    @IBOutlet weak var segChannel: UISegmentedControl!
    @IBOutlet weak var navChannel: UINavigationBar!
    @IBOutlet weak var vSPList: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        // Do any additional setup after loading the view.
        self.navChannel.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        getSPList()
    }
    
    override func viewDidAppear(animated: Bool) {
        if fromAdd == true
        {
            let alert = SKTipAlertView()
            alert.showGreenNotificationForString("添加成功，请等待系统审核！", forDuration: 3.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
            self.fromAdd = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didChanelViewAction(sender: AnyObject) {
        let actions = UIActionSheet()
        actions.title = "操作"
        actions.delegate = self
        actions.cancelButtonIndex = 2
        actions.addButtonWithTitle("刷新供需列表")
        actions.addButtonWithTitle("发布供需")
        actions.addButtonWithTitle("取消")
        actions.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0
        {
            //刷新列表
            getSPList()
        }
        else if buttonIndex == 1
        {
            //新增
            if let catalogVC = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelCatalogVC") as? ChannelCatalogViewController
            {
                catalogVC.channelId = self.channelId
                catalogVC.channelName = self.channelName
                self.presentViewController(catalogVC, animated: true, completion: nil)
            }
        }
    }
    
    func getSPList()
    {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let mobile = ""
        NSUserDefaults.standardUserDefaults().setObject(mobile, forKey: "mobile")
        (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.SPList.rawValue, parameters: ["method": "getsupply", "channel": channelId, "createdBy": mobile])
            .responseJSON { response in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                switch response.result {
                case .Success:
                    if let data: AnyObject = response.result.value
                    {
                        if let res = JSON(data).array
                        {
                            self.pdata.removeAll(keepCapacity: false)
                            self.pdataRes.removeAll(keepCapacity: false)
                            self.sdata.removeAll(keepCapacity: false)
                            self.sdataRes.removeAll(keepCapacity: false)
                            for item in res
                            {
                                if let i = item.dictionary
                                {
                                    if i["type"]!.stringValue == "true"
                                    {
                                        self.pdata.append((i["avatar"]!.stringValue, i["name"]!.stringValue, i["location"]!.stringValue, i["contact"]!.stringValue, i["date"]!.stringValue, i["type"]!.stringValue, i["id"]!.stringValue))
                                    }
                                    else
                                    {
                                        self.sdata.append((i["avatar"]!.stringValue, i["name"]!.stringValue, i["location"]!.stringValue, i["contact"]!.stringValue, i["date"]!.stringValue, i["type"]!.stringValue, i["id"]!.stringValue))
                                    }
                                }
                            }
                            self.pdataRes = self.pdata
                            self.sdataRes = self.sdata
                            self.vSPList.reloadData()
                        }
                    }
                    
                case .Failure:
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请点击右上角按钮刷新重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
        }
    }
    
    @IBAction func unwindFromChannelCatalog2Channel(segue: UIStoryboardSegue)
    {
        
    }
    
    @IBAction func unwindFromChannelItemDetail2Channel(segue: UIStoryboardSegue)
    {
        
    }
    
    @IBAction func didSegChanged(sender: AnyObject) {
        self.searchBar.text = ""
        self.vSPList.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segChannel.selectedSegmentIndex == 0
        {
            return sdataRes.count
        }
        else
        {
            return pdataRes.count
        }
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let vc : ChannelItemDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ItemDetailView") as! ChannelItemDetailViewController
//        
//        vc.navTitle = "商圈 - " + channelName
//        vc.itemId = (tableView.cellForRowAtIndexPath(indexPath) as! ChannelVCTableViewCell).lblChannelItemId.text!
//        presentViewController(vc, animated: true, completion: nil)
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SPListCell") as! ChannelVCTableViewCell
        if segChannel.selectedSegmentIndex == 0
        {
            cell.imgChannelCellAvatar.sd_setImageWithURL(NSURL(string: sdata[indexPath.row].0), placeholderImage: UIImage(named: "index"))
            cell.lblChannelCellContact.text = sdataRes[indexPath.row].3
            cell.lblChannelCellDate.text = sdataRes[indexPath.row].4
            cell.lblChannelCellLocation.text = sdataRes[indexPath.row].2
            cell.lblChannelCellName.text = sdataRes[indexPath.row].1
            cell.lblChannelItemId.text = sdataRes[indexPath.row].6
        }
        else
        {
            cell.imgChannelCellAvatar.sd_setImageWithURL(NSURL(string: pdata[indexPath.row].0), placeholderImage: UIImage(named: "index"))
            cell.lblChannelCellContact.text = pdataRes[indexPath.row].3
            cell.lblChannelCellDate.text = pdataRes[indexPath.row].4
            cell.lblChannelCellLocation.text = pdataRes[indexPath.row].2
            cell.lblChannelCellName.text = pdataRes[indexPath.row].1
            cell.lblChannelItemId.text = pdataRes[indexPath.row].6
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChannelList2ItemDetail"
        {
            if let des = segue.destinationViewController as? ChannelItemDetailViewController
            {
                if let cell = sender as? ChannelVCTableViewCell
                {
                    des.navTitle = "商圈 - " + channelName
                    des.itemId = cell.lblChannelItemId.text!
                }
            }
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "")
        {
            self.pdataRes = self.pdata
            self.sdataRes = self.sdata
            //self.resInfos = self.msgInfos
            //self.resComInfos = self.comInfos
        }
        else
        {
          if(self.segChannel.selectedSegmentIndex == 0)
          {
            self.sdataRes.removeAll(keepCapacity: false)
            for s in self.sdata
            {
            if(s.1.componentsSeparatedByString(searchText).count > 1)
            {
                self.sdataRes.append(s)
            }
            }
            }
            else if self.segChannel.selectedSegmentIndex == 1
            {
            self.pdataRes.removeAll(keepCapacity: false)
                for p in self.pdata
                {
                    if(p.1.componentsSeparatedByString(searchText).count > 1)
                    {
                        self.pdataRes.append(p)
                    }
                }
            }
        }
       self.vSPList.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.sdataRes.removeAll(keepCapacity: false)
        self.pdataRes.removeAll(keepCapacity: false)
        self.sdataRes = self.sdata
        self.pdataRes = self.pdata
        
        self.vSPList.reloadData()
    }
}
