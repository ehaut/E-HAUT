//
//  LoginViewController.swift
//  E-HAUT
//
//  Created by zh on 2019/5/26.
//  Copyright © 2019 ehaut. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SafariServices
import JGProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    //@IBOutlet weak var serviceButton: UIButton!
    
    var textFields: [SkyFloatingLabelTextField] = []
    var username:String?
    var password:String?
    var acid:String?
    var logoutViewController:LogoutViewController?
    let loginLoading = JGProgressHUD(style: .dark)
    let getStatusLoading = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.clearButtonMode = .whileEditing
        
        textFields = [usernameTextField,passwordTextField]
        
        for textField in textFields {
            textField.delegate = self
        }
        
        reloadConfig()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        logoutViewController = storyboard.instantiateViewController(withIdentifier: "logout") as? LogoutViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(true)
        OnlineInfo.networkIsConnect = false
        OnlineInfo.isOnline = false
        if(postResult.isLogoutOK) {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text =  "注销成功！"
            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 3.0)
            postResult.isAcidError = false
            postResult.isLoginOK = false
            postResult.networkIsConnect = false
            postResult.isLogoutOK = false
            postResult.isNotOnline = false
            postResult.result = ""
        } else {
            //getStatusLoading.textLabel.text="获取状态中..请稍后！"
            //getStatusLoading.show(in: self.view)
            Network.getUserStatus() {
                if(OnlineInfo.networkIsConnect && OnlineInfo.isOnline) {
                    //网络连接成功，且在线，跳转到注销页
                    //self.getStatusLoading.dismiss()
                    let hud = JGProgressHUD(style: .dark)
                    hud.textLabel.text =  "获取状态成功！"
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.show(in: self.view)
                    hud.dismiss(afterDelay: 3.0)
                    self.present(self.logoutViewController!, animated: true, completion: nil)
                } else if(!OnlineInfo.networkIsConnect) {
                    //网络连接错误，提示网络错误
                    //self.getStatusLoading.dismiss()
                    let hud = JGProgressHUD(style: .dark)
                    hud.textLabel.text = "网络连接错误！"
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.show(in: self.view)
                    hud.dismiss(afterDelay: 3.0)
                } else if (OnlineInfo.networkIsConnect && !OnlineInfo.isOnline) {
                    //网络连接成功，且不在线
                    //self.getStatusLoading.dismiss()
                    let hud = JGProgressHUD(style: .dark)
                    hud.textLabel.text =  "获取状态成功！"
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.show(in: self.view)
                    hud.dismiss(afterDelay: 3.0)
                }
            }
        }
    }
    
    func reloadConfig() {
        //See here:https://stackoverflow.com/a/49170429
        let defaluts = UserDefaults.standard
        username = defaluts.object(forKey: "username") as? String
        password = defaluts.object(forKey: "password") as? String
        acid = defaluts.object(forKey: "acid") as? String
        if username != nil {
            usernameTextField.text = username
        } else {
            usernameTextField.becomeFirstResponder()
        }
        if password != nil {
            passwordTextField.text = password
        }
        if acid != nil {
            ServerInfo.acid = acid!
        } else {
            ServerInfo.acid = "1"
        }
    }
    
    
    var isLoginButtonPressed: Bool = false
    var showingTitleInProgress: Bool = false //用以处理动画效果

    @IBAction func loginButtonPressed(_ sender: Any) {
        loginButton.isEnabled = false
        self.isLoginButtonPressed = true
        loginLoading.textLabel.text = "登陆中..请稍后！"
        var signal:Bool = false
        for textField in textFields where !textField.hasText {
            if(signal == false)
            {
                 signal = true
                 textField.becomeFirstResponder()
            }
            showingTitleInProgress = true
            textField.setTitleVisible(
                true,
                animated: true,
                animationCompletion: showingTitleInAnimationComplete
            )
            textField.isHighlighted = true
        }
        if(signal == false)
        {
            loginLoading.show(in: self.view)
            let user = usernameTextField.text
            let passwd = passwordTextField.text
            UserInfo.username = user!
            UserInfo.password = passwd!
            Network.login() {
                if(postResult.networkIsConnect) {
                    if(postResult.isLoginOK)   {
                        if (user != self.username) {
                            UserDefaults.standard.set(user,forKey: "username")
                        }
                        if (passwd != self.password) {
                            UserDefaults.standard.set(passwd,forKey: "password")
                        }
                        UserDefaults.standard.set(ServerInfo.acid,forKey: "acid")
                        self.loginLoading.dismiss()
                        self.present(self.logoutViewController!, animated: true, completion: nil)
                    } else {
                        if(postResult.isAcidError) {
                            if ServerInfo.acid == "1" {
                                ServerInfo.acid = "2"
                                
                            } else if ServerInfo.acid == "2" {
                                ServerInfo.acid = "1"
                            }
                            postResult.isAcidError = false
                            postResult.isLoginOK = false
                            postResult.networkIsConnect = false
                            postResult.isLogoutOK = false
                            postResult.result = ""
                            self.loginButton.isEnabled = true
                            self.loginButtonPressed(Any.self)
                        } else  {
                            self.loginLoading.dismiss()
                            let hud = JGProgressHUD(style: .dark)
                            hud.textLabel.text = postResult.result
                            hud.indicatorView = JGProgressHUDErrorIndicatorView()
                            hud.show(in: self.view)
                            hud.dismiss(afterDelay: 3.0)
                            postResult.isAcidError = false
                            postResult.isLoginOK = false
                            postResult.networkIsConnect = false
                            postResult.isLogoutOK = false
                            postResult.result = ""
                            self.loginButton.isEnabled = true
                        }
                    }
                } else {
                    self.loginLoading.dismiss()
                    let hud = JGProgressHUD(style: .dark)
                    hud.textLabel.text = "网络连接错误！"
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.show(in: self.view)
                    hud.dismiss(afterDelay: 3.0)
                    self.loginButton.isEnabled = true
                }
            }
        } else {
             self.loginButton.isEnabled = true
        }
    }
    
    
    @IBAction func loginButtonTouchUPInside(_ sender: Any) {
        self.isLoginButtonPressed = false
        if !showingTitleInProgress {
            hideTitleVisibleFromFields()
        }
    }
    
    func showingTitleInAnimationComplete(_ completed: Bool) {
        // If a field is not filled out, display the highlighted title for 0.3 seco
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.showingTitleInProgress = false
            if !self.isLoginButtonPressed {
                self.hideTitleVisibleFromFields()
            }
        }
    }
    
    func hideTitleVisibleFromFields() {
        
        for textField in textFields {
            textField.setTitleVisible(false, animated: true)
            textField.isHighlighted = false
        }
        
    }
    
    // MARK: - Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        // When pressing return, move to the next field
//        let nextTag = textField.tag + 1
//
//        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
//            nextResponder.becomeFirstResponder()
//        } else {
//            textField.resignFirstResponder()
//        }
//        return false
        
        if textField == usernameTextField {
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            
        } else if(textField == passwordTextField){
            passwordTextField.resignFirstResponder()
        }
        return true
    }

    
    
    @IBAction func openServiceWebSite(_ sender: Any) {
        let serviceUrl:String = ServerInfo.serviceServerAddr+":"+ServerInfo.serviceServerPort
        //let url = NSURL(string: "http://172.16.154.130:8800/")
        let url = NSURL(string:serviceUrl)
        let svc = SFSafariViewController(url: url! as URL)
        present(svc, animated: true, completion: nil)
    }
    
    
}

