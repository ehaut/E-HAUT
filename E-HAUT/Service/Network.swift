//
//  Network.swift
//  E-HAUT
//
//  Created by zh on 2019/5/26.
//  Copyright © 2019 ehaut. All rights reserved.
//

import Foundation
import Alamofire
//import SwiftyJSON

class Network
{
    
//    static func checkServerStatus() -> Bool {
//        var signal:Bool = false;
//        networkSet.testNetworkManger?.listener = { status in
//            if networkSet.testNetworkManger?.isReachable ?? false {
//                switch status{
//                case .notReachable:
//                    print("无法连接模拟认证服务器")
//                    TestServerInfo.testServerStatus = -1
//                    signal = true
//                    break
//                case .unknown:
//                    print("无法确定连接模拟认证服务器的状态")
//                    TestServerInfo.testServerStatus = -1
//                    signal = true
//                    break
//                case .reachable(.ethernetOrWiFi):
//                    print("通过WiFi连接模拟认证服务服务器成功")
//                    TestServerInfo.testServerStatus = 0
//                    Network.getTestMode() {}
//                    signal = true
//                    break
//                case .reachable(.wwan):
//                    print("通过移动网络连接模拟认证服务器成功")
//                    TestServerInfo.testServerStatus = 1
//                    signal = true
//                    //Network.getTestMode() {}
//                    break
//                }
//            }
//        }
//        networkSet.authNetworkManger?.listener = { status in
//            if networkSet.authNetworkManger?.isReachable ?? false {
//                switch status{
//                case .notReachable:
//                    print("无法连接认证服务器")
//                    TestServerInfo.authServerStatus = -1
//                    signal = true
//                    break
//                case .unknown:
//                    print("无法确定连接认证服务器的状态")
//                    TestServerInfo.authServerStatus = -1
//                    signal = true
//                    break
//                case .reachable(.ethernetOrWiFi):
//                    print("通过WiFi连接认证服务服务器成功")
//                    TestServerInfo.authServerStatus = 0
//                    signal = true
//                    break
//                case .reachable(.wwan):
//                    //应该没有这种情况。
//                    print("通过移动网络连接认证服务器成功")
//                    TestServerInfo.authServerStatus = 1
//                    signal = true
//                    break
//                }
//            }
//        }
//        networkSet.testNetworkManger?.startListening()
//        networkSet.authNetworkManger?.startListening()
//        return signal;
//    }
    
    
    static func getUserStatus(method: @escaping () -> ()) {
        //var networkIsConnect = false
        var serverAddress:String =  ""
        var url:String = ""
        if(TestServerInfo.isTestModeOn==false) {
            serverAddress = ServerInfo.authServerAddr //+ ":" + ServerInfo.authServerPort
            url = serverAddress + "/cgi-bin/rad_user_info"
        }
        else {
            serverAddress = TestServerInfo.testServerAddr
            url =  serverAddress + "/cgi-bin/rad_user_info"
        }
        let queue = DispatchQueue(label: "cn.ehut.response-queue", qos: .default, attributes: [.concurrent])
        networkSet.Manager.request(url).responseString(
            queue:queue,
            completionHandler: { response in
                switch(response.result) {
                    case .success(let get):
                        print(get)
                        OnlineInfo.networkIsConnect = true
                        if(get.contains("502 Bad Gateway")) {
                            print("cgi is broken")
                            TestServerInfo.isCgiBroken = true
                        } else if(get.contains("not_online") || get.contains("not_online_error")) {
                            TestServerInfo.isCgiBroken = false
                            OnlineInfo.isOnline = false
                        } else {
                            TestServerInfo.isCgiBroken = false
                            OnlineInfo.isOnline = true
                            let list = get.components(separatedBy: ",")
                            OnlineInfo.loginTime = Int(list[1])!
                            OnlineInfo.onlineIp = list[8]
                            OnlineInfo.onlineUsername = list[0]
                            let d = Double(list[6])!
                            if( d > (1024*1024) ) {
                                let data:Double = d / (1024*1024)
                                OnlineInfo.usedData = data.format(".4") + " MB"
                            } else if ( d > 1024 ) {
                                let data:Double = d / 1024
                                OnlineInfo.usedData = data.format(".4") + " KB"
                            } else {
                                OnlineInfo.usedData = String(d) + " B"
                            }
                            OnlineInfo.serverTime = Int(list[2])!
                            let t = Int(list[7])!
                            OnlineInfo.usedTime = (t + OnlineInfo.serverTime - OnlineInfo.loginTime)
                            
                        }
                    case .failure(let error):
                        OnlineInfo.networkIsConnect = false
                        print(error)
                }
                DispatchQueue.main.async {
                    method()
                }
            }
        )
    }
    
    
//    static func getTestMode(method: @escaping () -> ()) {
//        let url = TestServerInfo.environmentalFile
//        let queue = DispatchQueue(label: "cn.ehut.response-queue", qos: .default, attributes: [.concurrent])
//        networkSet.Manager.request(url).responseJSON(
//            queue:queue,
//            completionHandler: { response in
//                    switch(response.result) {
//                    case .success:
//                        print(response.result)
//                        if let json = response.result.value as? [String: String] {
//                            let value = json["testMode"] ?? "on"
//                            print(value)
//                            if(value.contains("on")) {
//                                print("测试模式开启")
//                                TestServerInfo.isTestModeOn = true
//                            } else if(value.contains("off")) {
//                                print("测试模式关闭")
//                                TestServerInfo.isTestModeOn = false
//                            }
//                        }
////                        print("Success with JSON: \(JSON)")
////                        let response = JSON as! NSDictionary
////                        print(response.object(forKey: "testMode") as Any)
////                        let value:String = response.object(forKey: "testMode") as! String
////                            if(value.contains("on")) {
////                                print("测试模式开启")
////                                TestServerInfo.isTestModeOn = true
////                            } else if(value.contains("off")) {
////                                print("测试模式关闭")
////                                TestServerInfo.isTestModeOn = false
////                            }
//                    case .failure(let error):
//                        //OnlineInfo.networkIsConnect = false
//                        print(error)
//                    DispatchQueue.main.async {
//                        method()
//                    }
//                }
//            }
//        )
//    }
    
    
    static func getTestMode(method: @escaping () -> ()) {
        let url = TestServerInfo.testModeAddr
        let queue = DispatchQueue(label: "cn.ehut.response-queue", qos: .default, attributes: [.concurrent])
        networkSet.Manager.request(url).responseString(
            queue:queue,
            completionHandler: { response in
                switch(response.result) {
                case .success(let get):
                    print(get)
                    TestServerInfo.isNetworkConnect = true
                    OnlineInfo.networkIsConnect = true
                    if( get.contains("off") || get.contains("502 Bad Gateway")) {
                        print("测试模式关闭")
                        TestServerInfo.isTestModeOn = false
                    } else {
                        print("测试模式开启")
                        TestServerInfo.isTestModeOn = true
                    }
                case .failure(let error):
                    TestServerInfo.isNetworkConnect = false
                    TestServerInfo.isTestModeOn = false
                    print(error)
                }
                DispatchQueue.main.async {
                    method()
                }
            }
        )
    }
    
    
    static func login(method: @escaping () -> ()) {
        var serverAddress:String =  ""
        var url:String = ""
        if(TestServerInfo.isTestModeOn==false) {
            serverAddress = ServerInfo.authServerAddr //+ ":" + ServerInfo.authServerPort
            url = serverAddress + "/cgi-bin/srun_portal"
        }
        else {
            serverAddress = TestServerInfo.testServerAddr
            url =  serverAddress + "/cgi-bin/srun_portal"
        }
        let queue = DispatchQueue(label: "cn.ehut.response-queue", qos: .default, attributes: [.concurrent])
        var username:String=""
        if(TestServerInfo.isTestModeOn==true) {
            username=UserInfo.username
        } else {
            username=Crypto.usernameEncrypt(username: UserInfo.username)
        }
        let parameters: Parameters = [
            "action":"login",
            "username":username,
            "password":Crypto.passwordEncrypt(password: UserInfo.password, passwordKey:ServerInfo.key),
            "mac":ServerInfo.macAddr,
            "ac_id":ServerInfo.acid,
            "type":ServerInfo.type,
            "n":"117",
            "pop":ServerInfo.pop,
            "drop":ServerInfo.drop,
            "mbytes":"0",
            "minutes":"0"
        ]
        print("url",url)
        networkSet.Manager.request(url,method:.post,parameters: parameters,encoding: URLEncoding.queryString).responseString(
            queue:queue,
            completionHandler: { response in
                switch(response.result) {
                case .success(let get):
                    print(get)
                    postResult.result = get
                    postResult.networkIsConnect = true
                    if(get.contains("502 Bad Gateway")) {
                        print("cgi is broken")
                        TestServerInfo.isCgiBroken = true
                    } else if(get.contains("login_ok")) {
                        TestServerInfo.isCgiBroken = false
                        postResult.isLoginOK = true
                    } else {
                        TestServerInfo.isCgiBroken = false
                        postResult.isLoginOK = false
                        if(get.contains("login_error#INFO failed, BAS respond timeout.")) {
                            postResult.isAcidError = true
                        }
                    }
                case .failure(let error):
                    postResult.networkIsConnect = false
                    print(error)
                }
                DispatchQueue.main.async {
                    method()
                }
            }
        )
    }
    static func logout(method: @escaping () -> ()) {
        var serverAddress:String =  ""
        var url:String = ""
        if(TestServerInfo.isTestModeOn==false) {
            serverAddress = ServerInfo.authServerAddr //+ ":" + ServerInfo.authServerPort
            url = serverAddress + "/cgi-bin/srun_portal"
        }
        else {
            serverAddress = TestServerInfo.testServerAddr
            url =  serverAddress + "/cgi-bin/srun_portal"
        }
        let queue = DispatchQueue(label: "cn.ehut.response-queue", qos: .default, attributes: [.concurrent])
        let parameters: Parameters = [
            "action":"logout",
            "username":Crypto.usernameEncrypt(username: OnlineInfo.onlineUsername),
            "mac":ServerInfo.macAddr,
            "ac_id":ServerInfo.acid,
            "type":ServerInfo.type,
            "n":"117",
            "pop":ServerInfo.pop,
            "drop":ServerInfo.drop,
            "mbytes":"0",
            "minutes":"0"
        ]
        networkSet.Manager.request(url,method:.post,parameters: parameters,encoding: URLEncoding.queryString).responseString(
            queue:queue,
            completionHandler: { response in
                switch(response.result) {
                case .success(let get):
                    print(get)
                    postResult.result = get
                    postResult.networkIsConnect = true
                    if(get.contains("502 Bad Gateway")) {
                        print("cgi is broken")
                        TestServerInfo.isCgiBroken = true
                    } else if(get.contains("logout_ok")) {
                        TestServerInfo.isCgiBroken = false
                        postResult.isLogoutOK = true
                    } else {
                        TestServerInfo.isCgiBroken = false
                        postResult.isLogoutOK = false
                        if(get.contains("You are not online.")) {
                            postResult.isNotOnline = true
                        }
                    }
                case .failure(let error):
                    postResult.networkIsConnect = false
                    print(error)
                }
                DispatchQueue.main.async {
                    method()
                }
            }
        )
    }
}


extension Double {
    //取小数点后几位
    public func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
