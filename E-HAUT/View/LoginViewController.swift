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

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    //@IBOutlet weak var serviceButton: UIButton!
    
    var textFields: [SkyFloatingLabelTextField] = []
    var username:String?
    var password:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.clearButtonMode = .whileEditing
        
        textFields = [usernameTextField,passwordTextField]
        
        for textField in textFields {
            textField.delegate = self
        }
        
        reloadConfig()
    
    }
    
    
    func reloadConfig() {
        //See here:https://stackoverflow.com/a/49170429
        let defaluts = UserDefaults.standard
        username = defaluts.object(forKey: "username") as? String
        password = defaluts.object(forKey: "password") as? String
        if username != nil {
            usernameTextField.text = username
        } else {
            usernameTextField.becomeFirstResponder()
        }
        if password != nil {
            passwordTextField.text = password
        }
        //TODO:Login

        
    }
    
    
    var isLoginButtonPressed: Bool = false
    var showingTitleInProgress: Bool = false //用以处理动画效果

    @IBAction func loginButtonPressed(_ sender: Any) {
        self.isLoginButtonPressed = true

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
            let user = usernameTextField.text
            let passwd = passwordTextField.text
            if (user != username) {
                UserDefaults.standard.set(user,forKey: "username")
            }
            if (passwd != password) {
                UserDefaults.standard.set(passwd,forKey: "password")
            }
            
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

