//
//  EndPoints.swift
//  Tip
//
//  Created by 郭轩 on 15/8/11.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import Foundation

enum EndPoints: String
{
    case SignIn = "http://api.shtx.com.cn/Handlers/LoginHandler.ashx"
    case UserSet = "http://api.shtx.com.cn/Handlers/UserInfoHandler.ashx"
    case InBoxMsg = "http://api.shtx.com.cn/Handlers/InboxMsgHandler.ashx"
    case GetProductHierarchy = "http://api.shtx.com.cn/Handlers/XHMarketHandler.ashx"
    case GetPrices = "http://api.shtx.com.cn/Handlers/PriceHandler.ashx"
    case GetCommentHierarchy = "http://api.shtx.com.cn/Handlers/PLHandler.ashx"
    case MessageInfo = "http://api.shtx.com.cn/Handlers/MessageHandler.ashx"
    case Channel = "http://api.shtx.com.cn/Handlers/ChannelHandler.ashx"
    case SPList = "http://api.shtx.com.cn/Handlers/SupplyHandler.ashx"
    case OrderProduct = "http://api.shtx.com.cn/Handlers/orderHandler.ashx"
    case Register = "http://api.shtx.com.cn/Handlers/CustomerHandler.ashx"
    case GetSearchPrices = "http://172.20.68.162:3838/Handlers/SearchHandler.ashx"
}
