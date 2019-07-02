//
//  AppDelegate.swift
//  EhautX
//
//  Created by EhautTeam on 2019/7/2.
//  Copyright © 2019 Ehaut Team. All rights reserved.
//

import Cocoa
import Preferences
import SwiftyUserDefaults

extension PreferencePane.Identifier {
    static let general = Identifier("general")
    static let advanced = Identifier("advanced")
}

extension DefaultsKeys {
    static let authServer = DefaultsKey<String>("authServer", defaultValue: "http://172.16.154.130/cgi-bin/srun_portal")
    static let msgServer = DefaultsKey<String>("msgServer", defaultValue: "http://172.16.154.130/get_msg.php")
    static let infoServer = DefaultsKey<String>("infoServer", defaultValue: "http://172.16.154.130/cgi-bin/rad_user_info")
    static let username = DefaultsKey<String?>("username")
    static let password = DefaultsKey<String?>("password")
    static let passwordKey = DefaultsKey<String>("passwordKey", defaultValue: "1234567890")
    
    static let acid = DefaultsKey<String>("acid", defaultValue: "1")
    static let type = DefaultsKey<String>("type", defaultValue: "10")
    static let n = DefaultsKey<String>("n", defaultValue: "117")
    static let drop = DefaultsKey<String>("drop", defaultValue: "0")
    static let pop = DefaultsKey<String>("pop", defaultValue: "1")
    static let mbytes = DefaultsKey<String>("mbytes", defaultValue: "0")
    static let minutes = DefaultsKey<String>("minutes", defaultValue: "0")
    
    static let only_acid = DefaultsKey<Bool>("only_acid", defaultValue: false)
    
    static let timeout = DefaultsKey<Int>("timeout", defaultValue: 3)
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength);

    let preferencesWindowController = PreferencesWindowController(
        preferencePanes: [
            GeneralPrefsViewController(),
            AdvancedPrefsViewController(),
        ]
    )

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // Show the status icon
        let button = statusItem.button
        button?.image = NSImage(named: "NetworkDisconnect")
        
        // Build statusbar menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(
            title: "About",
            action: #selector(NSApplication.shared.orderFrontStandardAboutPanel(_:)),
            keyEquivalent: ""
        ))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(
            title: "Preferences…",
            action: #selector(self.preferencesMenuItemActionHandler(_:)),
            keyEquivalent: ","
        ))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(
            title: "Quit",
            action: #selector(NSApplication.shared.terminate(_:)),
            keyEquivalent: "q"
        ))
        
        statusItem.menu = menu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
        preferencesWindowController.show()
    }
}
