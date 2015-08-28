import UIKit

class InboxViewController : UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate
{
    
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
            var lb : UILabel!  = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 0))
            lb.initAutoHeight(lb.frame, textColor: UIColor.blackColor(), fontSize: 17, text: msg, lineSpacing: 1)
            var lbDate : UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 0))
            lbDate.initAutoHeight(lbDate.frame, textColor: UIColor.yellowColor(), fontSize: 10, text: date, lineSpacing: 1)
            return (lb.frame.height + lbDate.frame.height + 25)
        }
        else
        {
            return 60
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tbCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        var format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if(tbCell.viewWithTag(1) != nil){
            tbCell.viewWithTag(1)?.removeFromSuperview()
        }
        if(tbCell.viewWithTag(2) != nil){
            tbCell.viewWithTag(2)?.removeFromSuperview()
        }
        if(tbCell.viewWithTag(3) != nil){
            tbCell.viewWithTag(3)?.removeFromSuperview()
        }
        if(tbCell.viewWithTag(4) != nil){
            tbCell.viewWithTag(4)?.removeFromSuperview()
        }
        if(self.segmentindex == 0)
        {
           
            var msg : String = resInfos[indexPath.row].msg!
            var date : String = format.stringFromDate(resInfos[indexPath.row].dateStr!)

            
            var lblMsg : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 0))
            lblMsg.tag = 1
            lblMsg.lineBreakMode = NSLineBreakMode.ByWordWrapping
            lblMsg.numberOfLines = 0
            lblMsg.initAutoHeight(lblMsg.frame, textColor: UIColor.blackColor(), fontSize: 17, text: msg, lineSpacing: 1)
            tbCell.addSubview(lblMsg)
            var lblDate : UILabel = UILabel(frame: CGRect(x: 0, y: lblMsg.frame.size.height + 10, width: 320, height: 0))
            lblDate.tag = 2
            lblDate.lineBreakMode = NSLineBreakMode.ByWordWrapping
            lblDate.numberOfLines = 0
            lblDate.initAutoHeight(lblDate.frame, textColor: UIColor.orangeColor(), fontSize: 14, text: date, lineSpacing: 1)
            tbCell.addSubview(lblDate)
            

        }
        else
        {
            var logoImg : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            logoImg.hnk_setImageFromURL(NSURL(string: self.resComInfos[indexPath.row].imgUrl!))
            logoImg.tag = 1
            tbCell.addSubview(logoImg)
            var lblTitle : UILabel = UILabel(frame: CGRect(x: (logoImg.frame.size.width+5), y: 0,width: 210,height: 40))
           lblTitle.tag = 2
            lblTitle.text = self.resComInfos[indexPath.row].title!
            lblTitle.font = UIFont.systemFontOfSize(16)
            tbCell.addSubview(lblTitle)
            var lblDate : UILabel = UILabel(frame: CGRect(x: (logoImg.frame.size.width + 5), y: (lblTitle.frame.size.height), width: 210, height: 20))
            lblDate.textColor = UIColor.orangeColor()
            lblDate.font = UIFont.systemFontOfSize(14)
            lblDate.tag = 3
            lblDate.text = format.stringFromDate(self.resComInfos[indexPath.row].date!)
            tbCell.addSubview(lblDate)
        }
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

           if(self.segmentindex == 0)
           {
            request(.GET, EndPoints.InBoxMsg.rawValue,parameters:["mobile":"15802161396","method":"getInboxMsg"]).responseJSON{
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
                    self.segmentCon.enabled = true
                }
            }

            }
            else//评论
           {
            request(.GET, EndPoints.GetCommentHierarchy.rawValue, parameters: ["method": "getCommentByMobile", "mobile": "15802161396"])
                .responseJSON { (request, response, data, error) in

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
                                self.comInfos.append(comInfo)
                            }
                            self.comInfos.sort({ (c1 : CommentInfo, c2 : CommentInfo) -> Bool in
                                c1.date?.timeIntervalSinceReferenceDate >= c2.date?.timeIntervalSinceReferenceDate
                            })
                            self.resComInfos = self.comInfos
                            self.tbData.reloadData()
                            self.segmentCon.enabled = true
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
       //self.tbData.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.tbData.reloadData()
    }
    
    
    //上拉加载更小日期
    func pullUpLoadDatas()
    {
        var minDate : NSDate?
        var mobile : String? = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
        var format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"

        if(self.segmentindex == 0)
        {
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
        
            if(minDate != nil)
            {
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
            
            }else
            {
                self.tbData.footerEndRefreshing()
            }
        }
        else
        {
            for comInfo in resComInfos
            {
                if(minDate == nil)
                {
                    minDate = comInfo.date
                }
                else
                {
                    if(minDate?.timeIntervalSinceReferenceDate >= comInfo.date?.timeIntervalSinceReferenceDate)
                    {
                        minDate = comInfo.date
                    }
                }
            }
            
            if(minDate != nil)
            {
            request(.GET, EndPoints.GetCommentHierarchy.rawValue,parameters:["mobile":mobile!,"method":"getComByAction","actionStr" : "pullUp","dateStr": format.stringFromDate(minDate!)]).responseJSON{
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
                        self.comInfos.append(comInfo)                    }
                    self.comInfos.sort({ (s1:CommentInfo, s2:CommentInfo) -> Bool in
                        s1.date?.timeIntervalSinceReferenceDate >= s2.date?.timeIntervalSinceReferenceDate
                    })
                    self.resComInfos = self.comInfos
                    self.tbData.reloadData()
                    self.tbData.footerEndRefreshing()
                }
            }
            }else{
                self.tbData.footerEndRefreshing()
            }
        }

    }
    //下拉加载更大日期
    func pullDownLoadDatas()
    {
        var maxDate : NSDate?
        var mobile : String? = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
        var format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"
        
        if(self.segmentindex == 0)
        {
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
        
        if(maxDate != nil)
        {
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
            else
        {
                self.tbData.headerEndRefreshing()
            }
        }
        else
        {
            for comInfo in resComInfos
            {
                if(maxDate == nil)
                {
                    maxDate = comInfo.date
                }
                else
                {
                    if(maxDate?.timeIntervalSinceReferenceDate <= comInfo.date?.timeIntervalSinceReferenceDate)
                    {
                        maxDate = comInfo.date
                    }
                }
            }
            
            if(maxDate != nil)
            {
            request(.GET, EndPoints.GetCommentHierarchy.rawValue,parameters:["mobile":mobile!,"method":"getComByAction","actionStr" : "pullDown","dateStr": format.stringFromDate(maxDate!)]).responseJSON{
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
                        self.comInfos.append(comInfo)                    }
                        self.comInfos.sort({ (s1:CommentInfo, s2:CommentInfo) -> Bool in
                        s1.date?.timeIntervalSinceReferenceDate >= s2.date?.timeIntervalSinceReferenceDate
                    })
                    self.resComInfos = self.comInfos
                    self.tbData.reloadData()
                    self.tbData.headerEndRefreshing()
                }
            }
            }
            else
            {
                self.tbData.headerEndRefreshing()
            }
        }
    }
    
    @IBAction func indexChange(sender: AnyObject) {
        self.segmentCon.enabled = false
        switch self.segmentCon.selectedSegmentIndex
        {
        case 0:
            self.segmentindex = 0
            if(self.msgInfos.count > 0)
            {
                self.resInfos = self.msgInfos
                self.tbData.reloadData()
                self.segmentCon.enabled = true
            }
            else
            {
                initLoadDatas()
            }
            //self.segmentCon.enabled = false
        case 1:
            self.segmentindex = 1
            if(self.comInfos.count > 0)
            {
                self.resComInfos = self.comInfos
                self.tbData.reloadData()
                self.segmentCon.enabled = true
            }
            else
            {
                initLoadDatas()
            }
            //self.segmentCon.enabled = false
        default:
            break
        }
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

