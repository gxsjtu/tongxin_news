import UIKit

class InboxViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate
{
    
    @IBOutlet weak var clearBar: UIBarButtonItem!
    @IBOutlet weak var segmentCon: UISegmentedControl!
    //@IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var searchCon: UISearchBar!
    @IBOutlet weak var navInbox: UINavigationBar!
    @IBOutlet weak var tbData: UITableView!
    
    var msgInfos : Array<MsgInfo> = []
    var resInfos : Array<MsgInfo> = []
    var segmentindex : Int = 0
    var products = [(String, String, String, String, String)]()
    
    var comInfos : Array<CommentInfo> = []
    var resComInfos : Array<CommentInfo> = []
    var nowDate : NSDate?
    var nowDateForCom : NSDate?
    var mobile : String?
    var isLoadOK : String?//是否下拉加载数据成功 用来清零未读消息
    
    //记录刷新时间
    var maxDateForMsg : NSDate?
    var minDateForMsg : NSDate?
    var maxDateForCom : NSDate?
    var minDateForCom : NSDate?
    override func viewDidLoad() {
        super.viewDidLoad()
         initLoadDatas()
        self.navInbox.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        self.tbData.dataSource = self
        self.tbData.delegate = self
        self.searchCon.delegate = self
        
        self.tbData.addHeaderWithCallback(pullDownLoadDatas)
        self.tbData.addFooterWithCallback(pullUpLoadDatas)
        tbData.headerRefreshingText = "正在刷新..."
        tbData.footerRefreshingText = "正在刷新..."
        // Do any additional setup after loading the view.
        
        //监听Badge消息
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBadgeNumber:", name: "Badge", object: nil)
    }
    
