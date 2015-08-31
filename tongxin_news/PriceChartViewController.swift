//
//  PriceChartViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/28.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class PriceChartViewController: UIViewController {
    
    @IBOutlet weak var lblPriceChart: UILabel!
    @IBOutlet weak var vChart: UIView!
    @IBOutlet weak var navChart: UINavigationBar!
    var navTitle = "未知"
        //low, high, date, change
    var history = [(String, String, String, String)]()
    
    var low = [Float]()
    var high = [Float]()
    var date = [String]()
    var labels: Array<Float> = []
    var labelsAsString: Array<String> = []
    var start = -1

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
            labels.append(Float(start++))
        }
        
        let chart = Chart(frame: CGRect(x: 10, y: 10, width: self.vChart.frame.width - 20, height: self.vChart.frame.height - 120))
        chart.xLabels = labels
        chart.xLabelsFormatter = {(labelIndex: Int, labelValue: Float) -> String in
            return ""}
        let series0 = ChartSeries(low)
        series0.color = UIColor.greenColor()
        chart.addSeries(series0)
        let series1 = ChartSeries(high)
        series1.color = UIColor.redColor()
        chart.addSeries(series1)
        
        self.vChart.addSubview(chart)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
