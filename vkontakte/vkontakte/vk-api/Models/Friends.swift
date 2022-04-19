//
//  FriendsAPI.swift
//  vkontakte
//
//  Created by Аня on 31.01.2022.
//

import UIKit
import RealmSwift
import Foundation

class Friends: Object {
    @objc dynamic var userName: String = ""
    @objc dynamic var userAvatar: String  = ""
    @objc dynamic var ownerID: String  = ""
    
    init(userName:String, userAvatar:String, ownerID:String) {
        self.userName = userName
        self.userAvatar = userAvatar
        self.ownerID = ownerID
    }
    
    required override init() {
        super.init()
    }
}
