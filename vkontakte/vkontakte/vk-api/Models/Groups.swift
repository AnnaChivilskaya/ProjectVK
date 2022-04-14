//
//  Groups.swift
//  vkontakte
//
//  Created by Аня on 30.03.2022.
//

import UIKit
import RealmSwift
import Foundation

class Groups: Object {
    @objc dynamic var groupName: String = ""
    @objc dynamic var groupLogo: String  = ""
    @objc dynamic var id: Int  = 0
    
    init(groupName: String, groupLogo: String, id: Int) {
        self.groupName = groupName
        self.groupLogo = groupLogo
        self.id = id
    }
    
    required override init() {
        super.init()
    }

}
