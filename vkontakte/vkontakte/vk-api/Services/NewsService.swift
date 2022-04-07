//
//  NewsService.swift
//  vkontakte
//
//  Created by Аня on 05.04.2022.
//

import Foundation
import UIKit
import SwiftUI

struct NewsResponse: Decodable {
    var response: Response
    
    struct  Response: Decodable {
        var items: [Item]
        var groups: [Groups]
        
        struct Item:  Decodable {
            var sourceId: Int
            var date: Int
            var text: String
            var attachments: [Attachments]
            
            private enum CodingKeys: String, CodingKey  {
                case sourceId = "source_id"
                case date
                case text
                case attachments
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                sourceId = try container.decode(Int.self, forKey: .sourceId)
                date = try container.decode(Int.self, forKey: .date)
                text = try container.decode(String.self, forKey: .text)
                attachments = try container.decode([Attachments].self, forKey: .attachments)
            }
            
            struct Attachments: Decodable {
                var type:  String
                var photo: Photo?
                var link: Link?
                
                struct Photo: Decodable {
                    var sizes : [Sizes]
                    
                    struct Sizes: Decodable {
                        var url: String
                    }
                }
                
                struct Link: Decodable {
                    var photo: LinkPhoto
                    
                    struct LinkPhoto: Decodable {
                        var sizes: [Sizes]
                        
                        struct Sizes: Decodable {
                            var url: String
                        }
                    }
                }
            }
        }
    }
    
    struct Groups: Decodable {
        var id: Int
        var name :  String
        var avatar:  String
        
        private enum CodingKeys :  String, CodingKey {
            case id
            case name
            case avatar = "photo_50"
        }
        
        init(from decoder: Decoder) throws {
                        let container = try decoder.container(keyedBy: CodingKeys.self)
                        id = try container.decode(Int.self, forKey: .id)
                        name = try container.decode(String.self, forKey: .name)
                        avatar = try container.decode(String.self, forKey: .avatar)
                    }
    }
}
//
//    class GetNews{
//
//    func loadData()
//
//    let configuration URLSeesionConfiguration.default
//    let session = URLSession(configuration: configuration)
//
//    var url = URLComponents()
//    url.scheme = "https"
//    url.host = "api.vk.com"
//    url.path = "/method/newsfeed.get"
//    url.queryItems = [
//        URLQueryItem(name: "owner_id", value: String(Session.instante.userId)),
//        URLQueryItem(name: "access_token", value: Session.instante.token),
//    URLQueryItem(name: "filters", value: "post"),
//        URLQueryItem(name: "count", value: "2"),
//    URLQueryItem(name: "v", value: "5.111")]
//
//        let task = session.dataTask(with: url.url!) { (data, response, error)
//        print(url.url!)
//
//        guard let data = data else { return }
//
//        do {
//            let arrayNews = try JSONDecoder().decode(NewsResponse, from: data)
//
//            var NewsService: [PostNews] = []
//
//            guard arrayNews.response.items.count != 0 else { return }
//
//            for i in 0...arrayNews.response.items.count-1 {
//                let date : String = String(arrayNews.response.items[i].date)
//                let text: String = arrayNews.response.items[i].text
//                var UrlPhoto: String = ""
//
//                if arrayNews.response.items[i].attachments.first?.type == "link" { UrlPhoto = arrayNews.response.items[i].attachments.first?.link?.photo.sizes.first?.url ?? ""
//                                        print("link")
//                                    }
//                                    if arrayNews.response.items[i].attachments.first?.type == "photo" {
//                                        UrlPhoto = arrayNews.response.items[i].attachments.first?.photo?.sizes.last?.url ?? ""
//                                        print("photo")
//                                    }
//
//                                    print("\(date) \(text) \(urlPhoto)")
//
//                    }  catch var error {
//             print(error)
//      }
//    }
//       task.resume()
//     }
//
//
//    }


