//
//  Session.swift
//  vkontakte
//
//  Created by Аня on 06.04.2022.
//

import Foundation
import SwiftKeychainWrapper

final class Session {
    
    private init() {}
    static let instance = Session()
    
    var token: String  {
        set {
            KeychainWrapper.standard.set(newValue, forKey: "userId")
        }
        get {
            return KeychainWrapper.standard.string(forKey: "userId") ?? ""
        }
    }
    var userId: Int  {
        set {
            UserDefaults.standard.set(newValue, forKey: "userId")
        }
        get {
            return UserDefaults.standard.integer(forKey: "userId")
        }
    }
}