    func updateBadgeNumber(notification: NSNotification)
    {
        if let aps: AnyObject = notification.userInfo?["aps"] {
            if let apsDict = aps as? [String : AnyObject]{
                if let badge: AnyObject = apsDict["badge"] {
                    self.tabBarItem.badgeValue = String(badge as! Int)
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        if(self.segmentindex == 0)
        {
            self.resInfos = []
            self.resInfos = self.msgInfos
        }
        else
        {
            self.resComInfos = []
            self.resComInfos = self.comInfos
        }
        self.tbData.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if(segmentindex == 0)
      {
        return self.resInfos.count
        }
        else
      {
        return self.resComInfos.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(self.segmentindex == 0)
        {
            var format = NSDateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var msg : String = resInfos[indexPath.row].msg!
            var date : String = format.stringFromDate(resInfos[indexPath.row].dateStr!)
            var lb : UILabel!  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width - 10, height: 0))
            lb.initAutoHeight(lb.frame, textColor: UIColor.blackColor(), fontSize: 17, text: msg, lineSpacing: 1)
            var lbDate : UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 0))
            lbDate.initAutoHeight(lbDate.frame, textColor: UIColor.yellowColor(), fontSize: 10, text: date, lineSpacing: 1)
            return (lb.frame.height + lbDate.frame.height + 10)
        }
        else
        {
            return 64
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if(self.segmentindex == 0)
        {
            let tbCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
            var format = NSDateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if(tbCell.viewWithTag(1) != nil){
                tbCell.viewWithTag(1)?.removeFromSuperview()
            }
            if(tbCell.viewWithTag(2) != nil){
                tbCell.viewWithTag(2)?.removeFromSuperview()
            }
           
            var msg : String = resInfos[indexPath.row].msg!
            var date : String = format.stringFromDate(resInfos[indexPath.row].dateStr!)

            
            var lblMsg : UILabel = UILabel(frame: CGRect(x: 5, y: 2, width: tbCell.frame.size.width, height: 0))
            lblMsg.tag = 1
            lblMsg.lineBreakMode = NSLineBreakMode.ByWordWrapping
            lblMsg.numberOfLines = 0
            lblMsg.initAutoHeight(lblMsg.frame, textColor: UIColor.blackColor(), fontSize: 17, text: msg, lineSpacing: 1)
            tbCell.addSubview(lblMsg)
            var lblDate : UILabel = UILabel(frame: CGRect(x: 5, y: lblMsg.frame.size.height + 2, width: tbCell.frame.size.width, height: 0))
            lblDate.tag = 2
            lblDate.lineBreakMode = NSLineBreakMode.ByWordWrapping
            lblDate.numberOfLines = 0
            lblDate.initAutoHeight(lblDate.frame, textColor: UIColor.orangeColor(), fontSize: 14, text: date, lineSpacing: 1)
            tbCell.addSubview(lblDate)
            tbCell.accessoryType = UITableViewCellAccessoryType.None
            
            return tbCell
        }
        else
        {
            var format = NSDateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            let tbCell2 = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! UITableViewCell
            (tbCell2.viewWithTag(1) as! UIImageView).hnk_setImageFromURL(NSURL(string: self.resComInfos[indexPath.row].imgUrl!))
            (tbCell2.viewWithTag(2) as! UILabel).text = self.resComInfos[indexPath.row].title!
            (tbCell2.viewWithTag(3) as! UILabel).text = self.resComInfos[indexPath.row].proName
            (tbCell2.viewWithTag(4) as! UILabel).text = format.stringFromDate(self.resComInfos[indexPath.row].date!)
            (tbCell2.viewWithTag(5) as! UILabel).text = self.resComInfos[indexPath.row].url
            (tbCell2.viewWithTag(6) as! UILabel).text = self.resComInfos[indexPath.row].marketName

            return tbCell2
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ComToCommentDetail"
        {
            if let des = segue.destinationViewController as? CommentContentViewController
            {
                if let cell = sender as? UITableViewCell
                {
                    des.navTitle = (cell.viewWithTag(6) as! UILabel).text! + "-" + (cell.viewWithTag(3) as! UILabel).text!
                    des.url = (cell.viewWithTag(5) as! UILabel).text!
                }
            }
        }

    }
    
    @IBAction func unwindFromComment2Inbox(segue: UIStoryboardSegue)
    {
    
    }
    
    func initLoadDatas()
    {
        var isLogined : String? = NSUserDefaults.standardUserDefaults().stringForKey("isLoggedIn")
        
        if(isLogined != "yes")
        {
            //转向login页面
            if let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
            {
                self.presentViewController(loginVC, animated: true, completion: nil)
            }
        }
        else
        {
            self.mobile = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
            var format = NSDateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
           if(self.segmentindex == 0)
           {
                self.msgInfos = []
                self.resInfos = []
            request(.GET, EndPoints.InBoxMsg.rawValue,parameters:["mobile":self.mobile!,"method":"getInboxMsg"]).responseJSON{
                (request,response,data,error) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if let anError = error
                {
                    println(anError)
                }
                else if let dataList : NSArray = data! as? NSArray
                {
                    
                    for (var i = 0; i < dataList.count; i++)
                    {
                        let res = JSON(dataList[i])
                        
                        var msgData : MsgInfo = MsgInfo()
                        msgData.dateStr =  format.dateFromString(res["date"].string!)
                        msgData.msg = res["msg"].string
                        self.msgInfos.append(msgData)
                    }
                    self.msgInfos.sort({ (s1:MsgInfo, s2:MsgInfo) -> Bool in
                        s1.dateStr?.timeIntervalSinceReferenceDate >= s2.dateStr?.timeIntervalSinceReferenceDate
                    })
                    self.resInfos = self.msgInfos
                    self.tbData.reloadData()
                    self.segmentCon.enabled = true
                    if(self.msgInfos.count > 0)
                    {
                    self.maxDateForMsg = self.msgInfos.first?.dateStr
                    self.minDateForMsg = self.msgInfos.last?.dateStr
                    }
                }
            }

            }
            else//评论
           {
            self.comInfos = []
            self.resComInfos = []
            
            request(.GET, EndPoints.GetCommentHierarchy.rawValue, parameters: ["method": "getCommentByMobile", "mobile": self.mobile!])
                .responseJSON { (request, response, data, error) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    if let anError = error
                    {
                        println(anError)
                    }
                    else if let data: AnyObject = data
                    {
                        if let res = JSON(data).array
                        {
                            for item in res
                            {
                                var comInfo : CommentInfo = CommentInfo()
                                //comInfo
                                comInfo.id = (item["id"].string!).toInt()
                                comInfo.title = item["title"].string!
                                comInfo.imgUrl = item["avatar"].string!
                                comInfo.url = item["url"].string!
                                comInfo.date = format.dateFromString(item["date"].string!)
                                comInfo.proName = item["productname"].string!
                                comInfo.marketName = item["marketname"].string!
                                self.comInfos.append(comInfo)
                            }
                            self.comInfos.sort({ (c1 : CommentInfo, c2 : CommentInfo) -> Bool in
                                c1.date?.timeIntervalSinceReferenceDate >= c2.date?.timeIntervalSinceReferenceDate
                            })
                            self.resComInfos = self.comInfos
                            self.tbData.reloadData()
                            self.segmentCon.enabled = true
                            if(self.comInfos.count > 0)
                            {
                                self.maxDateForCom = self.comInfos.first?.date
                                self.minDateForCom = self.comInfos.last?.date
                            }
                        }
                    }
            }
           }
        }
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "")
        {
            self.resInfos = self.msgInfos
            self.resComInfos = self.comInfos
        }
        else
        {
            if(self.segmentindex == 0)
            {
            self.resInfos = Array<MsgInfo>()
            for msgInfo in self.msgInfos
            {
                if(msgInfo.msg!.componentsSeparatedByString(searchText).count > 1)
                {
                    resInfos.append(msgInfo)
                }
            }
            }else{
                self.resComInfos = Array<CommentInfo>()
                for comInfo in self.comInfos
                {
                    if(comInfo.title!.componentsSeparatedByString(searchText).count > 1)
                    {
                        resComInfos.append(comInfo)
                    }
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
        var format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"

        if(self.segmentindex == 0)
        {
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
                var dateStr : String = format.stringFromDate(self.nowDate!)//如果上一次刷新时间为空赋值当前时间 不为空直接把上次刷新时间传给方法
                finalDate = dateStr
                actionStr = "pullDown"
                
                self.nowDate = NSDate()//记录当前刷新的时间 如果没数据 为下一次刷新提供上一次刷新时间
            }
            request(.GET, EndPoints.InBoxMsg.rawValue,parameters:["mobile":self.mobile!,"method":"getMsgByAction","actionStr" : actionStr!,"dateStr": finalDate!]).responseJSON{
                (request,response,data,error) in
                
                if let anError = error
                {
                    println(anError)
                }
                else if let dataList : NSArray = data! as? NSArray
                {
                    
                    for (var i = 0; i < dataList.count; i++)
                    {
                        let res = JSON(dataList[i])
                        
                        var msgData : MsgInfo = MsgInfo()
                        msgData.dateStr =  format.dateFromString(res["date"].string!)
                        msgData.msg = res["msg"].string
                        self.msgInfos.append(msgData)
                    }
                    self.msgInfos.sort({ (s1:MsgInfo, s2:MsgInfo) -> Bool in
                        s1.dateStr?.timeIntervalSinceReferenceDate >= s2.dateStr?.timeIntervalSinceReferenceDate
                    })
                    self.resInfos = self.msgInfos
                    self.tbData.reloadData()
                    self.tbData.footerEndRefreshing()
                    if(self.msgInfos.count > 0)
                    {
                        self.minDateForMsg = self.msgInfos.last?.dateStr
                    }
                }
            }
        }
        else//评论
        {
            
            minDate = self.minDateForCom
            if(minDate != nil)
            {
                actionStr = "pullUp"
                finalDate = format.stringFromDate(minDate!)
                
            }else
            {
                if(self.nowDateForCom == nil)
                {
                    self.nowDateForCom = NSDate()
                }
                var dateStr : String = format.stringFromDate(self.nowDateForCom!)//如果上一次刷新时间为空赋值当前时间 不为空直接把上次刷新时间传给方法
                finalDate = dateStr
                actionStr = "pullDown"
                
                self.nowDateForCom = NSDate()//记录当前刷新的时间 如果没数据 为下一次刷新提供上一次刷新时间
            }
            
            request(.GET, EndPoints.GetCommentHierarchy.rawValue,parameters:["mobile":self.mobile!,"method":"getComByAction","actionStr" : actionStr!,"dateStr": finalDate!]).responseJSON{
                (request,response,data,error) in
                
                if let anError = error
                {
                    println(anError)
                }
                else if let dataList : NSArray = data! as? NSArray
                {
                    
                    for (var i = 0; i < dataList.count; i++)
                    {
                        let item = JSON(dataList[i])
                        
                        var comInfo : CommentInfo = CommentInfo()
                        //comInfo
                        comInfo.id = (item["id"].string!).toInt()
                        comInfo.title = item["title"].string!
                        comInfo.imgUrl = item["avatar"].string!
                        comInfo.url = item["url"].string!
                        comInfo.date = format.dateFromString(item["date"].string!)
                        comInfo.proName = item["productname"].string!
                        comInfo.marketName = item["marketname"].string!
                        self.comInfos.append(comInfo)                    }
                    self.comInfos.sort({ (s1:CommentInfo, s2:CommentInfo) -> Bool in
                        s1.date?.timeIntervalSinceReferenceDate >= s2.date?.timeIntervalSinceReferenceDate
                    })
                    self.resComInfos = self.comInfos
                    self.tbData.reloadData()
                    self.tbData.footerEndRefreshing()
                    if(self.comInfos.count > 0)
                    {
                        self.minDateForCom = self.comInfos.last?.date
                    }
                }
            }
        }

    }
    //下拉加载更大日期
    func pullDownLoadDatas()
    {
        var maxDate : NSDate?
        var finalDate : String?
        var actionStr : String?
        var format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"
        
        if(self.segmentindex == 0)
        {
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
                var dateStr : String = format.stringFromDate(self.nowDate!)//如果上一次刷新时间为空赋值当前时间 不为空直接把上次刷新时间传给方法
                finalDate = dateStr
                actionStr = "pullDown"
                
                self.nowDate = NSDate()//记录当前刷新的时间 如果没数据 为下一次刷新提供上一次刷新时间
            }
            request(.GET, EndPoints.InBoxMsg.rawValue,parameters:["mobile":self.mobile!,"method":"getMsgByAction","actionStr" : actionStr!,"dateStr": finalDate!]).responseJSON{
                (request,response,data,error) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                if let anError = error
                {
                    self.isLoadOK = "NO"
                    println(anError)
                }
                else if let dataList : NSArray = data! as? NSArray
                {
                    
                    for (var i = 0; i < dataList.count; i++)
                    {
                        let res = JSON(dataList[i])
                        
                        var msgData : MsgInfo = MsgInfo()
                        msgData.dateStr =  format.dateFromString(res["date"].string!)
                        msgData.msg = res["msg"].string
                        self.msgInfos.append(msgData)
                    }
                    self.msgInfos.sort({ (s1:MsgInfo, s2:MsgInfo) -> Bool in
                        s1.dateStr?.timeIntervalSinceReferenceDate >= s2.dateStr?.timeIntervalSinceReferenceDate
                    })
                    self.resInfos = self.msgInfos
                    self.tbData.reloadData()
                    self.tbData.headerEndRefreshing()
                    self.isLoadOK = "YES"
                    self.segmentCon.enabled = true
                    if(self.msgInfos.count > 0)
                    {
                        self.maxDateForMsg = self.msgInfos.first?.dateStr
                    }
                }
            }
        }
        else//评论
        {
            
            maxDate = self.maxDateForCom
            
            if(maxDate != nil)
            {
                actionStr = "pullDown"
                finalDate = format.stringFromDate(maxDate!)
                
            }else
            {
                if(self.nowDateForCom == nil)
                {
                    self.nowDateForCom = NSDate()
                }
                var dateStr : String = format.stringFromDate(self.nowDateForCom!)//如果上一次刷新时间为空赋值当前时间 不为空直接把上次刷新时间传给方法
                finalDate = dateStr
                actionStr = "pullDown"
                
                self.nowDateForCom = NSDate()//记录当前刷新的时间 如果没数据 为下一次刷新提供上一次刷新时间
            }
            request(.GET, EndPoints.GetCommentHierarchy.rawValue,parameters:["mobile":self.mobile!,"method":"getComByAction","actionStr" : actionStr!,"dateStr": finalDate!]).responseJSON{
                (request,response,data,error) in
                 MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if let anError = error
                {
                    self.isLoadOK = "NO"
                    println(anError)
                }
                else if let dataList : NSArray = data! as? NSArray
                {
                    
                    for (var i = 0; i < dataList.count; i++)
                    {
                        let item = JSON(dataList[i])
                        
                        var comInfo : CommentInfo = CommentInfo()
                        //comInfo
                        comInfo.id = (item["id"].string!).toInt()
                        comInfo.title = item["title"].string!
                        comInfo.imgUrl = item["avatar"].string!
                        comInfo.url = item["url"].string!
                        comInfo.date = format.dateFromString(item["date"].string!)
                        comInfo.proName = item["productname"].string!
                        comInfo.marketName = item["marketname"].string!
                        self.comInfos.append(comInfo)                    }
                        self.comInfos.sort({ (s1:CommentInfo, s2:CommentInfo) -> Bool in
                        s1.date?.timeIntervalSinceReferenceDate >= s2.date?.timeIntervalSinceReferenceDate
                    })
                    self.resComInfos = self.comInfos
                    self.tbData.reloadData()
                    self.tbData.headerEndRefreshing()
                    self.isLoadOK = "YES"
                    self.segmentCon.enabled = true
                    if(self.comInfos.count > 0)
                    {
                        self.maxDateForCom = self.comInfos.first?.date
                    }
                }
            }
        }
        
        if self.isLoadOK == "YES"
        {
            //下拉成功 未读消息清零
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            self.tabBarItem.badgeValue = nil
            request(.GET,EndPoints.MessageInfo.rawValue,parameters:["mobile":self.mobile!,"method":"clearMessage"]).responseJSON{
                (request,response, data, error) in
                if let anError = error
                {
                    println(anError)
                }
                else if let res : AnyObject = data
                {
                    var result = JSON(res)
                    if(result["result"].string! == "ok")
                    {
                        println("清理成功")
                    }
                    else
                    {
                        println("清理失败")
                    }
                }
            }
        }

    }
    
    @IBAction func indexChange(sender: AnyObject) {
        self.segmentCon.enabled = false
        switch self.segmentCon.selectedSegmentIndex
        {
        case 0:
            self.segmentindex = 0
            if(self.maxDateForMsg != nil)
            {
//                self.resInfos = self.msgInfos
//                self.tbData.reloadData()
//                self.segmentCon.enabled = true
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                pullDownLoadDatas()
            }
            else
            {
                initLoadDatas()
                //pullDownLoadDatas()
            }
            //self.segmentCon.enabled = false
        case 1:
            self.segmentindex = 1
            if(self.maxDateForCom != nil)
            {
//                self.resComInfos = self.comInfos
//                self.tbData.reloadData()
//                self.segmentCon.enabled = true
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                pullDownLoadDatas()//来回切换选项卡应该是一个下拉加载新数据的动作
            }
            else
            {
                initLoadDatas()
                //pullDownLoadDatas()
            }
            //self.segmentCon.enabled = false
        default:
            break
        }
    }
    
    @IBAction func clearMsg(sender: AnyObject) {
        if(segmentindex == 0)
        {
            self.resInfos = []
            self.msgInfos = []
        }
        else
        {
            self.resComInfos = []
            self.comInfos = []
        }
            self.tbData.reloadData()        
    }
    
    
}

class MsgInfo : NSObject
{
    var msg : String?
    var dateStr : NSDate?
}

class CommentInfo : NSObject
{
    var id : Int?
    var date : NSDate?
    var title : String?
    var url : String?
    var imgUrl : String?
    var proName : String?
    var marketName : String?
}

extension UILabel{
    func initAutoHeight(rect:CGRect,textColor:UIColor, fontSize:CGFloat, text:NSString, lineSpacing:CGFloat){//自适应高度
    self.frame = rect
    self.textColor = textColor
    self.font = UIFont.systemFontOfSize(fontSize)
    self.lineBreakMode = NSLineBreakMode.ByWordWrapping
    self.numberOfLines = 0
    var attributedString = NSMutableAttributedString(string: text as String)
    var paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    paragraphStyle.lineBreakMode = NSLineBreakMode.ByCharWrapping
    attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, text.length))
    self.attributedText = attributedString
    self.sizeToFit()
    self.frame.size.width = rect.width
    self.frame.size.height = max(self.frame.size.height, rect.height)
    }
}

