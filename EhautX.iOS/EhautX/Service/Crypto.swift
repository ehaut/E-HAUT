//
//  Crypto.swift
//  EhautTeam
//
//  Created by zh on 2019/5/26.
//  Copyright © 2019 ehaut. All rights reserved.
//

import Foundation

class Crypto {
    static func usernameEncrypt(username: String) -> String {
        var user: String = "{SRUN3}\r\n"

        for each in username {
            let e = each.asciiValue + 4
            user += e.asciiToString
        }

        return user
    }

    static func passwordEncrypt(password: String, passwordKey: String) -> String {
        var passwd: String = ""
        let passwordKeyLength = passwordKey.count
        let key = Array(passwordKey)
        var i = 0
        for each in password {
            let ki: Int = each.asciiValue ^ key[passwordKeyLength - i % passwordKeyLength - 1].asciiValue
            let _l: Int = Int((ki & 0x0F) + 0x36)
            let _h: Int = Int((ki >> 4 & 0x0F) + 0x63)
            if i % 2 == 0 {
                passwd += _l.asciiToString + _h.asciiToString
            } else {
                passwd += _h.asciiToString + _l.asciiToString
            }
            i += 1
        }

        return passwd
    }
}

extension Character {
    var asciiValue: Int {
        let s = String(self).unicodeScalars
        return Int(s[s.startIndex].value)
    }
}

extension Int {
    var asciiToString: String {
        return String(UnicodeScalar(UInt8(self)))
    }
}
