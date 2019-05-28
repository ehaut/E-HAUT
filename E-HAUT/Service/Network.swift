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
    
    static func getUserStatus (serverAddress : String) -> Bool {
        var networkIsConnect = true
        let url = serverAddress + "/cgi-bin/rad_user_info"
        Alamofire.request(url).responseString(completionHandler:{ response in
            switch(response.result) {
                case .success(let get):
                    print(get)
                    if(get.contains("not_online")) {
                        OnlineInfo.isOnline = false
                    } else {
                        OnlineInfo.isOnline = true
                        let list = get.components(separatedBy: ",")
                        OnlineInfo.loginTime = Int(list[1])!
                        OnlineInfo.onlineIp = list[8]
                        OnlineInfo.onlineUsername = list[0]
                        let d = Double(list[6])!
                        OnlineInfo.usedData = String(d / 1073741824.0)
                        OnlineInfo.serverTime = Int(list[2])!
                        let t = Int(list[7])!
                        OnlineInfo.usedTime = String(t + OnlineInfo.serverTime - OnlineInfo.loginTime)
                        //print(OnlineInfo.onlineUsername)
                    }
                case .failure(let error):
                    networkIsConnect = false
                    print(error)
            }
        })
        return networkIsConnect
    }
    
}


