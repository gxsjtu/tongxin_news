//
//  PriceChartViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/28.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class PriceChartViewController: UIViewController, ChartDelegate {
    
    @IBOutlet weak var lblPriceChartPrice: UILabel!
    @IBOutlet weak var lblPriceChartDate: UILabel!
    @IBOutlet weak var lblPriceChart: UILabel!
    @IBOutlet weak var vChart: UIView!
    @IBOutlet weak var navChart: UINavigationBar!
    var navTitle = "未知"
        //low, high, date, change
    var history = [(String, String, String, String)]()
    
    var low = [Float]()
    var high = [Float]()
    var date = [String]()
    
    func didTouchChart(chart: Chart, indexes: Array<Int?>, x: Float, left: CGFloat) {
        for (serieIndex, dataIndex) in enumerate(indexes) {
            if dataIndex != nil {
                lblPriceChartDate.text = date[dataIndex!]
                lblPriceChartPrice.text = "最低 " + String(stringInterpolationSegment: low[dataIndex!]) + "  最高 " + String(stringInterpolationSegment: high[dataIndex!])
            }
        }
    }
    
    func didFinishTouchingChart(chart: Chart) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navChart.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        self.navChart.topItem?.title = navTitle
        
        for (l: String, h: String, d: String, c: String) in history.reverse()
        {
            low.append((l as NSString).floatValue)
            high.append((h as NSString).floatValue)
            date.append(d)
        }
        
        let chart = Chart(frame: CGRect(x: 10, y: 10, width: self.vChart.frame.width - 20, height: self.vChart.frame.height - 120))
        chart.delegate = self
        chart.xLabelsFormatter = {(labelIndex: Int, labelValue: Float) -> String in
            return ""}
        let series0 = ChartSeries(low)
        series0.color = UIColor.greenColor()
        chart.addSeries(series0)
        let series1 = ChartSeries(high)
        series1.color = UIColor.redColor()
        chart.addSeries(series1)
        
        self.vChart.addSubview(chart)
        
        //添加constraints
        let leading = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.vChart, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        
        let trailing = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.vChart, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        
        let top = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.vChart, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        let bottom = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.vChart, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        
        self.vChart.addConstraint(leading)
        self.vChart.addConstraint(trailing)
        self.vChart.addConstraint(top)
        self.vChart.addConstraint(bottom)
        
        chart.setTranslatesAutoresizingMaskIntoConstraints(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
