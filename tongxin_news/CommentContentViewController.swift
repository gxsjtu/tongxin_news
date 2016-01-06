//
//  CommentContentViewController.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/27.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

class CommentContentViewController: UIViewController, UIWebViewDelegate {
    
    @IBAction func menuClicked(sender: AnyObject) {
        
        let moments = KxMenuItem()
        moments.title = "分享到朋友圈"
        moments.action = Selector("Share2Others:")
        moments.target = self
        moments.image = UIImage(named: "moments")
        
        let friends = KxMenuItem()
        friends.title = "分享给微信好友"
        friends.action = Selector("Share2Others:")
        friends.target = self
        friends.image = UIImage(named: "friends")
        
        let refresh = KxMenuItem()
        refresh.title = "刷新"
        refresh.action = Selector("Share2Others:")
        refresh.target = self
        refresh.image = UIImage(named: "refresh")
        
        KxMenu.setTintColor(UIColor(red: 35/255, green: 191/255, blue: 242/255, alpha: 1))
        KxMenu.showMenuInView(self.view, fromRect: ((sender as! UIBarButtonItem).valueForKey("view")?.frame)!, menuItems: [moments, friends, refresh])
        
    }
    
    func Share2Others(id: AnyObject)
    {
        let message = WXMediaMessage()
        message.title = self.wxTitle
        if self.thumbnail != nil
        {
            message.setThumbImage(self.thumbnail)
        }
        else
        {
            message.setThumbImage(UIImage(named: "同鑫评论"))
        }
        
        let page = WXWebpageObject()
        page.webpageUrl = self.url
        message.mediaObject = page
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message

        if id.title == "分享到朋友圈"
        {
            req.scene = Int32(WXSceneTimeline.rawValue)
            WXApi.sendReq(req)
        }
        else if id.title == "分享给微信好友"
        {
            req.scene = Int32(WXSceneSession.rawValue)
            WXApi.sendReq(req)
        }
        else if id.title == "刷新"
        {
            self.wvCommentContent.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        }
    }
    
    
    var navTitle = "未知"
    var url = "http://app.shtx.com.cn/statichtml/404.html"
    var thumbnail: UIImage?
    var wxTitle = ""

    @IBOutlet weak var wvCommentContent: UIWebView!
    @IBOutlet weak var navCommentContent: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.wvCommentContent.delegate = self
        self.navCommentContent.topItem?.title = navTitle
        self.wvCommentContent.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        MBProgressHUD.showHUDAddedTo(self.wvCommentContent, animated: true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        MBProgressHUD.hideHUDForView(self.wvCommentContent, animated: true)
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
