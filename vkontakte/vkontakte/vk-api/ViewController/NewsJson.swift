//
//  NewsJson.swift
//  vkontakte
//
//  Created by Аня on 03.05.2022.
//

import Foundation
import UIKit
import SwiftyJSON

final class NewsJson {
    
    func get (newsFrom timestamp: TimeInterval? = nil,
                  nextPageNews nextNewsID: String = "",
                  completion: @escaping ([News], String) -> Void){
            DispatchQueue.global().async {
                
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
                    URLQueryItem(name: "start_from", value: nextNewsID),
                    URLQueryItem(name: "count", value: "10"),
                    URLQueryItem(name: "v", value: "5.131")
                ]
                
                if let timestamp = timestamp {
                    urlConstructor.queryItems?.append(URLQueryItem(name: "start_time", value: String(timestamp)))
                }

                let task = session.dataTask(with: urlConstructor.url!) { [weak self] (data, _, error) in
                    print("Запрос к API: \(urlConstructor.url!)")
                    
                    if let error = error {
                        print("Error in GetNewsListSwiftyJSON: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion([], "")
                        }
                        return
                    }
                    
                    var newsItems: [News] = []
                    var nextFrom = ""
                    if let data = data, let json = try? JSON(data: data) {
                        newsItems = self?.parse(json) ?? []
                        nextFrom = json["response"]["next_from"].stringValue
                    }
                    
                    DispatchQueue.main.async {
                        completion(newsItems, nextFrom)
                    }
                }
                task.resume()
            }
        }
        
        func parse(_ json: JSON) -> [News] {
                let items = json["response"]["items"]
                    .arrayValue
                    .map { NewsResponseItemSwifty(json: $0) }
                
                let profiles = json["response"]["profiles"]
                    .arrayValue
                    .map { NewsProfileJson(json: $0) }
                
                let groups = json["response"]["groups"]
                    .arrayValue
                    .map { NewsGroupsJson(json: $0) }
                
                return makeNewsList(items, profiles, groups)
        }
        
        func makeNewsList(_ items: [NewsResponseItemSwifty],
                          _ profiles: [NewsProfileJson],
                          _ groups: [NewsGroupsJson]) -> [News] {
            
            var newsList: [News] = []
                for item in items {
                    
                    var newItem = News(name: "", avatar: "", date: "", NewsText: item.text, textImage: item.imgUrl, aspect: item.imgAspectRatio, likes: item.likes, comments: item.comments, reposts: item.reposts, views: item.views)
                    
                    newItem.date = self.getDateText(timestamp: item.date)
                    
                    if item.sourceID > 0 {
                        let profile = profiles
                            .filter({ item.sourceID == $0.id })
                            .first
                        newItem.name = profile?.name ?? ""
                        newItem.avatar = profile?.imageUrl ?? ""
                    } else {
                        let group = groups
                            .filter({ abs(item.sourceID) == $0.id })
                            .first
                        newItem.name = group?.name ?? ""
                        newItem.avatar = group?.imageUrl ?? ""
                    }
                    newsList.append(newItem)
                }
            return newsList
        }
        
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            return dateFormatter
        }()
        
        func getDateText(timestamp: Double) -> String {
            let date = Date(timeIntervalSince1970: timestamp)
            let stringDate = dateFormatter.string(from: date)
            return stringDate
        }
        
    }
    
    struct NewsResponseItemSwifty {
        var sourceID: Int
        var authorName: String?
        var authorAvatarUrl: String?
        var date: Double
        var text: String
        var likes: Int
        var comments: Int
        var reposts: Int
        var views: Int
        var imgUrl = ""
        
        var imgHeight: Int?
        var imgWidth: Int?
        var imgAspectRatio: CGFloat{
            return CGFloat(imgHeight ?? 1) / CGFloat(imgWidth ?? 1 )
        }
        
        init(json: JSON){
            self.sourceID = json["source_id"].intValue
            self.date = json["date"].doubleValue
            self.text = json["text"].stringValue
            self.likes = json["likes"]["count"].intValue
            self.comments = json["comments"]["count"].intValue
            self.reposts = json["reposts"]["count"].intValue
            self.views = json["views"]["count"].intValue
            

            if json["attachments"][0]["type"] == "photo" {
                for size in json["attachments"][0]["photo"]["sizes"].arrayValue {
                    if size["type"] == "x" {
                        self.imgUrl = size["url"].stringValue
                        self.imgWidth = size["width"].intValue
                        self.imgHeight = size["height"].intValue
                        return
                    }
                }
            }
           
            if json["copy_history"][0]["attachments"][0]["type"] == "photo" {
                for size in json["copy_history"][0]["attachments"][0]["photo"]["sizes"].arrayValue {
                    if size["type"] == "x" {
                        self.imgUrl = size["url"].stringValue
                        self.imgWidth = size["width"].intValue
                        self.imgHeight = size["height"].intValue
                        return
                    }
                }
            }
            
            if json["photos"]["items"].array != nil {
                for size in json["photos"]["items"][0]["sizes"].arrayValue {
                    if size["type"] == "x" {
                        self.imgUrl = size["url"].stringValue
                        self.imgWidth = size["width"].intValue
                        self.imgHeight = size["height"].intValue
                        return
                    }
                }
            }
            
            if json["attachments"][0]["type"] == "video" {
                for image in json["attachments"][0]["video"]["image"].arrayValue {
                    if image["width"] == 800 {
                        self.imgUrl = image["url"].stringValue
                        self.imgWidth = image["width"].intValue
                        self.imgHeight = image["height"].intValue
                        return
                    }
                }
            }
            
        }
    }
    struct NewsProfileJson {
        var id: Int
        var name: String
        var imageUrl: String?
        
        init(json: JSON){
            self.id = json["id"].intValue
            self.name = json["first_name"].stringValue + " " + json["last_name"].stringValue
            self.imageUrl = json["photo_50"].stringValue
        }
    }
    struct NewsGroupsJson {
        var id: Int
        var name: String
        var imageUrl: String?
        
        init(json: JSON){
            self.id = json["id"].intValue
            self.name = json["name"].stringValue
            self.imageUrl = json["photo_50"].stringValue
        }
    }
