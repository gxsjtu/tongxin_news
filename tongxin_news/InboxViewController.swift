import UIKit

class InboxViewController : UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate
{
    
    //@IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var searchCon: UISearchBar!
    @IBOutlet weak var navInbox: UINavigationBar!
    @IBOutlet weak var tbData: UITableView!
    
    var msgInfos : Array<MsgInfo> = []
    var resInfos : Array<MsgInfo> = []
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.lblMsg.lineBreakMode = NSLineBreakMode.ByWordWrapping
         initLoadDatas()
        //self.resInfos = self.msgInfos
        self.navInbox.setBackgroundImage(UIImage(named: "background"), forBarMetrics: UIBarMetrics.Default)
        self.tbData.dataSource = self
        self.tbData.delegate = self
        self.searchCon.delegate = self
        
    
        self.tbData.addHeaderWithCallback(pullDownLoadDatas)
        
        self.tbData.addFooterWithCallback(pullUpLoadDatas)
        tbData.headerRefreshingText = "正在刷新..."
        tbData.footerRefreshingText = "正在刷新..."
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return resInfos.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var msg : String = resInfos[indexPath.row].msg!
        var lb : UILabel!  = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 0))
        lb.initAutoHeight(lb.frame, textColor: UIColor.blackColor(), fontSize: 17, text: msg, lineSpacing: 1)
        return (lb.frame.height + 15)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var msg : String = resInfos[indexPath.row].msg!
        var lblMsg : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 0))
        lblMsg.lineBreakMode = NSLineBreakMode.ByWordWrapping
        lblMsg.numberOfLines = 0
        lblMsg.initAutoHeight(lblMsg.frame, textColor: UIColor.blackColor(), fontSize: 17, text: msg, lineSpacing: 1)
        let tbCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
//        (tbCell.viewWithTag(1) as! UILabel).initAutoHeight((tbCell.viewWithTag(1) as! UILabel).frame, textColor: UIColor.blackColor(), fontSize: 17, text: msg, lineSpacing: 1)
        
        tbCell.addSubview(lblMsg)
        (tbCell.viewWithTag(2) as! UILabel).text = format.stringFromDate(resInfos[indexPath.row].dateStr!)
        return tbCell
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
            var mobile : String? = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
            var format = NSDateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"
            
            request(.GET, EndPoints.InBoxMsg.rawValue,parameters:["mobile":mobile!,"method":"getInboxMsg"]).responseJSON{
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
                }
            }
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "")
        {
            self.resInfos = self.msgInfos
        }
        else
        {
            self.resInfos = Array<MsgInfo>()
            for msgInfo in self.msgInfos
            {
                if(msgInfo.msg!.lowercaseString.hasPrefix(searchText))
                {
                    resInfos.append(msgInfo)
                }
            }
        }
        self.tbData.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.tbData.reloadData()
    }
    
    
    //上拉加载更小日期
    func pullUpLoadDatas()
    {
        var minDate : NSDate?
        for info in resInfos
        {
            if(minDate == nil)
            {
                minDate = info.dateStr
            }
            else
            {
                if(minDate?.timeIntervalSinceReferenceDate >= info.dateStr?.timeIntervalSinceReferenceDate)
                {
                    minDate = info.dateStr
                }
            }
        }
        
        var mobile : String? = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
        var format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"
        
        request(.GET, EndPoints.InBoxMsg.rawValue,parameters:["mobile":mobile!,"method":"getMsgByAction","actionStr" : "pullUp","dateStr": format.stringFromDate(minDate!)]).responseJSON{
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
            }
            
        }

    }
    //下拉加载更大日期
    func pullDownLoadDatas()
    {
        var maxDate : NSDate?
        for info in resInfos
        {
            if(maxDate == nil)
            {
                maxDate = info.dateStr
            }
            else
            {
                if(maxDate?.timeIntervalSinceReferenceDate <= info.dateStr?.timeIntervalSinceReferenceDate)
                {
                    maxDate = info.dateStr
                }
            }
        }
        var mobile : String? = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
        var format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"
        
        request(.GET, EndPoints.InBoxMsg.rawValue,parameters:["mobile":mobile!,"method":"getMsgByAction","actionStr" : "pullDown","dateStr": format.stringFromDate(maxDate!)]).responseJSON{
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
                self.tbData.headerEndRefreshing()
            }

        }
    }
    

}

class MsgInfo : NSObject
{
    var msg : String?
    var dateStr : NSDate?
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

