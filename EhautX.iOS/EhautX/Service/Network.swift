//
//  Network.swift
//  EhautTeam
//
//  Created by zh on 2019/5/26.
//  Copyright © 2019 ehaut. All rights reserved.
//

import Alamofire
import Foundation

class Network {
    static func getUserStatus(method: @escaping () -> Void) {
        // var networkIsConnect = false
        var serverAddress: String = ""
        var url: String = ""
        if TestServerInfo.isTestModeOn == false {
            serverAddress = ServerInfo.authServerAddr // + ":" + ServerInfo.authServerPort
            url = serverAddress + "/cgi-bin/rad_user_info"
        } else {
            serverAddress = TestServerInfo.testServerAddr
            url = serverAddress + "/cgi-bin/rad_user_info"
        }
        let queue = DispatchQueue(label: "cn.ehut.response-queue", qos: .default, attributes: [.concurrent])
        networkSet.Manager.request(url).responseString(
            queue: queue,
            completionHandler: { response in
                switch response.result {
                case let .success(get):
                    print(get)
                    OnlineInfo.networkIsConnect = true
                    if get.contains("502 Bad Gateway") {
                        print("cgi is broken")
                        TestServerInfo.isCgiBroken = true
                    } else if get.contains("not_online") || get.contains("not_online_error") {
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
                        if d > (1024 * 1024) {
                            let data: Double = d / (1024 * 1024)
                            OnlineInfo.usedData = data.format(".4") + " MB"
                        } else if d > 1024 {
                            let data: Double = d / 1024
                            OnlineInfo.usedData = data.format(".4") + " KB"
                        } else {
                            OnlineInfo.usedData = String(d) + " B"
                        }
                        OnlineInfo.serverTime = Int(list[2])!
                        let t = Int(list[7])!
                        OnlineInfo.usedTime = (t + OnlineInfo.serverTime - OnlineInfo.loginTime)
                    }
                case let .failure(error):
                    OnlineInfo.networkIsConnect = false
                    print(error)
                }
                DispatchQueue.main.async {
                    method()
                }
            }
        )
    }

    static func getTestMode(method: @escaping () -> Void) {
        let url = TestServerInfo.testModeAddr
        let queue = DispatchQueue(label: "cn.ehut.response-queue", qos: .default, attributes: [.concurrent])
        networkSet.Manager.request(url).responseString(
            queue: queue,
            completionHandler: { response in
                switch response.result {
                case let .success(get):
                    print(get)
                    TestServerInfo.isNetworkConnect = true
                    OnlineInfo.networkIsConnect = true
                    if get.contains("off") || get.contains("502 Bad Gateway") {
                        print("测试模式关闭")
                        TestServerInfo.isTestModeOn = false
                    } else {
                        print("测试模式开启")
                        TestServerInfo.isTestModeOn = true
                    }
                case let .failure(error):
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

    static func login(method: @escaping () -> Void) {
        var serverAddress: String = ""
        var url: String = ""
        if TestServerInfo.isTestModeOn == false {
            serverAddress = ServerInfo.authServerAddr // + ":" + ServerInfo.authServerPort
            url = serverAddress + "/cgi-bin/srun_portal"
        } else {
            serverAddress = TestServerInfo.testServerAddr
            url = serverAddress + "/cgi-bin/srun_portal"
        }
        let queue = DispatchQueue(label: "cn.ehut.response-queue", qos: .default, attributes: [.concurrent])
        var username: String = ""
        if TestServerInfo.isTestModeOn == true {
            username = UserInfo.username
        } else {
            username = Crypto.usernameEncrypt(username: UserInfo.username)
        }
        let parameters: Parameters = [
            "action": "login",
            "username": username,
            "password": Crypto.passwordEncrypt(password: UserInfo.password, passwordKey: ServerInfo.key),
            "mac": ServerInfo.macAddr,
            "ac_id": ServerInfo.acid,
            "type": ServerInfo.type,
            "n": "117",
            "pop": ServerInfo.pop,
            "drop": ServerInfo.drop,
            "mbytes": "0",
            "minutes": "0",
        ]
        print("url", url)
        networkSet.Manager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.queryString).responseString(
            queue: queue,
            completionHandler: { response in
                switch response.result {
                case let .success(get):
                    print(get)
                    postResult.result = get
                    postResult.networkIsConnect = true
                    if get.contains("502 Bad Gateway") {
                        print("cgi is broken")
                        TestServerInfo.isCgiBroken = true
                    } else if get.contains("login_ok") {
                        TestServerInfo.isCgiBroken = false
                        postResult.isLoginOK = true
                    } else {
                        TestServerInfo.isCgiBroken = false
                        postResult.isLoginOK = false
                        if get.contains("login_error#INFO failed, BAS respond timeout.") {
                            postResult.isAcidError = true
                        }
                    }
                case let .failure(error):
                    postResult.networkIsConnect = false
                    print(error)
                }
                DispatchQueue.main.async {
                    method()
                }
            }
        )
    }

    static func logout(method: @escaping () -> Void) {
        var serverAddress: String = ""
        var url: String = ""
        if TestServerInfo.isTestModeOn == false {
            serverAddress = ServerInfo.authServerAddr // + ":" + ServerInfo.authServerPort
            url = serverAddress + "/cgi-bin/srun_portal"
        } else {
            serverAddress = TestServerInfo.testServerAddr
            url = serverAddress + "/cgi-bin/srun_portal"
        }
        let queue = DispatchQueue(label: "cn.ehut.response-queue", qos: .default, attributes: [.concurrent])
        let parameters: Parameters = [
            "action": "logout",
            "username": Crypto.usernameEncrypt(username: OnlineInfo.onlineUsername),
            "mac": ServerInfo.macAddr,
            "ac_id": ServerInfo.acid,
            "type": ServerInfo.type,
            "n": "117",
            "pop": ServerInfo.pop,
            "drop": ServerInfo.drop,
            "mbytes": "0",
            "minutes": "0",
        ]
        networkSet.Manager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.queryString).responseString(
            queue: queue,
            completionHandler: { response in
                switch response.result {
                case let .success(get):
                    print(get)
                    postResult.result = get
                    postResult.networkIsConnect = true
                    if get.contains("502 Bad Gateway") {
                        print("cgi is broken")
                        TestServerInfo.isCgiBroken = true
                    } else if get.contains("logout_ok") {
                        TestServerInfo.isCgiBroken = false
                        postResult.isLogoutOK = true
                    } else {
                        TestServerInfo.isCgiBroken = false
                        postResult.isLogoutOK = false
                        if get.contains("You are not online.") {
                            postResult.isNotOnline = true
                        }
                    }
                case let .failure(error):
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
    // 取小数点后几位
    public func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
