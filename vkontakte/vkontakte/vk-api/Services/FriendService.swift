//
//  PersonDB.swift
//  vkontakte
//
//  Created by Аня on 06.02.2022.
//

import Foundation
import RealmSwift

struct FriendsResponse: Decodable {
    var response: Response
    
    struct Response: Decodable {
        var count: Int
        var items: [Item]
        
        struct Item: Decodable {
            var id: Int
            var firstName: String
            var lastName: String
            var avatar: String
            var deactivated: String?
            

            private enum CodingKeys: String, CodingKey {
                case id
                case firstName = "first_name"
                case lastName = "last_name"
                case avatar  = "photo_50"
                case deactivated
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                id = try container.decode(Int.self, forKey: .id)
                firstName = try container.decode(String.self, forKey: .firstName)
                lastName = try container.decode(String.self, forKey: .lastName)
                avatar = try container.decode(String.self, forKey: .avatar)
                
                deactivated = try? container.decodeIfPresent(String.self, forKey: .deactivated)
            }
        }
    }
}

class GetFriends {
    
    func loadData() {
        
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        

        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.vk.com"
        url.path = "/method/friends.get"
        url.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.instance.userId)),
            URLQueryItem(name: "fields", value: "photo_50"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.111")
        ]
        
        let task = session.dataTask(with: url.url!) { (data, response, error) in

            guard let data = data else { return }
            
            do {
                let arrayFriends = try JSONDecoder().decode(FriendsResponse.self, from: data)
                var friendList: [Friends] = []
                for i in 0...arrayFriends.response.items.count-1 {

                    if arrayFriends.response.items[i].deactivated == nil {
                        let name = ((arrayFriends.response.items[i].firstName) + " " + (arrayFriends.response.items[i].lastName))
                        let avatar = arrayFriends.response.items[i].avatar
                        let id = String(arrayFriends.response.items[i].id)
                        friendList.append(Friends.init(userName: name, userAvatar: avatar, ownerID: id))
                    }
                }
                
                DispatchQueue.main.async {
                    Realms().SaveFriendsToRealm(friendList)
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
}
