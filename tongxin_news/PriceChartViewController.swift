//
//  PriceChartViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/28.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class PriceChartViewController: UIViewController {
    
    @IBOutlet weak var vChart: UIView!
    @IBOutlet weak var navChart: UINavigationBar!
    var navTitle = "未知"
        //low, high, date, change
    var history = [(String, String, String, String)]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navChart.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        self.navChart.topItem?.title = navTitle
        
//        let chart = LineChartView()
//        vChart.addSubview(chart)
//        
//        //chart的约束
//        //添加constraints
//        let leading = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.LeadingMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.vChart, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1, constant: 0)
//        
//        let traling = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.TrailingMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.vChart, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: 0)
//        
//        let top = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.vChart, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
//        
//        let bottom = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.vChart, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
//        
//        chart.setTranslatesAutoresizingMaskIntoConstraints(false)
//        NSLayoutConstraint.activateConstraints([leading, traling, top, bottom])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
