//
//  LogoutViewController.swift
//  E-HAUT
//
//  Created by zh on 2019/5/29.
//  Copyright © 2019 ehaut. All rights reserved.
//

import UIKit
import SafariServices


class LogoutViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    static let logoutViewController:LogoutViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "logout") as! LogoutViewController
    
    @IBOutlet weak var tableView: UITableView!
    
//    var tableView:UITableView?
    
    var lable:[String] = ["用户名","地    址","时    间","流    量"]
    var info:[String] = ["载入中...","载入中...","载入中...","载入中..."]
    //var infoTest:[String] = ["201616000000","255.255.255.255","0 小时 0 分 0 秒","99.999 GB"]
    
    var timer:Timer?
    var time:Int = 0
    
    
    func getTableViews(of view: UIView) {
        // 1. code here do something with view
        for subview in view.subviews {
            if(subview is UITableView) {
                  tableView = subview as? UITableView
                  //print(tableView)
            }
            //getTableViews(of: subview)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        stopTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Network.getUserStatus()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tableView)
        tableView?.dataSource = self
        tableView?.delegate = self
    }
   
    
    func setDisplay() {
//        info[0]="201616000000"
//        info[1]="255.255.255.255"
//        info[3]="999.99 MB"
       info[0] = OnlineInfo.onlineUsername
       info[1] = OnlineInfo.onlineIp
       info[3] = OnlineInfo.usedData
       time = OnlineInfo.usedTime
       getTableViews(of: self.view)
       print(tableView)
       tableView!.reloadData()
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
        return 50.0
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
        tableView?.reloadRows(at: [indexPath as IndexPath], with: .none)
        time = time + 1
    }
    
    @IBAction func openServiceWebSite(_ sender: Any) {
        let serviceUrl:String = ServerInfo.serviceServerAddr+":"+ServerInfo.serviceServerPort
        //let url = NSURL(string: "http://172.16.154.130:8800/")
        let url = NSURL(string:serviceUrl)
        let svc = SFSafariViewController(url: url! as URL)
        present(svc, animated: true, completion: nil)
    }
    
}

