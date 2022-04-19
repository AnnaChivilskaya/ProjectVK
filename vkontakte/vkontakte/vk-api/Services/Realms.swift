//
//  Realm.swift
//  vkontakte
//
//  Created by Аня on 06.04.2022.
//

import Foundation
import RealmSwift

class Realms {

    func SaveFriendsToRealm(_ friendList: [Friends]) {
        do {
            let realm = try Realm()
            try realm.write {
                let oldFriendList = realm.objects(Friends.self) 
                realm.delete(oldFriendList)
                realm.add(friendList)
                
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func SavePhotosToRealm(_ photoList: [Photos], _ ownerID: String) {
        do {
            let realm = try Realm()
            try realm.write {
                let oldPhotoList = realm.objects(Photos.self).filter("ownerID == %@", ownerID)
                realm.delete(oldPhotoList)
                realm.add(photoList)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
        
    func SaveGroupsToRealm(_ grougList: [Groups]) {
        do {
            let realm = try Realm()
            try realm.write  {
                let oldGroupList = realm.objects(Groups.self)
                realm.delete(oldGroupList)
                realm.add(grougList)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func DeleteAllFromRealm() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
