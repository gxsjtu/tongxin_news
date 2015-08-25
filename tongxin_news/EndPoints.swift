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
    case SignIn = "http://172.20.68.245:8077/Handlers/LoginHandler.ashx"
    case UserSet = "http://172.20.68.245:8077/Handlers/UserInfoHandler.ashx"
    case GetProductHierarchy = "http://172.20.68.245:8077/Handlers/XHMarketHandler.ashx"
    case GetPrices = "http://172.20.68.245:8077/Handlers/PriceHandler.ashx"
}
