//
//  ChannelView4PricesVC.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/12/24.
//  Copyright © 2015年 郭轩. All rights reserved.
//

import UIKit
import RAReorderableLayout

class ChannelView4PricesVC: UIViewController, RAReorderableLayoutDataSource, RAReorderableLayoutDelegate {
    
    @IBOutlet weak var consInViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var cvOutBucket: UICollectionView!
    @IBOutlet weak var cvInBucket: UICollectionView!
    var inBucket = [(id: Int, name: String)]()
    var outBucket = [(id: Int, name: String)]()
    var parentVC: UIViewController?

    @IBOutlet weak var outView: UIView!
    @IBOutlet weak var inView: UIView!
    @IBAction func didClose(sender: AnyObject) {
        self.view.hidden = true
        var inBucketString = ""
        let mobile : String? = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
        if let parent = self.parentVC as? PriceViewController
        {
            parent.selectionData.removeAll(keepCapacity: true)
            for index: (Int, String) in self.inBucket
            {
                parent.selectionData.append(index.1)
                inBucketString.appendContentsOf(String(index.0) + "|")
            }
            parent.inBucket = self.inBucket
            parent.outBucket = self.outBucket
            parent.selection.selectedButtonIndex = 0
            parent.selection.reloadData()
            parent.selectionList(parent.selection, didSelectButtonWithIndex: 0)
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.GetProductHierarchy.rawValue, parameters: ["mobile": mobile!, "method": "groupChannel", "groups": inBucketString])
                .responseJSON { response in
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        }
        else if let parent = self.parentVC as? CommentViewController
        {
            parent.selectionData.removeAll(keepCapacity: true)
            for index: (Int, String) in self.inBucket
            {
                parent.selectionData.append(index.1)
                inBucketString.appendContentsOf(String(index.0) + "|")
            }
            parent.inBucket = self.inBucket
            parent.outBucket = self.outBucket
            parent.selection.selectedButtonIndex = 0
            parent.selection.reloadData()
            parent.selectionList(parent.selection, didSelectButtonWithIndex: 0)
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.GetCommentHierarchy.rawValue, parameters: ["mobile": mobile!, "method": "groupChannel", "groups": inBucketString])
                .responseJSON { response in
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        }
        
        //更新数据库

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inBucket.removeAll(keepCapacity: true)
        self.outBucket.removeAll(keepCapacity: true)
        
        self.cvInBucket.delegate = self
        self.cvInBucket.dataSource = self
        self.cvInBucket.backgroundColor = UIColor.clearColor()
        
        self.cvOutBucket.delegate = self
        self.cvOutBucket.dataSource = self
        self.cvOutBucket.backgroundColor = UIColor.clearColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cvInBucket
        {
            return self.inBucket.count
        }
        else
        {
            return self.outBucket.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == self.cvInBucket
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("inCell", forIndexPath: indexPath) as! ChannelCell4Prices
            cell.lblChannel.text = self.inBucket[indexPath.row].name
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            if cell.lblChannel.text?.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding) > 8
            {
                cell.lblChannel.font = UIFont.systemFontOfSize(11)
            }
            else
            {
                cell.lblChannel.font = UIFont.systemFontOfSize(15)
            }
            
            if indexPath.row == 0
            {
                cell.backgroundColor = UIColor.darkGrayColor()
            }
            else
            {
                cell.backgroundColor = UIColor(red: 52/255, green: 181/255, blue: 239/255, alpha: 1)
            }
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("outCell", forIndexPath: indexPath) as! ChannelCell4Prices
            cell.lblChannel.text = self.outBucket[indexPath.row].1
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            if cell.lblChannel.text?.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding) > 8
            {
                cell.lblChannel.font = UIFont.systemFontOfSize(11)
            }
            else
            {
                cell.lblChannel.font = UIFont.systemFontOfSize(15)
            }
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 80, height: 30)
    }
    
    func collectionView(collectionView: UICollectionView, atIndexPath: NSIndexPath, canMoveToIndexPath: NSIndexPath) -> Bool {
        if collectionView == self.cvOutBucket
        {
            return false
        }
        if collectionView == self.cvInBucket
        {
            if atIndexPath.row == 0 || canMoveToIndexPath.row == 0
            {
                return false
            }
        }
        return true
    }
    
    func collectionView(collectionView: UICollectionView, atIndexPath: NSIndexPath, didMoveToIndexPath toIndexPath: NSIndexPath) {
        if collectionView == self.cvInBucket
        {
            let tmp: (Int, String) = self.inBucket[atIndexPath.row]
            self.inBucket.removeAtIndex(atIndexPath.row)
            self.inBucket.insert(tmp, atIndex: toIndexPath.row)
        }
        else
        {
            let tmp: (Int, String) = self.outBucket[atIndexPath.row]
            self.outBucket.removeAtIndex(atIndexPath.row)
            self.outBucket.insert(tmp, atIndex: toIndexPath.row)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.cvInBucket
        {
            if indexPath.row == 0
            {
                return
            }
            let tmp: (Int, String) = self.inBucket[indexPath.row]
            self.inBucket.removeAtIndex(indexPath.row)
            self.outBucket.append(tmp)
        }
        else
        {
            let tmp: (Int, String) = self.outBucket[indexPath.row]
            self.outBucket.removeAtIndex(indexPath.row)
            self.inBucket.append(tmp)
        }
        let origin = self.cvInBucket.collectionViewLayout.collectionViewContentSize()
        self.cvOutBucket.reloadData()
        self.cvInBucket.reloadData()
        let new = self.cvInBucket.collectionViewLayout.collectionViewContentSize()
        self.consInViewHeight.constant += (new.height - origin.height)
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
