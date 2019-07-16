//
//  Network.swift
//  E-HAUT
//
//  Created by zh on 2019/5/26.
//  Copyright © 2019 ehaut. All rights reserved.
//

import Foundation
import Alamofire

class Network
{
    
    static func isNetworkReachability() {
        
        networkSet.testNetworkManger?.listener = { status in
            if networkSet.testNetworkManger?.isReachable ?? false {
                switch status{
                case .notReachable:
                    print("无法连接模拟认证服务器")
                    TestServerInfo.testServerStatus = -1
                    break
                case .unknown:
                    print("无法确定连接模拟认证服务器的状态")
                    TestServerInfo.testServerStatus = -1
                    break
                case .reachable(.ethernetOrWiFi):
                    print("通过WiFi连接模拟认证服务服务器成功")
                    TestServerInfo.testServerStatus = 0
                    break
                case .reachable(.wwan):
                    print("通过移动网络连接模拟认证服务器成功")
                    TestServerInfo.testServerStatus = 1
                    break
                }
            } else {
                print("无法连接模拟认证服务器")
                TestServerInfo.testServerStatus = -1
            }
        }
        networkSet.authNetworkManger?.listener = { status in
            if networkSet.authNetworkManger?.isReachable ?? false {
                switch status{
                case .notReachable:
                    print("无法连接认证服务器")
                    TestServerInfo.authServerStatus = -1
                    break
                case .unknown:
                    print("无法确定连接认证服务器的状态")
                    TestServerInfo.authServerStatus = -1
                    break
                case .reachable(.ethernetOrWiFi):
                    print("通过WiFi连接认证服务服务器成功")
                    TestServerInfo.authServerStatus = 0
                    break
                case .reachable(.wwan):
                    //应该没有这种情况。
                    print("通过移动网络连接认证服务器成功")
                    TestServerInfo.authServerStatus = 1
                    break
                }
            } else {
                print("无法连接认证服务器")
                TestServerInfo.authServerStatus = -1
            }
        }
    }
    
    static func getUserStatus(method: @escaping () -> ()) {
        //var networkIsConnect = false
        let serverAddress = ServerInfo.authServerAddr //+ ":" + ServerInfo.authServerPort
        let url = serverAddress + "/cgi-bin/rad_user_info"
        let queue = DispatchQueue(label: "cn.ehut.response-queue", qos: .default, attributes: [.concurrent])
        networkSet.Manager.request(url).responseString(
            queue:queue,
            completionHandler: { response in
                switch(response.result) {
                    case .success(let get):
                        print(get)
                        OnlineInfo.networkIsConnect = true
                        if(get.contains("not_online") || get.contains("not_online_error")) {
                            OnlineInfo.isOnline = false
                        } else {
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
    
    
    static func getTestMode(method: @escaping () -> ()) {
        let url = TestServerInfo.environmentalFile
        let queue = DispatchQueue(label: "cn.ehut.response-queue", qos: .default, attributes: [.concurrent])
        networkSet.Manager.request(url).responseString(
            queue:queue,
            completionHandler: { response in
                    switch(response.result) {
                    case .success(let get):
                        print(get)
                    case .failure(let error):
                        //OnlineInfo.networkIsConnect = false
                        print(error)
                    DispatchQueue.main.async {
                        method()
                    }
                }
            }
        )
    }
    
    static func login(method: @escaping () -> ()) {
        let serverAddress = ServerInfo.authServerAddr + ":" + ServerInfo.authServerPort
        let url = serverAddress + "/cgi-bin/srun_portal"
        let queue = DispatchQueue(label: "cn.ehut.response-queue", qos: .default, attributes: [.concurrent])
        let parameters: Parameters = [
            "action":"login",
            "username":Crypto.usernameEncrypt(username: UserInfo.username),
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
        networkSet.Manager.request(url,method:.post,parameters: parameters,encoding: URLEncoding.queryString).responseString(
            queue:queue,
            completionHandler: { response in
                switch(response.result) {
                case .success(let get):
                    print(get)
                    postResult.result = get
                    postResult.networkIsConnect = true
                    if(get.contains("login_ok")) {
                        postResult.isLoginOK = true
                    } else {
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
        let serverAddress = ServerInfo.authServerAddr + ":" + ServerInfo.authServerPort
        let url = serverAddress + "/cgi-bin/srun_portal"
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
                    if(get.contains("logout_ok")) {
                        postResult.isLogoutOK = true
                    } else {
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
