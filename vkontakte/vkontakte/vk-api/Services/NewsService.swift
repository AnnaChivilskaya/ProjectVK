//
//  NewsService.swift
//  vkontakte
//
//  Created by Аня on 05.04.2022.
//


import Foundation
import UIKit

struct NewsResponse: Decodable {
    var response: Response
    
    struct Response: Decodable {
        var items: [Item]
        var groups: [Groups]
        var profiles: [Profiles]
        
        struct Item: Decodable {
            var sourceID: Int
            var date: Double
            var text: String
            var likes: Likes
            var comments: Comments
            var reposts: Reposts
            var views: Views
            var attachments: [Attachments]?
            
            private enum CodingKeys: String, CodingKey {
                case sourceID = "source_id"
                case date
                case text
                case likes
                case comments
                case reposts
                case views
                case attachments
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                sourceID = try container.decode(Int.self, forKey: .sourceID)
                date = try container.decode(Double.self, forKey: .date)
                text = try container.decode(String.self, forKey: .text)
                likes = try container.decode(Likes.self, forKey: .likes)
                comments = try container.decode(Comments.self, forKey: .comments)
                reposts = try container.decode(Reposts.self, forKey: .reposts)
                views = try container.decode(Views.self, forKey: .views)
                attachments = try container.decodeIfPresent([Attachments].self, forKey: .attachments)
            }
            
            struct Likes: Decodable {
                var count: Int
            }
            
            struct Comments: Decodable {
                var count: Int
            }
            
            struct Reposts: Decodable {
                var count: Int
            }
            
            struct Views: Decodable {
                var count: Int
            }
            
            struct Attachments: Decodable {
                var type: String
                var photo: Photo?
                var link: Link?
                
                struct Photo: Decodable {
                    var sizes: [Sizes]
                    
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
        
        struct Groups: Decodable {
            var id: Int
            var name: String
            var avatar: String
            
            private enum CodingKeys: String, CodingKey {
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
        
        struct Profiles: Decodable {
            var id: Int
            var firstName: String
            var lastName: String
            var avatar: String
            
            private enum CodingKeys: String, CodingKey {
                case id
                case firstName = "first_name"
                case lastName = "last_name"
                case avatar = "photo_50"
            }
            
        init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                id = try container.decode(Int.self, forKey: .id)
                firstName = try container.decode(String.self, forKey: .firstName)
                lastName = try container.decode(String.self, forKey: .lastName)
                avatar = try container.decode(String.self, forKey: .avatar)
        }
        }
    }
}

class GetNews {
    
    func loadData(complition: @escaping ([News]) -> Void ) {
        
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
       
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/newsfeed.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "owner_id", value: String(Session.instance.userId)),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "filters", value: "post,photo"),
            URLQueryItem(name: "count", value: "2"),
            URLQueryItem(name: "v", value: "5.122")
        ]
        

        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            
           
            guard let data = data else { return }
            
            do {
                let arrayNews = try JSONDecoder().decode(NewsResponse.self, from: data)
                
                guard arrayNews.response.items.isEmpty == false else { return }
                
                var avatar: String = ""
                var name: String = ""
                var stringDate: String
                var text: String
                var urlImg: String = ""
                
                var news: [News] = []
                
                for index in 0...arrayNews.response.items.count-1 {
                    let typeNews = arrayNews.response.items[index].attachments?.first?.type
                    guard typeNews != "link" || typeNews != "photo" else { return }
                    
                    //Преобразование даты
                    let dateFormatter: DateFormatter = {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        return dateFormatter
                    } ()
                   
                    let date = Date(timeIntervalSince1970: arrayNews.response.items[index].date)
                    stringDate = dateFormatter.string(from: date)
                    
                    text = arrayNews.response.items[index].text
                    
                    if typeNews == "link" {
                        urlImg = arrayNews.response.items[index].attachments?.first?.link?.photo.sizes.first?.url ?? ""
                    }
                    if typeNews == "photo" {
                        urlImg = arrayNews.response.items[index].attachments?.first?.photo?.sizes.last?.url ?? ""
                    }
                    
                    let likes = arrayNews.response.items[index].likes.count
                    let comments = arrayNews.response.items[index].comments.count
                    let reposts = arrayNews.response.items[index].reposts.count
                    let views = arrayNews.response.items[index].views.count
                    
                    
                    let sourceID = arrayNews.response.items[index].sourceID * -1
                    for index in 0...arrayNews.response.groups.count-1 {
                        if arrayNews.response.groups[index].id == sourceID {
                            name = arrayNews.response.groups[index].name
                            avatar = arrayNews.response.groups[index].avatar
                        }
                    }
                    
                    news.append(News(name: name, avatar: avatar, date: stringDate, NewsText: text, textImage: urlImg, likes: likes, comments: comments, reposts: reposts, views: views))
                }
                DispatchQueue.main.async {
                    complition(news)
                }
           
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    complition([])
                }
            }
        }
        task.resume()
    }
    
}

