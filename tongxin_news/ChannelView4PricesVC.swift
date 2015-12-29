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
    
    @IBOutlet weak var cvBase: UICollectionView!
    @IBOutlet weak var btnClose: UIButton!
    var inBucket = [(id: Int, name: String)]()
    var outBucket = [(id: Int, name: String)]()
    var parentVC: UIViewController?

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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inBucket.removeAll(keepCapacity: true)
        self.outBucket.removeAll(keepCapacity: true)
        
        self.cvBase.delegate = self
        self.cvBase.dataSource = self
        self.cvBase.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0
        {
            return self.inBucket.count
        }
        else
        {
            return self.outBucket.count
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ChannelCell4Prices
        if indexPath.section == 0
        {
        
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
                cell.lblChannel.backgroundColor = UIColor.darkGrayColor()
            }
            else
            {
                cell.lblChannel.backgroundColor = UIColor(red: 52/255, green: 181/255, blue: 239/255, alpha: 1)
            }
            return cell
        }
        else
        {
            cell.lblChannel.text = self.outBucket[indexPath.row].1
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            cell.lblChannel.backgroundColor = UIColor(red: 52/255, green: 181/255, blue: 239/255, alpha: 1)
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
        return UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 80, height: 30)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var headerView: ChannelHeaderView? = nil
        if kind == UICollectionElementKindSectionHeader
        {
            headerView =
            collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                withReuseIdentifier: "header",
                forIndexPath: indexPath) as? ChannelHeaderView
            if indexPath.section == 0
            {
                headerView!.Title.text = "我的频道"
                headerView!.Subtitle.text = "拖拽可以排序，点击可以移除"
            }
            else
            {
                headerView!.Title.text = "更多频道"
                headerView!.Subtitle.text = "点击添加到我的频道"
            }
            return headerView!
        }
        return headerView!
    }
    
    func collectionView(collectionView: UICollectionView, atIndexPath: NSIndexPath, canMoveToIndexPath: NSIndexPath) -> Bool {
        if atIndexPath.section == 1
        {
            return false
        }
        if atIndexPath.section == 0
        {
            if atIndexPath.row == 0 || canMoveToIndexPath.row == 0
            {
                return false
            }
        }
        return true
    }
    
    func collectionView(collectionView: UICollectionView, atIndexPath: NSIndexPath, didMoveToIndexPath toIndexPath: NSIndexPath) {
        if atIndexPath.section == 0
        {
            let tmp: (Int, String) = self.inBucket[atIndexPath.row]
            self.inBucket.removeAtIndex(atIndexPath.row)
            self.inBucket.insert(tmp, atIndex: toIndexPath.row)
        }
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                return
            }
            let tmp: (Int, String) = self.inBucket[indexPath.row]
            self.inBucket.removeAtIndex(indexPath.row)
            self.outBucket.append(tmp)
            collectionView.moveItemAtIndexPath(indexPath, toIndexPath: NSIndexPath(forRow: self.outBucket.count - 1, inSection: 1))
        }
        else
        {
            let tmp: (Int, String) = self.outBucket[indexPath.row]
            self.outBucket.removeAtIndex(indexPath.row)
            self.inBucket.append(tmp)
            collectionView.moveItemAtIndexPath(indexPath, toIndexPath: NSIndexPath(forRow: self.inBucket.count - 1, inSection: 0))
        }
        self.cvBase.reloadData()
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
