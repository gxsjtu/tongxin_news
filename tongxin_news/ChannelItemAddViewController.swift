//
//  ChannelItemAddViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/7.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class ChannelItemAddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate {

    @IBAction func didAddImage(sender: AnyObject) {
        
    }
    
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var btnChannelItemLocation: UIButton!
    @IBOutlet weak var txtChannelItemDesc: UITextView!
    @IBOutlet weak var txtChannelItemContact: UITextField!
    @IBOutlet weak var txtChannelItemMobile: UITextField!
    @IBOutlet weak var txtChannelItemQty: UITextField!
    @IBOutlet weak var txtChannelItemSP: UITextField!
    @IBOutlet weak var rbOther: DLRadioButton!
    @IBOutlet weak var rbSelf: DLRadioButton!
    @IBOutlet weak var lblSPText: UILabel!
    @IBOutlet weak var rbPurchase: DLRadioButton!
    @IBOutlet weak var rbSupply: DLRadioButton!
    @IBOutlet weak var vChannelItemAddContent: UIView!
    @IBOutlet weak var vChannelItemAddImage: UIView!
    var channelName = "未知"
    var catalogName = "未知"
    var catalogId = 0
    @IBOutlet weak var navChannelItem: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navChannelItem.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        self.navChannelItem.topItem?.title = "商圈 - " + channelName + " - " + catalogName
        
        rbPurchase.otherButtons = [rbSupply]
        rbPurchase.selected = true
        
        rbSelf.otherButtons = [rbOther]
        rbSelf.selected = true
        btnAddImage.backgroundColor = UIColor(red: 68/255, green: 73/255, blue: 75/255, alpha: 0.6)
    }
    
    @IBAction func didPopupLocation(sender: AnyObject) {
        
        let location = TSLocateView(title: "选择发货地", delegate: self)
        location.backgroundColor = UIColor(red: 36/255, green: 124/255, blue: 151/255, alpha: 1)
        location.titleLabel.frame = CGRectMake(0, 0, self.view.frame.width, 40)
        location.titleLabel.textColor = UIColor.whiteColor()
        location.showInView(self.view)
    }
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if let locationView = actionSheet as? TSLocateView
        {
            let location = locationView.locate
            if buttonIndex == 0
            {
                locationView.hidden = true
                btnChannelItemLocation.setTitle(location.state + location.city, forState: UIControlState.Normal)
            }
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            txtChannelItemDesc.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    @IBAction func didSPChanged(sender: AnyObject) {
        if rbSupply.selected == true
        {
            lblSPText.text = rbSupply.titleLabel?.text
        }
        else
        {
            lblSPText.text = rbPurchase.titleLabel?.text
        }
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
