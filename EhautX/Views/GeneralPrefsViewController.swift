//
//  GeneralPrefsViewController.swift
//  EhautX
//
//  Created by EhautTeam on 2019/7/2.
//  Copyright © 2019 Ehaut Team. All rights reserved.
//

import Cocoa
import Preferences
import SwiftyUserDefaults

class GeneralPrefsViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = PreferencePane.Identifier.general
    let preferencePaneTitle = "General"
    let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!
    
    @objc dynamic var username: String? {
        get { return Defaults[.username] }
        set { Defaults[.username] = newValue }
    }
    
    @objc dynamic var password: String? {
        get { return Defaults[.password] }
        set { Defaults[.password] = newValue }
    }
    
    @objc dynamic var timeout: Int {
        get { return Defaults[.timeout] }
        set { Defaults[.timeout] = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
