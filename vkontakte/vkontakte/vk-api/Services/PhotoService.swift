//
//  PhotoAPI.swift
//  vkontakte
//
//  Created by Аня on 01.02.2022.
//

import Foundation
import RealmSwift

struct PhotosResponse: Decodable {
    var response: Response
    
    struct Response: Decodable {
        var count: Int
        var items: [Item]
        
        struct Item: Decodable {
            var ownerID: Int
            var sizes: [Sizes]
            
            
            private enum CodingKeys: String, CodingKey {
                case ownerID = "owner_id"
                case sizes
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                ownerID = try container.decode(Int.self, forKey: .ownerID)
                sizes = try container.decode([Sizes].self, forKey: .sizes)
            }
            
            struct Sizes: Decodable {
                
                var url: String
            }
        }
    }
}


class GetPhoto{
    
  
    func loadData(_ ownerID: String) {
        
        
        let configuration = URLSessionConfiguration.default
  
        let session =  URLSession(configuration: configuration)
        
   
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.vk.com"
        url.path = "/method/photos.getAll"
        url.queryItems = [
            URLQueryItem(name: "owner_id", value: ownerID),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.122")
        ]
              
      
        let task = session.dataTask(with: url.url!) { (data, response, error) in
            
            
            
            guard let data = data else { return }
            
            do {
                let arrayPhotosFriend = try JSONDecoder().decode(PhotosResponse.self, from: data)
                var photosFriend: [Photos] = []
                var ownerID = ""
                
                guard arrayPhotosFriend.response.count != 0 else { return } // проверка на наличие фоток
                    
                for i in 0...arrayPhotosFriend.response.items.count-1 {
                    if let urlPhoto = arrayPhotosFriend.response.items[i].sizes.last?.url {
                        ownerID = String(arrayPhotosFriend.response.items[i].ownerID)
                        photosFriend.append(Photos.init(photo: urlPhoto, ownerID: ownerID))
                    }
                }
                DispatchQueue.main.async {
                    Realms().SavePhotosToRealm(photosFriend, ownerID)
                }
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
}
