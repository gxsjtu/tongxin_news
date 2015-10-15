import UIKit

class InboxViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate
{
    
    @IBOutlet weak var clearBar: UIBarButtonItem!
    //@IBOutlet weak var segmentCon: UISegmentedControl!
    //@IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var searchCon: UISearchBar!
    @IBOutlet weak var navInbox: UINavigationBar!
    @IBOutlet weak var tbData: UITableView!
    
    @IBAction func didInboxRefresh(sender: AnyObject) {
        initLoadDatas()
    }
    var msgInfos : Array<MsgInfo> = []
    var resInfos : Array<MsgInfo> = []
    var segmentindex : Int = 0
    var products = [(String, String, String, String, String)]()
    var nowDate : NSDate?
    var nowDateForCom : NSDate?
    var mobile : String?
    var isLoadOK : String?//是否下拉加载数据成功 用来清零未读消息
    
    //记录刷新时间
    var maxDateForMsg : NSDate?
    var minDateForMsg : NSDate?
    override func viewDidLoad() {
        super.viewDidLoad()
        initLoadDatas()
        self.navInbox.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        self.tbData.dataSource = self
        self.tbData.delegate = self
        self.tbData.estimatedRowHeight = 1000
        self.tbData.rowHeight = UITableViewAutomaticDimension
        self.searchCon.delegate = self
        
        self.tbData.addHeaderWithCallback(pullDownLoadDatas)
        self.tbData.addFooterWithCallback(pullUpLoadDatas)
        tbData.headerRefreshingText = "正在刷新..."
        tbData.footerRefreshingText = "正在刷新..."
        // Do any additional setup after loading the view.
        
        //监听Badge消息
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBadgeNumber:", name: "Badge", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tbData.reloadData()
    }
    
