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

    @IBOutlet weak var navBarCommentetail: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navBarCommentetail.topItem?.title = group + " - " + market
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

}
