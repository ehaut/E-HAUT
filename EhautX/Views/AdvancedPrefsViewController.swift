//
//  AdvancedPrefsViewController.swift
//  EhautX
//
//  Created by EhautTeam on 2019/7/2.
//  Copyright © 2019 Ehaut Team. All rights reserved.
//

import Cocoa
import Preferences
import SwiftyUserDefaults

class AdvancedPrefsViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = PreferencePane.Identifier.advanced
    let preferencePaneTitle = "Advanced"
    let toolbarItemIcon = NSImage(named: NSImage.advancedName)!
    
    @objc dynamic var authServer: String {
        get { return Defaults[.authServer] }
        set { Defaults[.authServer] = newValue }
    }

    @objc dynamic var msgServer: String {
        get { return Defaults[.msgServer] }
        set { Defaults[.msgServer] = newValue }
    }

    @objc dynamic var infoServer: String {
        get { return Defaults[.infoServer] }
        set { Defaults[.infoServer] = newValue }
    }
    
    @objc dynamic var passwordKey: String {
        get { return Defaults[.passwordKey] }
        set { Defaults[.passwordKey] = newValue }
    }
    
    @objc dynamic var acid: String {
        get { return Defaults[.acid] }
        set { Defaults[.acid] = newValue }
    }
    
    @objc dynamic var only_acid: Bool {
        get { return Defaults[.only_acid] }
        set { Defaults[.only_acid] = newValue }
    }
    
    @objc dynamic var type: String {
        get { return Defaults[.type] }
        set { Defaults[.type] = newValue }
    }
    
    @objc dynamic var n: String {
        get { return Defaults[.n] }
        set { Defaults[.n] = newValue }
    }
    
    @objc dynamic var drop: String {
        get { return Defaults[.drop] }
        set { Defaults[.drop] = newValue }
    }
    
    @objc dynamic var pop: String {
        get { return Defaults[.pop] }
        set { Defaults[.pop] = newValue }
    }
    
    @objc dynamic var mbytes: String {
        get { return Defaults[.mbytes] }
        set { Defaults[.mbytes] = newValue }
    }
    
    @objc dynamic var minutes: String {
        get { return Defaults[.minutes] }
        set { Defaults[.minutes] = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