    func updateBadgeNumber(notification: NSNotification)
    {
        if notification.userInfo == nil
        {
            if UIApplication.sharedApplication().applicationIconBadgeNumber == 0
            {
                self.tabBarItem.badgeValue = nil
            }
            else
            {
                self.tabBarItem.badgeValue = String(UIApplication.sharedApplication().applicationIconBadgeNumber)
            }
        }
        else
        {
            if let aps: AnyObject = notification.userInfo?["aps"] {
                if let apsDict = aps as? [String : AnyObject]{
                    if let badge: AnyObject = apsDict["badge"] {
                        self.tabBarItem.badgeValue = String(badge as! Int)
                    }
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if(searchBar.text == "")
        {
            self.resInfos = self.msgInfos
            //self.resComInfos = self.comInfos
        }
        else
        {
            self.resInfos = Array<MsgInfo>()
            for msgInfo in self.msgInfos
            {
                if(msgInfo.msg!.componentsSeparatedByString(searchBar.text!).count > 1)
                {
                    resInfos.append(msgInfo)
                }
            }
        }
        self.tbData.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.resInfos = []
        self.resInfos = self.msgInfos
        self.tbData.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resInfos.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let tbCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        tbCell
        if(tbCell.viewWithTag(3) != nil)
        {
            tbCell.viewWithTag(3)?.removeFromSuperview()
        }
        let lblUrl : UILabel = UILabel()
        lblUrl.tag = 3
        lblUrl.text = resInfos[indexPath.row].url
        lblUrl.hidden = true
        tbCell.addSubview(lblUrl)
        
        let msg : String = resInfos[indexPath.row].msg! + "\n"
        let date : String = format.stringFromDate(resInfos[indexPath.row].dateStr!)
        let str : String = msg + date
        let attribute = NSMutableAttributedString(string:str)
        let attr1 = [NSForegroundColorAttributeName:UIColor.blackColor()]
        attribute.addAttributes(attr1, range: NSMakeRange(0, (msg as NSString).length - 1))
        let attr2 = [NSForegroundColorAttributeName:UIColor.orangeColor()]
        attribute.addAttributes(attr2, range: NSMakeRange(((msg as NSString).length), (str as NSString).length - (msg as NSString).length))
        tbCell.textLabel?.attributedText = attribute
        tbCell.textLabel?.numberOfLines = 0
        
        if(resInfos[indexPath.row].url != nil && resInfos[indexPath.row].url != "")
        {
            tbCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        else
        {
            tbCell.accessoryType = UITableViewCellAccessoryType.None
        }
        
            return tbCell
  
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ComToCommentDetail"
        {
            if let des = segue.destinationViewController as? CommentContentViewController
            {
                if let cell = sender as? UITableViewCell
                {
                    des.navTitle = "同鑫评论"
                    des.url = (cell.viewWithTag(3) as! UILabel).text!
                }
            }
        }

    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "ComToCommentDetail"
        {
            if let cell = sender as? UITableViewCell
                {
                    if((cell.viewWithTag(3) as! UILabel).text == nil || (cell.viewWithTag(3) as! UILabel).text == "")
                    {
                        return false
                    }
                }
        }
        return true
    }
    
    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        if (action == Selector("copy:")) {
            return true
        }
        return false
    }
    
    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?){
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        UIPasteboard.generalPasteboard().string = cell?.textLabel?.text
    }
    
    @IBAction func unwindFromComment2Inbox(segue: UIStoryboardSegue)
    {
    
    }
    
    func initLoadDatas()
    {
        self.mobile = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

//        self.msgInfos = []
//        self.resInfos = []
        (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.InBoxMsg.rawValue,parameters:["mobile": self.mobile!, "method": "getInboxMsg"]).responseJSON{
            response in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            switch response.result {
            case .Success:
                self.msgInfos = []
                self.resInfos = []
                if let data: AnyObject = response.result.value
                {
                    if let dataList: NSArray = data as? NSArray
                    {
                        for (var i = 0; i < dataList.count; i++)
                        {
                            let res = JSON(dataList[i])
                            
                            let msgData : MsgInfo = MsgInfo()
                            msgData.dateStr =  format.dateFromString(res["date"].string!)
                            msgData.msg = res["msg"].string
                            msgData.url = res["url"].string
                            self.msgInfos.append(msgData)
                        }
                        self.msgInfos.sortInPlace({ (s1:MsgInfo, s2:MsgInfo) -> Bool in
                            s1.dateStr?.timeIntervalSinceReferenceDate >= s2.dateStr?.timeIntervalSinceReferenceDate
                        })
                        self.resInfos = self.msgInfos
                        self.tbData.reloadData()
                        self.isLoadOK = "YES"
                        //self.segmentCon.enabled = true
                        if(self.msgInfos.count > 0)
                        {
                            self.maxDateForMsg = self.msgInfos.first?.dateStr
                            self.minDateForMsg = self.msgInfos.last?.dateStr
                        }
                        if self.isLoadOK == "YES"
                        {
                            //下拉成功 未读消息清零
                            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                            self.tabBarItem.badgeValue = nil
                            (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET,EndPoints.MessageInfo.rawValue,parameters:["mobile":self.mobile!,"method":"clearMessage"]).responseJSON{
                                response in
                                
                                switch response.result {
                                case .Success:
                                    break
//                                    if let data: AnyObject = response.result.value
//                                    {
//                                        var result = JSON(data)
//                                        if(result["result"].string! == "ok")
//                                        {
//                                            print("清理成功")
//                                        }
//                                        else
//                                        {
//                                            print("清理失败")
//                                        }
//                                    }
                                    
                                case .Failure:
                                    let alert = SKTipAlertView()
                                    alert.showRedNotificationForString("加载失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                                }
                            }
                        }
                    }
                }
                
            case .Failure:
                self.isLoadOK = "NO"
                let alert = SKTipAlertView()
                alert.showRedNotificationForString("加载失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
            }
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "")
        {
            self.resInfos = self.msgInfos
            //self.resComInfos = self.comInfos
        }
        else
        {
            self.resInfos = Array<MsgInfo>()
            for msgInfo in self.msgInfos
            {
                if(msgInfo.msg!.componentsSeparatedByString(searchText).count > 1)
                {
                    resInfos.append(msgInfo)
                }
            }
        }
        self.tbData.reloadData()
    }
    
    //上拉加载更小日期
    func pullUpLoadDatas()
    {
        var minDate : NSDate?
        var finalDate : String?
        var actionStr : String?
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"

//        if(self.segmentindex == 0)
//        {
            minDate = self.minDateForMsg
            if(minDate != nil)
            {
                actionStr = "pullUp"
                finalDate = format.stringFromDate(minDate!)
            
            }else
            {
                if(self.nowDate == nil)
                {
                self.nowDate = NSDate()
                }
                let dateStr : String = format.stringFromDate(self.nowDate!)//如果上一次刷新时间为空赋值当前时间 不为空直接把上次刷新时间传给方法
                finalDate = dateStr
                actionStr = "pullDown"
                
//                self.nowDate = NSDate()//记录当前刷新的时间 如果没数据 为下一次刷新提供上一次刷新时间
            }
            (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.InBoxMsg.rawValue,parameters:["mobile":self.mobile!,"method":"getMsgByAction","actionStr" : actionStr!,"dateStr": finalDate!]).responseJSON{
                response in
                
                switch response.result {
                case .Success:
                    if let data: AnyObject = response.result.value
                    {
                        if let dataList : NSArray = data as? NSArray
                        {
                            for (var i = 0; i < dataList.count; i++)
                            {
                                let res = JSON(dataList[i])
                                
                                let msgData : MsgInfo = MsgInfo()
                                msgData.dateStr =  format.dateFromString(res["date"].string!)
                                msgData.msg = res["msg"].string
                                msgData.url = res["url"].string
                                self.msgInfos.append(msgData)
                            }
                            self.msgInfos.sortInPlace({ (s1:MsgInfo, s2:MsgInfo) -> Bool in
                                s1.dateStr?.timeIntervalSinceReferenceDate >= s2.dateStr?.timeIntervalSinceReferenceDate
                            })
                            self.nowDate = NSDate()//刷新成功后记录当前刷新的时间 如果没数据 为下一次刷新提供上一次刷新时间
                            self.resInfos = self.msgInfos
                            self.tbData.reloadData()
                            self.tbData.footerEndRefreshing()
                            if(self.msgInfos.count > 0)
                            {
                                self.minDateForMsg = self.msgInfos.last?.dateStr
                            }
                        }
                    }
                    
                case .Failure:
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                    self.tbData.footerEndRefreshing()
                }
            }
    }
    //下拉加载更大日期
    func pullDownLoadDatas()
    {
        var maxDate : NSDate?
        var finalDate : String?
        var actionStr : String?
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"

            maxDate = self.maxDateForMsg
            
            if(maxDate != nil)
            {
            finalDate = format.stringFromDate(maxDate!)
            actionStr = "pullDown"
            }
            else
            {
                if(self.nowDate == nil)
                {
                self.nowDate = NSDate()
                }
                let dateStr : String = format.stringFromDate(self.nowDate!)//如果上一次刷新时间为空赋值当前时间 不为空直接把上次刷新时间传给方法
                finalDate = dateStr
                actionStr = "pullDown"
                
//                self.nowDate = NSDate()//记录当前刷新的时间 如果没数据 为下一次刷新提供上一次刷新时间
            }
            (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET, EndPoints.InBoxMsg.rawValue,parameters:["mobile":self.mobile!,"method":"getMsgByAction","actionStr" : actionStr!,"dateStr": finalDate!]).responseJSON{
                response in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                switch response.result {
                case .Success:
                    if let data: AnyObject = response.result.value
                    {
                        if let dataList: NSArray = data as? NSArray
                        {
                            for (var i = 0; i < dataList.count; i++)
                            {
                                let res = JSON(dataList[i])
                                
                                let msgData : MsgInfo = MsgInfo()
                                msgData.dateStr =  format.dateFromString(res["date"].string!)
                                msgData.msg = res["msg"].string
                                msgData.url = res["url"].string
                                self.msgInfos.append(msgData)
                            }
                            self.msgInfos.sortInPlace({ (s1:MsgInfo, s2:MsgInfo) -> Bool in
                                s1.dateStr?.timeIntervalSinceReferenceDate >= s2.dateStr?.timeIntervalSinceReferenceDate
                            })
                            self.nowDate = NSDate()//刷新成功后记录当前刷新的时间 如果没数据 为下一次刷新提供上一次刷新时间
                            self.resInfos = self.msgInfos
                            self.tbData.reloadData()
                            self.tbData.headerEndRefreshing()
                            self.isLoadOK = "YES"
                            //self.segmentCon.enabled = true
                            if(self.msgInfos.count > 0)
                            {
                                self.maxDateForMsg = self.msgInfos.first?.dateStr
                            }
                            if self.isLoadOK == "YES"
                            {
                                //下拉成功 未读消息清零
                                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                                self.tabBarItem.badgeValue = nil
                                (UIApplication.sharedApplication().delegate as! AppDelegate).manager!.request(.GET,EndPoints.MessageInfo.rawValue,parameters:["mobile":self.mobile!,"method":"clearMessage"]).responseJSON{
                                    response in
                                    
                                    switch response.result {
                                    case .Success:
                                        if let data: AnyObject = response.result.value
                                        {
                                            var result = JSON(data)
                                            if(result["result"].string! == "ok")
                                            {
                                                print("清理成功")
                                            }
                                            else
                                            {
                                                print("清理失败")
                                            }
                                        }
                                        
                                    case .Failure:
                                        let alert = SKTipAlertView()
                                        alert.showRedNotificationForString("加载失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                                    }
                                }
                            }
                        }
                    }
                case .Failure:
                    self.isLoadOK = "NO"
                    let alert = SKTipAlertView()
                    alert.showRedNotificationForString("加载失败，请返回重试！", forDuration: 2.0, andPosition: SKTipAlertViewPositionTop, permanent: false)
                    self.tbData.headerEndRefreshing()
                }
            }
    }
    
    
    @IBAction func clearMsg(sender: AnyObject) {

            self.resInfos = []
            self.msgInfos = []

            self.tbData.reloadData()
    }
    
    
}

class MsgInfo : NSObject
{
    var msg : String?
    var dateStr : NSDate?
    var url : String?
}


extension UILabel{
    func initAutoHeight(rect:CGRect,textColor:UIColor, fontSize:CGFloat, text:NSString, lineSpacing:CGFloat){//自适应高度
    self.frame = rect
    self.textColor = textColor
    self.font = UIFont.systemFontOfSize(fontSize)
    self.lineBreakMode = NSLineBreakMode.ByWordWrapping
    self.numberOfLines = 0
    let attributedString = NSMutableAttributedString(string: text as String)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    paragraphStyle.lineBreakMode = NSLineBreakMode.ByCharWrapping
    attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, text.length))
    self.attributedText = attributedString
    self.sizeToFit()
    self.frame.size.width = rect.width
    self.frame.size.height = max(self.frame.size.height, rect.height)
    }
}

