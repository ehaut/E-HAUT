//
//  LogoutViewController.swift
//  E-HAUT
//
//  Created by zh on 2019/5/29.
//  Copyright © 2019 ehaut. All rights reserved.
//

import UIKit
import SafariServices
import JGProgressHUD

class LogoutViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    
    var lable:[String] = ["用户名","地    址","时    间","流    量"]
    var info:[String] = ["载入中...","载入中...","载入中...","载入中..."]
    //var infoTest:[String] = ["201616000000","255.255.255.255","0 小时 0 分 0 秒","99.999 GB"]
    
    var timer:Timer?
    var time:Int = 0
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        stopTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if(pageInfo.isJump) { //跳转来的
            if(pageInfo.isAutoJump) {
                let hud = JGProgressHUD(style: .dark)
                hud.textLabel.text =  "获取状态成功！"
                hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 3.0)
            }  
            pageInfo.isAutoJump=false
            pageInfo.isJump=false
        } else if (!pageInfo.isJump) { //页面被载入
            Network.getUserStatus() {
                if(OnlineInfo.networkIsConnect && OnlineInfo.isOnline) {
                    //网络连接成功，且在线，留在本页，提示重新获取状态成功
                    let hud = JGProgressHUD(style: .dark)
                    hud.textLabel.text =  "重新获取状态成功！"
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.show(in: self.view)
                    hud.dismiss(afterDelay: 3.0)
                } else if(!OnlineInfo.networkIsConnect) {
                    //网络连接错误，提示网络错误，跳转到登陆页
                    let hud = JGProgressHUD(style: .dark)
                    hud.textLabel.text = "网络连接错误！"
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.show(in: self.view)
                    hud.dismiss(afterDelay: 3.0)
                    self.dismiss(animated: true, completion: nil)
                    pageInfo.isAutoJump=true
                    pageInfo.isJump=true
                } else if (OnlineInfo.networkIsConnect && !OnlineInfo.isOnline) {
                    //网络连接成功，且不在线，跳转到登录页
                    self.dismiss(animated: true, completion: nil)
                    pageInfo.isAutoJump=true
                    pageInfo.isJump=true
                }
            }
        }
        self.setDisplay()
        startTimer()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
   
    
    func setDisplay() {
//        info[0]="201616000000"
//        info[1]="255.255.255.255"
//        info[3]="999.99 MB"
       info[0] = OnlineInfo.onlineUsername
       info[1] = OnlineInfo.onlineIp
       info[3] = OnlineInfo.usedData
       time = OnlineInfo.usedTime
       tableView.reloadData()
       startTimer()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "CellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell==nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellid)
        }
        
        cell?.textLabel?.text = lable[indexPath.row]
        cell?.detailTextLabel?.text = info[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    //启动定时运行
    func startTimer() {
        if timer == nil {
            self.timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(self.refresh),
                userInfo: nil,
                repeats: true)
        }
    }
    
    @objc func refresh() {
        let h:Int = Int(time/3600)
        let m:Int = Int(time/60%60)
        let s:Int = time%60
        let timeShow:String = String(h)+" 小时 "+String(m)+" 分 "+String(s)+" 秒"
        //infoTest[2]=timeShow
        info[2]=timeShow
        let indexPath = NSIndexPath(row: 2, section: 0)
        tableView.reloadRows(at: [indexPath as IndexPath], with: .none)
        time = time + 1
    }
    
    @IBAction func openServiceWebSite(_ sender: Any) {
        var serviceUrl:String = ServerInfo.serviceServerAddr+":"+ServerInfo.serviceServerPort
        //let url = NSURL(string: "http://172.16.154.130:8800/")
        let username:String = OnlineInfo.onlineUsername
        if(!username.isEmpty) {
            let data = username + ":" + username
            let utf8EncodeData = data.data(using: String.Encoding.utf8, allowLossyConversion: true)
            // 将NSData进行Base64编码
            let base64String:String = (utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0))))!
            serviceUrl = serviceUrl + "/site/sso?data=" + base64String
            //print("encodedString: \(serviceUrl)")
        }
        let url = NSURL(string:serviceUrl)
        let svc = SFSafariViewController(url: url! as URL)
        present(svc, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        Network.logout() {
            
        }
        self.dismiss(animated: true, completion: nil)
    }
}

