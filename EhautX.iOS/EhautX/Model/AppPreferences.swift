//
//  AppPreferences.swift
//  EhautTeam
//
//  Created by zh on 2019/5/26.
//  Copyright © 2019 ehaut. All rights reserved.
//

import Alamofire
import Foundation

struct OnlineInfo {
    static var networkIsConnect: Bool = false
    static var isOnline: Bool = false
    static var onlineIp: String = ""
    static var onlineUsername: String = ""
    static var usedData: String = ""
    static var usedTime: Int = 0
    static var serverTime: Int = 0
    static var loginTime: Int = 0
}

struct ServerInfo {
    // 服务器地址示范http://172.16.154.130，请不要忘了http://头以及没有最后/符号
    static var authServerAddr: String = "http://172.16.154.130"
    static var authServerPort: String = "69"
    static var serviceServerAddr: String = "http://172.16.154.130"
    static var serviceServerPort: String = "8800"
    static var macAddr: String = ""
    static var acid: String = "1"
    static var type: String = "3"
    static var drop: String = "0"
    static var pop: String = "1"
    static var key: String = "1234567890"
}

struct TestServerInfo {
    // fake cgi server
    static var testServerAddr: String = "https://cgi.ehaut.cn"
    static var testModeAddr: String = "https://cgi.ehaut.cn/testmode"
    // static var environmentalFile:String = "https://cgi.ehaut.cn/env.json"
    // 不要编辑以下部分
    static var testServerStatus: Int = -1
    static var authServerStatus: Int = -1
    static var isTestModeOn = true
    static var isCgiBroken = false
    static var isNetworkConnect = false
}

struct networkSet {
    static let Manager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // 超时设置
        return Alamofire.SessionManager(configuration: configuration)
    }()

    static var testServerAddr: String = TestServerInfo.testServerAddr
    // static let testNetworkManger = Alamofire.NetworkReachabilityManager(host: testServerAddr)
    static var authServerAddr: String = ServerInfo.authServerAddr
    // static let authNetworkManger = Alamofire.NetworkReachabilityManager(host: authServerAddr)
}

struct UserInfo {
    static var username: String = ""
    static var password: String = ""
}

struct postResult {
    static var networkIsConnect: Bool = false
    static var result: String = ""
    static var isLoginOK: Bool = false
    static var isLogoutOK: Bool = false
    static var isAcidError: Bool = false
    static var isNotOnline: Bool = false
}
