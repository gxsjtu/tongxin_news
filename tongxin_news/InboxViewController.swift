import UIKit

class InboxViewController : UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate
{
    
    @IBOutlet weak var searchCon: UISearchBar!
    
    @IBOutlet weak var tbData: UITableView!
    
    var msgInfos : Array<MsgInfo> = []
    var resInfos : Array<MsgInfo> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         initLoadDatas()
        //self.resInfos = self.msgInfos
        
        self.tbData.dataSource = self
        self.tbData.delegate = self
        self.searchCon.delegate = self
        
    
        self.tbData.addHeaderWithCallback(pullDownLoadDatas)
        
        self.tbData.addFooterWithCallback(pullUpLoadDatas)
        tbData.headerRefreshingText = "正在刷新..."
        tbData.footerRefreshingText = "正在刷新..."
//        self.tbData.addHeaderWithTarget(self, action: "pullDownLoadDatas")
//        self.tbData.addFooterWithTarget(self, action: "pullUpLoadDatas")
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
        return 25
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let tbCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        (tbCell.viewWithTag(1) as! UILabel).text = resInfos[indexPath.row].msg
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