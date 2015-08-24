//
//  PriceViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/24.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class PriceViewController: UIViewController, HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource {

    @IBAction func btnRefreshPrice(sender: AnyObject) {

        
    }
    
    @IBOutlet weak var tvPriceTableView: UITableView!
    var selectionData = [String]()
    var selection: HTHorizontalSelectionList!
    
    @IBOutlet weak var vSelectionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selection = HTHorizontalSelectionList(frame: CGRect(x: 0, y: 0, width: vSelectionView.frame.width, height: vSelectionView.frame.height))
        selection?.delegate = self
        selection?.dataSource = self
        
        self.selection.selectionIndicatorStyle = HTHorizontalSelectionIndicatorStyle.BottomBar
        self.selection.selectionIndicatorColor = UIColor.redColor()
        self.selection.bottomTrimHidden = true
        self.selection.showsEdgeFadeEffect = true
        self.selection.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        self.selection.selectionIndicatorHorizontalPadding = 5.0
        
        vSelectionView.addSubview(selection)
        
        //添加constraints
        let leading = NSLayoutConstraint(item: selection, attribute: NSLayoutAttribute.LeadingMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.vSelectionView, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1, constant: 0)
        
        let traling = NSLayoutConstraint(item: selection, attribute: NSLayoutAttribute.TrailingMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.vSelectionView, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: 0)
        
        let top = NSLayoutConstraint(item: selection, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.vSelectionView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        let bottom = NSLayoutConstraint(item: selection, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.vSelectionView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        selection.setTranslatesAutoresizingMaskIntoConstraints(false)
        NSLayoutConstraint.activateConstraints([leading, traling, top, bottom])
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        tvPriceTableView.addGestureRecognizer(leftSwipe)
        tvPriceTableView.addGestureRecognizer(rightSwipe)
        
        self.getProductHierarchy()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProductHierarchy()
    {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        request(.GET, EndPoints.GetProductHierarchy.rawValue, parameters: ["method": "getmarkets"])
            .responseJSON { (request, response, data, error) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

                if let anError = error
                {
                    println(anError)
                }
                else if let data: AnyObject = data
                {
                    if let res1 = JSON(data).array
                    {
                        for r in res1
                        {
                            if let res2 = r.dictionary
                            {
                                self.selectionData.append(res2["name"]!.string!)
                            }
                        }
                        self.selection.reloadData()
                    }
                }
        }
        self.selection.reloadData()
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left && selection.selectedButtonIndex < selectionData.count - 1) {
            selection.selectedButtonIndex++
        }
        
        if (sender.direction == .Right && selection.selectedButtonIndex > 0) {
            selection.selectedButtonIndex--
        }
        selectionList(self.selection, didSelectButtonWithIndex: selection.selectedButtonIndex)
    }
    
    func numberOfItemsInSelectionList(selectionList: HTHorizontalSelectionList!) -> Int {
        return selectionData.count
    }
    
    func selectionList(selectionList: HTHorizontalSelectionList!, titleForItemWithIndex index: Int) -> String! {
        return selectionData[index]
    }
    
    func selectionList(selectionList: HTHorizontalSelectionList!, didSelectButtonWithIndex index: Int) {

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
