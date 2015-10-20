//
//  MyFocusViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/10/20.
//  Copyright © 2015年 郭轩. All rights reserved.
//

import UIKit

class MyFocusItem
{
    var MarketName: String = ""
    var ProductName: String = ""
    var Id: String = ""
}

class MyFocusViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tvMyFocus: UITableView!
    //市场，产品，id
    var myFocus = Array<MyFocusItem>()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tvMyFocus.delegate = self
        self.tvMyFocus.dataSource = self
        
        LoadMyFocus()
    }
    
    func LoadMyFocus()
    {
        let mobile : String? = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.OrderProduct.rawValue, parameters:["mobile":mobile!, "method":"myorder"])
            .responseJSON { response in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                switch response.result {
                case .Success:
                    if let data: AnyObject = response.result.value
                    {
                        if let res = JSON(data).array
                        {
                            for item in res
                            {
                                if let i = item.dictionary
                                {
                                    let item = MyFocusItem()
                                    item.Id = i["productid"]!.string!
                                    item.MarketName = i["marketname"]!.string!
                                    item.ProductName = i["productname"]!.string!
                                    self.myFocus.append(item)
                                }
                            }
                            self.tvMyFocus.reloadData()
                        }
                    }
                case .Failure:
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFocus.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myFocusCell", forIndexPath: indexPath) as! MyFocusTableViewCell
        cell.lblId.text = self.myFocus[indexPath.row].Id
        cell.lblMarket.text = self.myFocus[indexPath.row].MarketName
        cell.lblProduct.text = self.myFocus[indexPath.row].ProductName
        cell.parentVC = self
        
        var rightButtons : [AnyObject] = [AnyObject]()
        let rightSubBtn = UIButton()
        rightSubBtn.setTitle("取消关注", forState: UIControlState.Normal)
        rightSubBtn.backgroundColor = UIColor.redColor()
        rightSubBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rightButtons.append(rightSubBtn)
        cell.setRightUtilityButtons(rightButtons, withButtonWidth: 90)

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
