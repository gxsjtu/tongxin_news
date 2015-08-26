//
//  CommentDetailViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/26.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class CommentDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //avatar, url, title, date, id
    var products = [(String, String, String, String, String)]()
    var market = "未知"
    var group = "未知"
    var mobile = ""
    var marketId = ""

    @IBOutlet weak var tvCommentDetail: UITableView!
    @IBOutlet weak var navBarCommentetail: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navBarCommentetail.topItem?.title = group + " - " + market
        getComments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentDetailCell", forIndexPath: indexPath) as! CommentDetailVCTableViewCell
        
        cell.textLabel?.numberOfLines = 0
        cell.lblCommentDetailDate.text = products[indexPath.row].3
        cell.textLabel?.text = products[indexPath.row].2
        cell.imageView?.hnk_setImageFromURL(NSURL(string: products[indexPath.row].0))
        
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
    
    @IBAction func btnRefresh(sender: AnyObject) {
        getComments()
        tvCommentDetail.reloadData()
    }
    
    func getComments()
    {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        request(.GET, EndPoints.GetCommentHierarchy.rawValue, parameters: ["marketId": marketId, "method": "getProducts"])
            .responseJSON { (request, response, data, error) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                println(request)
                if let anError = error
                {
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请点击右上角刷新按钮！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
                else if let data: AnyObject = data
                {
                    if let res = JSON(data).array
                    {
                        println(res)
                        self.products.removeAll(keepCapacity: true)
                        for item in res
                        {
                            if let i = item.dictionary
                            {
                                self.products.append((i["avatar"]!.stringValue, i["url"]!.stringValue, i["title"]!.stringValue, i["date"]!.stringValue, i["id"]!.stringValue))
                            }
                        }
                        self.tvCommentDetail.reloadData()
                    }
                }
        }
    }

}
