//
//  ChannelViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/7.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate {

    var channelName = "未知"
    var channelId = 0
    //avatar, name, location, contact, date
    var pdata = [(String, String, String, String, String)]()
    var sdata = [(String, String, String, String, String)]()
    @IBOutlet weak var segChannel: UISegmentedControl!
    @IBOutlet weak var navChannel: UINavigationBar!
    @IBOutlet weak var vSPList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navChannel.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didChanelViewAction(sender: AnyObject) {
        let actions = UIActionSheet()
        actions.title = "操作"
        actions.delegate = self
        actions.addButtonWithTitle("刷新供需列表")
        actions.addButtonWithTitle("发布供需")
        actions.addButtonWithTitle("取消")
        actions.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0
        {
            //刷新列表
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
        else
        {
            actionSheet.hidden = true
        }
    }
    
    func getSPList()
    {
        
    }
    
    @IBAction func unwindFromChannelCatalog2Channel(segue: UIStoryboardSegue)
    {
        
    }
    
    @IBAction func didSegChanged(sender: AnyObject) {
        self.vSPList.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segChannel.selectedSegmentIndex == 0
        {
            return sdata.count
        }
        else
        {
            return pdata.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SPListCell") as! ChannelVCTableViewCell
        if segChannel.selectedSegmentIndex == 0
        {
            cell.imageView?.hnk_setImageFromURL(NSURL(string: sdata[indexPath.row].0))
            cell.lblChannelCellContact.text = sdata[indexPath.row].3
            cell.lblChannelCellDate.text = sdata[indexPath.row].4
            cell.lblChannelCellLocation.text = sdata[indexPath.row].2
            cell.lblChannelCellName.text = sdata[indexPath.row].1
        }
        else
        {
            cell.imageView?.hnk_setImageFromURL(NSURL(string: pdata[indexPath.row].0))
            cell.lblChannelCellContact.text = pdata[indexPath.row].3
            cell.lblChannelCellDate.text = pdata[indexPath.row].4
            cell.lblChannelCellLocation.text = pdata[indexPath.row].2
            cell.lblChannelCellName.text = pdata[indexPath.row].1
        }
        return cell
    }
}
