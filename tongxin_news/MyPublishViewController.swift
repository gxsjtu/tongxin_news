//
//  MyPublishViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/10/20.
//  Copyright © 2015年 郭轩. All rights reserved.
//

import UIKit

class MyPublishViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tvMyPublish: UITableView!
    //avatar, name, location, contact, date, type, id, isChecked
    var myPublish = [(String, String, String, String, String, String, String, String)]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tvMyPublish.delegate = self
        self.tvMyPublish.dataSource = self
        self.loadMyPublish()
    }
    
    func loadMyPublish()
    {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.SPList.rawValue, parameters: ["method": "mysupply", "mobile": NSUserDefaults.standardUserDefaults().stringForKey("mobile")!])
            .responseJSON { response in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                switch response.result {
                case .Success:
                    if let data: AnyObject = response.result.value
                    {
                        if let res = JSON(data).array
                        {
                            self.myPublish.removeAll(keepCapacity: false)
                            for item in res
                            {
                                if let i = item.dictionary
                                {
                                    self.myPublish.append((i["avatar"]!.stringValue, i["name"]!.stringValue, i["location"]!.stringValue, i["contact"]!.stringValue, i["date"]!.stringValue, i["type"]!.stringValue, i["id"]!.stringValue, i["ischecked"]!.stringValue))
                                }
                            }
                            self.tvMyPublish.reloadData()
                        }
                    }
                    
                case .Failure:
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请点击右上角按钮刷新重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPublish.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myPublishCell", forIndexPath: indexPath) as! MyPublishTableViewCell
        if myPublish[indexPath.row].7 == ""
        {
            cell.lblApproval.text = "待审核"
            cell.lblApproval.textColor = UIColor.blackColor()
        }
        else if myPublish[indexPath.row].7 == "true"
        {
            cell.lblApproval.text = "已审核"
            cell.lblApproval.textColor = UIColor(red: 35/255, green: 124/255, blue: 2/255, alpha: 1.0)
        }
        else
        {
            cell.lblApproval.text = "已拒绝"
            cell.lblApproval.textColor = UIColor.redColor()
        }

        cell.lblAvatar.sd_setImageWithURL(NSURL(string: myPublish[indexPath.row].0), placeholderImage: UIImage(named: "index"))
        cell.lblContact.text = myPublish[indexPath.row].3
        cell.lblName.text = myPublish[indexPath.row].1
        cell.lblLocation.text = myPublish[indexPath.row].2
        cell.lblDate.text = myPublish[indexPath.row].4
        cell.lblId.text = myPublish[indexPath.row].6
        if myPublish[indexPath.row].5 == "true"
        {
            cell.lblNameCapt.text = "采购"
            cell.lblNameCapt.textColor = UIColor(red: 35/255, green: 124/255, blue: 1/255, alpha: 1.0)
        }
        else
        {
            cell.lblNameCapt.text = "销售"
            cell.lblNameCapt.textColor = UIColor(red: 255/255, green: 37/255, blue: 0/255, alpha: 1.0)
        }
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

}
