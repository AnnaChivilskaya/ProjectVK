//
//  Friends + PromiseKit.swift
//  vkontakte
//
//  Created by Аня on 13.04.2022.
//

import UIKit
import PromiseKit

class FriendsPromiseKit {

    func getData() {
        firstly {
            loadJsonData()
        }
        .then {  data in
            self.parsingData(data)
        }
        .done { friendsList in
            self.saveData(friendsList)
        }
        .catch { error in
            print(error)
        }
        .finally {
            print("Load")
        }
    }

    func loadJsonData() -> Promise <Data> {
        return Promise <Data> { (resolver) in
            let configuration = URLSessionConfiguration.default
            let session =  URLSession(configuration: configuration)

            var urlConstructor = URLComponents()
            urlConstructor.scheme = "https"
            urlConstructor.host = "api.vk.com"
            urlConstructor.path = "/method/friends.get"
            urlConstructor.queryItems = [
                URLQueryItem(name: "user_id", value: String(Session.instance.userId)),
                URLQueryItem(name: "fields", value: "photo_50"),
                URLQueryItem(name: "access_token", value: Session.instance.token),
                URLQueryItem(name: "v", value: "5.131")
            ]

            session.dataTask(with: urlConstructor.url!) { (data, response, error) in

                if let error = error {
                    resolver.reject(error)
                } else  {
                    resolver.fulfill(data ?? Data())
                }
            } .resume()
    }
}

    func parsingData(_ data: Data) -> Promise<[Friends]> {
        return Promise <[Friends]> { (resolver) in
            do {
                let arrayFriends = try JSONDecoder().decode(FriendsResponse.self, from: data)
                var friendList: [Friends] = []
                for index in 0...arrayFriends.response.items.count-1 {

                    if arrayFriends.response.items[index].deactivated == nil {
                        let name = ((arrayFriends.response.items[index].firstName) + " " + (arrayFriends.response.items[index].lastName))
                        let avatar = arrayFriends.response.items[index].avatar
                        let id = String(arrayFriends.response.items[index].id)
                        friendList.append(Friends.init(userName: name, userAvatar: avatar, ownerID: id))
                    }
                }
                resolver.fulfill(friendList)
            } catch let error {
                resolver.reject(error)
            }
        }
    }

    func saveData(_ friendsList: [Friends]) {
        DispatchQueue.main.async {
            Realms().SaveFriendsToRealm(friendsList)
        }
    }
}

