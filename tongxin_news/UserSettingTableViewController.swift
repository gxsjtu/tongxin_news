//
//  UserSettingTableViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/10/19.
//  Copyright © 2015年 郭轩. All rights reserved.
//

import UIKit
import StoreKit

class UserSettingTableViewController: UITableViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {

    @IBOutlet weak var cellEnd: UITableViewCell!
    @IBOutlet weak var btnPay: UIButton!
    let productId = "shtx0001"
    var product: SKProduct?
    
    @IBAction func didPayClicked(sender: AnyObject) {
        if let relProduct = self.product
        {
            let payment = SKPayment(product: relProduct)
            SKPaymentQueue.defaultQueue().addPayment(payment)
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
                switch transaction.transactionState {
                case .Purchased:
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                    break;
                case .Failed:
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                    break;
                    // case .Restored:
                    //[self restoreTransaction:transaction];
                default:
                    break;
                }
            }
    }
    
    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        let count: Int = response.products.count
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        if (count > 0) {
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == self.productId) {
                self.product = validProduct
                self.btnPay.enabled = true
                self.btnPay.alpha = 1
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnPay.enabled = false
        self.btnPay.alpha = 0.3
        cellEnd.selectionStyle = .None
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        IsLogin()
    }

    @IBAction func btnLogout(sender: AnyObject) {
        //点击退出按钮删除存储的登录用户信息
        NSUserDefaults.standardUserDefaults().removeObjectForKey("isLoggedIn")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("mobile")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
        //转向login页面
        if let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
        {
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func isSoundChanged(sender: AnyObject) {
        let mobile : String? = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.UserSet.rawValue, parameters:["mobile":mobile!, "method":"setUserInfo", "isSound": self.isSound.on])
            .responseJSON { response in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                switch response.result {
                case .Success:
                    break
                case .Failure:
                    self.isSound.setOn(!self.isSound.on, animated: true)
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("修改声音设置失败，请重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                }
        }
    }
    @IBOutlet weak var isSound: UISwitch!
    @IBOutlet weak var txtDateValue: UILabel!
    @IBOutlet weak var txtMobile: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    @IBAction func unWindFromMyFocus2UserSetting(segue: UIStoryboardSegue)
    {
        
    }
    
    @IBAction func unWindFromMyPublish2UserSetting(segue: UIStoryboardSegue)
    {
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0
        {
            return 2
        }
        else if section == 1
        {
            return 1
        }
        else if section == 2
        {
            return 1
        }
        else if section == 3
        {
            return 1
        }
        return 0
    }
    
    func IsLogin()
    {
        let isLogined : String? = NSUserDefaults.standardUserDefaults().stringForKey("isLoggedIn")
        
        if(isLogined != "yes")
        {
            //转向login页面
            if let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
            {
                self.presentViewController(loginVC, animated: true, completion: nil)
            }
        }
        else
        {
            let mobile : String? = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.UserSet.rawValue, parameters:["mobile":mobile!, "method":"getUserInfo"])
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        let res = JSON(response.result.value!)
                        if let result = res["endDate"].string
                        {
                            self.txtDateValue.text = result
                        }
                        if let isSound = res["isSound"].string
                        {
                            if isSound == "true"
                            {
                                self.isSound.setOn(true, animated: true)
                            }
                            else
                            {
                                self.isSound.setOn(false, animated: true)
                            }
                        }
                        self.txtMobile.text = mobile
                        if (SKPaymentQueue.canMakePayments())
                        {
                            let productID: NSSet = NSSet(object: self.productId);
                            let productsRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
                            productsRequest.delegate = self;
                            productsRequest.start();
                        }
                    case .Failure:
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        let alert = SKTipAlertView()
                        alert.showRedNotificationForString("加载失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                    }
                    
            }
        }
    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
