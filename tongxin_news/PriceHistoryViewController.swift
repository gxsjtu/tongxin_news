//
//  PriceHistoryViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/28.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class PriceHistoryViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tvPriceHistory: UITableView!
    @IBOutlet weak var navPriceHistory: UINavigationBar!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var txtPriceHistoryEnd: UITextField!
    @IBOutlet weak var txtPriceHistoryStart: UITextField!
    @IBOutlet weak var btnPriceHistoryQuery: UIButton!
    @IBOutlet weak var dpPriceHistory: UIDatePicker!
    @IBOutlet weak var btnPriceHistoryDateConfirm: UIBarButtonItem!
    @IBOutlet weak var toolbarPriceHistory: UIToolbar!
    var whichTxtSelected = 0
    var navTitle = "未知"
    var productId = ""
    var end = NSDate()
    var start = NSDate().dateByAddingTimeInterval(-24*60*60*7)
    let formatter = NSDateFormatter()
    
    //low, high, date, change
    var history = [(String, String, String, String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navPriceHistory.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        self.dpPriceHistory.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        self.toolbarPriceHistory.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        self.vContainer.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        self.toolbarPriceHistory.hidden = true
        self.dpPriceHistory.hidden = true
        self.txtPriceHistoryEnd.delegate = self
        self.txtPriceHistoryStart.delegate = self
        self.navPriceHistory.topItem?.title = navTitle
        formatter.dateFormat = "yyyy-MM-dd"
        txtPriceHistoryStart.text = formatter.stringFromDate(start)
        txtPriceHistoryEnd.text = formatter.stringFromDate(end)
        self.btnPriceHistoryQuery.layer.cornerRadius = 6.0
        
        getPriceHistory()
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        whichTxtSelected = textField.tag
        return false
    }
    
    @IBAction func unwindFromChart2History(segue: UIStoryboardSegue)
    {
        
    }
    
    func getPriceHistory()
    {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        request(.GET, EndPoints.GetPrices.rawValue, parameters: ["method": "getHistoryPrices", "productId": productId, "start": txtPriceHistoryStart.text, "end": txtPriceHistoryEnd.text])
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
                        self.history.removeAll(keepCapacity: true)
                        for item in res
                        {
                            if let i = item.dictionary
                            {
                                self.history.append((i["LPrice"]!.stringValue, i["HPrice"]!.stringValue, i["Date"]!.stringValue, i["Change"]!.stringValue))
                            }
                        }
                        self.tvPriceHistory.reloadData()
                    }
                }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PriceHistoryCell", forIndexPath: indexPath) as! PriceHistoryTableViewCell
        
        cell.lblPriceHistoryDate.text = history[indexPath.row].2
        cell.lblPriceHistoryLow.text = history[indexPath.row].0
        cell.lblPriceHistoryHigh.text = history[indexPath.row].1
        
        if history[indexPath.row].3 == ""
        {
            cell.lblPriceHistoryChange.hidden = true
        }
        else if history[indexPath.row].3 == "***"
        {
            cell.lblPriceHistoryChange.textColor = UIColor.blackColor()
            cell.lblPriceHistoryChange.text = "涨跌 ***"
        }
        else
        {
            if let change = history[indexPath.row].3.toInt()
            {
                if change == 0
                {
                    cell.lblPriceHistoryChange.textColor = UIColor.blackColor()
                    cell.lblPriceHistoryChange.text = "平"
                }
                else if change > 0
                {
                    cell.lblPriceHistoryChange.textColor = UIColor.redColor()
                    cell.lblPriceHistoryChange.text = "涨 " + String(change)
                }
                else
                {
                    cell.lblPriceHistoryChange.textColor = UIColor.greenColor()
                    cell.lblPriceHistoryChange.text = "跌 " + String(-change)
                }
            }
        }
        
        return cell
    }

    @IBAction func btnPriceHistoryQuery(sender: AnyObject) {
        self.toolbarPriceHistory.hidden = true
        self.dpPriceHistory.hidden = true
        
        if start.compare(end) == NSComparisonResult.OrderedDescending
        {
            let alert = SKTipAlertView()
            alert.showRedNotificationForString("截止日期必须晚于起始日期！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
        }
        else if end.timeIntervalSinceDate(start) > 24 * 60 * 60 * 30 * 3
        {
            let alert = SKTipAlertView()
            alert.showRedNotificationForString("查询时间跨度不能超过90天！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
        }
        else
        {
            getPriceHistory()
        }
    }
    
    @IBAction func btnPriceHistoryStartTouchDown(sender: AnyObject) {
        self.toolbarPriceHistory.hidden = false
        self.dpPriceHistory.hidden = false
    }
    
    @IBAction func btnPriceHistoryEndTouchDown(sender: AnyObject) {
        self.toolbarPriceHistory.hidden = false
        self.dpPriceHistory.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnDateConfirmClicked(sender: AnyObject) {
        self.toolbarPriceHistory.hidden = true
        self.dpPriceHistory.hidden = true

        let selectedDate = formatter.stringFromDate(self.dpPriceHistory.date)
        if whichTxtSelected == 1
        {
            start = self.dpPriceHistory.date
            txtPriceHistoryStart.text = selectedDate
        }
        else if whichTxtSelected == 2
        {
            end = self.dpPriceHistory.date
            txtPriceHistoryEnd.text = selectedDate
        }
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PriceHistory2Chart"
        {
            if let des = segue.destinationViewController as? PriceChartViewController
            {
                des.navTitle = self.navTitle
                des.history = self.history
            }
        }
    }

}