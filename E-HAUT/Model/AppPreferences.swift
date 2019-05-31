//
//  AppPreferences.swift
//  E-HAUT
//
//  Created by zh on 2019/5/26.
//  Copyright © 2019 ehaut. All rights reserved.
//

import Foundation
import Alamofire

struct OnlineInfo {
    static var networkIsConnect:Bool = false
    static var isOnline:Bool = false
    static var onlineIp:String = ""
    static var onlineUsername:String = ""
    static var usedData:String = ""
    static var usedTime:Int = 0
    static var serverTime:Int = 0
    static var loginTime:Int = 0
}

struct ServerInfo {
    //服务器地址示范http://172.16.154.130，请不要忘了http://头以及没有最后/符号
    static var authServerAddr:String = "http://172.16.154.130"
    static var authServerPort:String = "69"
    static var serviceServerAddr:String = "http://172.16.154.130"
    static var serviceServerPort:String = "8800"
    static var macAddr:String = ""
    static var acid:String = "1"
    static var type:String = "3"
    static var drop:String = "0"
    static var pop:String = "1"
    static var key:String = "1234567890"
}

struct networkSet {
    static let Manager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 3 //超时设置
        return Alamofire.Session(configuration: configuration)
    }()
}

struct UserInfo {
    static var username:String = ""
    static var password:String = ""
}


struct pageInfo {
    static var isJump:Bool = false
    static var isAutoJump:Bool = false
}

struct postResult {
    static var networkIsConnect:Bool = false
    static var result:String = ""
    static var isLoginOK:Bool = false
    static var isLogoutOK:Bool = false
    static var isAcidError:Bool = false
}
