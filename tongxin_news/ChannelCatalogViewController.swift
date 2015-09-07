//
//  ChannelCatalogViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/7.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class ChannelCatalogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var catalogs = [(String, String, String)]()
    @IBOutlet weak var navChannelCatalog: UINavigationBar!
    var channelName = "未知"
    var channelId = 0
    @IBOutlet weak var vChannelCatalog: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navChannelCatalog.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        self.navChannelCatalog.topItem?.title = "商圈 - " + channelName
        getChannelCatalog()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.catalogs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChannelCatalogCell") as! ChannelCatalogTableViewCell
        cell.vChannelCatalogCell.backgroundColor = UIColor(red: 36/255, green: 124/255, blue: 151/255, alpha: 0.8)
        cell.vChannelCatalogCell.layer.cornerRadius = 10.0
        cell.lblChannelCatalogName.text = catalogs[indexPath.row].1
        cell.lblChannelCatalogDesc.text = catalogs[indexPath.row].2
        cell.lblChannelCatalogId.text = catalogs[indexPath.row].0
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func getChannelCatalog()
    {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        request(.GET, EndPoints.Channel.rawValue, parameters: ["method": "getcatalog", "channelId": channelId])
            .responseJSON { (request, response, data, error) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if let anError = error
                {
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
                else if let data: AnyObject = data
                {
                    if let res = JSON(data).array
                    {
                        for item in res
                        {
                            if let i = item.dictionary
                            {
                                self.catalogs.append((i["id"]!.stringValue, i["Name"]!.stringValue, i["Desc"]!.stringValue))
                            }
                        }
                        self.vChannelCatalog.reloadData()
                    }
                }
        }
    }


}
