//
//  Photo.swift
//  vkontakte
//
//  Created by Аня on 06.04.2022.
//

import UIKit
import RealmSwift
import Foundation

class Photos: Object {
    @objc dynamic var photo: String = ""
    @objc dynamic var ownerID: String  = ""
    
    init(photo: String, ownerID: String) {
        self.photo = photo
        self.ownerID = ownerID
    }
    
    required init() {
        super.init()
    }
}
