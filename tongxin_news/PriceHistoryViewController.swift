//
//  PriceHistoryViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/28.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class PriceHistoryViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var lblOverallAvg: UILabel!
    @IBOutlet weak var barBtnChart: UIBarButtonItem!
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
    var start = NSDate().dateByAddingTimeInterval(-24 * 60 * 60 * PriceChartInterval)
    let formatter = NSDateFormatter()
    
    //low, high, date, change, AVERAGE
    var history = [(String, String, String, String, String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        self.barBtnChart.enabled = false
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
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.GetPrices.rawValue, parameters: ["method": "getHistoryPrices", "productId": productId, "start": txtPriceHistoryStart.text!, "end": txtPriceHistoryEnd.text!])
            .responseJSON { response in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                switch response.result {
                case .Success:
                    if let data: AnyObject = response.result.value
                    {
                        if let res = JSON(data).array
                        {
                            self.history.removeAll(keepCapacity: true)
                            var overall = 0.0
                            for item in res
                            {
                                if let i = item.dictionary
                                {
                                    let average = (Double(i["HPrice"]!.stringValue)! + Double(i["LPrice"]!.stringValue)!) / 2
                                    self.history.append((i["LPrice"]!.stringValue, i["HPrice"]!.stringValue, i["Date"]!.stringValue, i["Change"]!.stringValue, (NSString(format: "%.2f", average) as String)))
                                    overall += average
                                }
                            }
                            self.lblOverallAvg.text = "均价 " + ((NSString(format: "%.2f", overall / Double(res.count))) as String)
                            self.tvPriceHistory.reloadData()

                            self.barBtnChart.enabled = (self.history.count > 0)
                        }
                    }
                    
                case .Failure:
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
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
        cell.lblPriceHistoryLow.text = "最低 " + history[indexPath.row].0
        cell.lblPriceHistoryHigh.text = "最高 " + history[indexPath.row].1
        cell.lblAvergae.text = "均价 " + history[indexPath.row].4
        
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
            if let change = Double(history[indexPath.row].3)
            {
                if change == 0
                {
                    cell.lblPriceHistoryChange.textColor = UIColor(red: 254/255, green: 182/255, blue: 97/255, alpha: 1.0)
                    cell.lblPriceHistoryChange.text = "平"
                }
                else if change > 0
                {
                    cell.lblPriceHistoryChange.textColor = UIColor(red: 255/255, green: 86/255, blue: 139/255, alpha: 1.0)
                    cell.lblPriceHistoryChange.text = "涨 " + String(change) + "▲"
                }
                else
                {
                    cell.lblPriceHistoryChange.textColor = UIColor(red: 36/255, green: 190/255, blue: 241/255, alpha: 1.0)
                    cell.lblPriceHistoryChange.text = "跌 " + String(-change) + "▼"
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
        self.dpPriceHistory.frame.size = CGSize(width: self.view.frame.width, height: 0)
        UIView.animateWithDuration(1, animations: {() -> Void in
            self.dpPriceHistory.frame.size = CGSize(width: self.view.frame.width, height: 200)},
            completion: nil)
        self.dpPriceHistory.date = formatter.dateFromString(self.txtPriceHistoryStart.text!)!
    }
    
    @IBAction func btnPriceHistoryEndTouchDown(sender: AnyObject) {
        self.toolbarPriceHistory.hidden = false
        self.dpPriceHistory.hidden = false
        self.dpPriceHistory.frame.size = CGSize(width: self.view.frame.width, height: 0)
        UIView.animateWithDuration(1, animations: {() -> Void in
            self.dpPriceHistory.frame.size = CGSize(width: self.view.frame.width, height: 200)},
            completion: nil)
        self.dpPriceHistory.date = formatter.dateFromString(self.txtPriceHistoryEnd.text!)!
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
