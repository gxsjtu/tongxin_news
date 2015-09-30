//
//  ChannelItemAddViewController.swift
//  同鑫资讯
//
//  Created by 郭轩 on 15/9/7.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class ChannelItemAddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate,KASlideShowDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var slideView: KASlideShow!
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var btnChannelItemLocation: UIButton!
    @IBOutlet weak var txtChannelItemDesc: UITextView!//产品描述
    @IBOutlet weak var txtChannelItemContact: UITextField!//联系人
    @IBOutlet weak var txtChannelItemMobile: UITextField!//联系方式
    @IBOutlet weak var txtChannelItemQty: UITextField!//总量
    @IBOutlet weak var txtChannelItemSP: UITextField!//供应／采购
    @IBOutlet weak var rbOther: DLRadioButton!
    @IBOutlet weak var rbSelf: DLRadioButton!
    @IBOutlet weak var lblSPText: UILabel!
    @IBOutlet weak var rbPurchase: DLRadioButton!
    @IBOutlet weak var rbSupply: DLRadioButton!
    @IBOutlet weak var vChannelItemAddContent: UIView!
    @IBOutlet weak var vChannelItemAddImage: UIView!
    let imagePick : UIImagePickerController = UIImagePickerController()
    var imageList : Array<UIImage> = []
    var channelName = "未知"
    var catalogName = "未知"
    var catalogId = 0
    var channelId = 0
    var stateStr : String?//交货地－省份
    var cityStr : String?//交货地－城市
    var imagesName : String?//图片名字
    var itemId : String?
    var isLocationEmpty = true
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
        btnChannelItemLocation.backgroundColor = UIColor(red: 36/255, green: 124/255, blue: 151/255, alpha: 1)
        
        self.btnAddImage.addTarget(self, action: "addImage", forControlEvents: UIControlEvents.TouchUpInside)
        self.slideView.delegate = self
        self.slideView.delay = 1
        self.slideView.transitionDuration = 3.0
        self.slideView.transitionType = KASlideShowTransitionType.Slide
        self.slideView.imagesContentMode = UIViewContentMode.ScaleToFill
        self.slideView.addGesture(KASlideShowGestureType.Tap)
    }
    
    @IBAction func didPopupLocation(sender: AnyObject) {
        let location: TSLocateView = TSLocateView(title: "选择发货地", delegate: self)
        location.frame.size = CGSizeMake(self.view.frame.width, 260)
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
                isLocationEmpty = false
                self.stateStr = location.state
                self.cityStr = location.city
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
    
    func addImage()
    {
        showpic()
    }
    
    func showpic()
    {
        imagePick.delegate = self
        imagePick.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePick.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        imagePick.allowsEditing = false
        self.presentViewController(imagePick, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageList.append(gotImage)
        self.slideView.addImage(gotImage)
        self.slideView.start()
    }
    
    
    func uploadImage(parameters : Dictionary<String,String>) -> (URLRequestConvertible,NSData)
    {

        let uploadURL : String = EndPoints.SPList.rawValue
        let request = NSMutableURLRequest(URL: NSURL(string: uploadURL)!)
        request.HTTPMethod = "POST"
        
        let boundary:String="-------------------21212222222222222222222"
        let contentType : String = "multipart/form-data;boundary="+boundary
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        for img in self.imageList
        {
        body.appendData(NSString(format: "\r\n--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Disposition:form-data;name=\"userfile\";filename=\"dd.jpg\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Type:application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        let data = UIImagePNGRepresentation(img)
        body.appendData(data!)
        }
        for(key,value) in parameters
        {
            body.appendData("\r\n--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
         body.appendData(NSString(format:"\r\n--\(boundary)").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        return (ParameterEncoding.URL.encode(request, parameters: nil).0, body)
    }

    
    func createData()
    {
        let cId = self.catalogId
        var sOrP : String = "1"
        var sOro : String = "1"
        if self.rbSupply.selected
        {
            sOrP = "0"
        }
        else if self.rbPurchase.selected
        {
            sOrP = "1"
        }
        
        if self.rbSelf.selected
        {
            sOro = "1"
        }else if self.rbOther.selected
        {
            sOro = "0"
        }
        
        var parameters : Dictionary<String, String> = ["type":sOrP, "deliveryType":sOro]
        parameters["method"] = "create"
        parameters["catalogID"] = String(cId)
        parameters["product"] = self.txtChannelItemSP.text!
        parameters["quantity"] = self.txtChannelItemQty.text!
        parameters["mobile"] = self.txtChannelItemMobile.text!
        if let contact = self.txtChannelItemContact.text
        {
            parameters["contact"] = contact
        }
        else
        {
            parameters["contact"] = ""
        }
        if let desc = self.txtChannelItemDesc.text
        {
            parameters["description"] = desc
        }
        else
        {
            parameters["description"] = ""
        }
        parameters["province"] = self.stateStr!
        parameters["city"] = self.cityStr!
        
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let urlRequest = self.uploadImage(parameters)
        upload(urlRequest.0, data: urlRequest.1).responseJSON{
        response in
           print(response)
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        switch response.result {
            case .Success:
                if let data: AnyObject = response.result.value
                    {
                        var res = JSON(data)
                        let result = res["result"].string!
                        if(result == "ok")
                            {
                                let alert = SKTipAlertView()
                                alert.showRedNotificationForString("添加成功，请等待审核！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                                
                                let vc : ChannelViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChannelVC") as! ChannelViewController
                                vc.channelId = self.channelId
                                vc.channelName = self.channelName
                                self.presentViewController(vc, animated: true, completion: nil)
                             }
                        }
            
                case .Failure:
                    print(response.debugDescription)
                    let alert = SKTipAlertView()
                        alert.showRedNotificationForString("加载失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                    }
        }
    }
    
    
    @IBAction func addData(sender: UIBarButtonItem) {
        if txtChannelItemSP.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
        {
            let alert = SKTipAlertView()
            alert.showRedNotificationForString(lblSPText.text! + "内容不能为空！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
            return
        }
        if txtChannelItemQty.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
        {
            let alert = SKTipAlertView()
            alert.showRedNotificationForString("供需数量不能为空！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
            return
        }
        if txtChannelItemMobile.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
        {
            let alert = SKTipAlertView()
            alert.showRedNotificationForString("联系方式不能为空！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
            return
        }
        if isLocationEmpty == true
        {
            let alert = SKTipAlertView()
            alert.showRedNotificationForString("发货地不能为空！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
            return
        }
        createData()
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
