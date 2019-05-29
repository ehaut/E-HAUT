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
    init() {
        
    }
    func getUserStatus() -> Bool {
        var networkIsConnect = false
        let serverAddress = ServerInfo.authServerAddr + ":" + ServerInfo.authServerPort
        let url = serverAddress + "/cgi-bin/rad_user_info"
        AF.request(url).responseString { response in
            switch(response.result) {
                case .success(let get):
                    print(get)
                    networkIsConnect = true
                    if(get.contains("not_online")) {
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
                    networkIsConnect = false
                    print(error)
            }
            print("1",networkIsConnect)
        }
        print("2",networkIsConnect)
        //print(OnlineInfo.onlineUsername)
        return networkIsConnect
    }
    
}


extension Double {
    //取小数点后几位
    public func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
