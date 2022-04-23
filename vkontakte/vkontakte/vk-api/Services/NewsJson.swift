//
//  GetNewsJson.swift
//  vkontakte
//
//  Created by Аня on 22.04.2022.
//

//import Foundation
//import SwiftyJSON
//
//struct NewsResponseJson {
//    var sourceID: Int
//    var authorName: String?
//    var authorAvatarUrl: String?
//    var date: Double
//    var text: String
//    var likes: Int
//    var comments: Int
//    var reposts: Int
//    var views: Int
//    var imgUrl = ""
//
//    init(json: JSON){
//        self.sourceID = json["source_id"].intValue
//        self.date = json["date"].doubleValue
//        self.text = json["text"].stringValue
//        self.likes = json["likes"]["count"].intValue
//        self.comments = json["comments"]["count"].intValue
//        self.reposts = json["reposts"]["count"].intValue
//        self.views = json["views"]["count"].intValue
//
//      //Ссылка
//        if json["attachments"][0]["type"] == "link" {
//            for size in json["attachments"][0]["link"]["photo"]["sizes"].arrayValue {
//                if size["type"] == "l" {
//                    self.imgUrl = size["url"].stringValue
//                }
//            }
//        }
//
//     //Фото
//        if json["attachments"][0]["type"] == "photo" {
//            for size in json["attachments"][0]["photo"]["sizes"].arrayValue {
//                if size["type"] == "x" {
//                    self.imgUrl = size["url"].stringValue
//                }
//            }
//        }
//
//       //Видео
//        if json["attachments"][0]["type"] == "video" {
//            for image in json["attachments"][0]["video"]["image"].arrayValue {
//                if image["width"] == 800 {
//                    self.imgUrl = image["url"].stringValue
//                }
//            }
//        }
//
//    }
//}
//
//struct NewsResponseProfileJson {
//    var id: Int
//    var name: String
//    var imageUrl: String?
//
//    init(json: JSON){
//        self.id = json["id"].intValue
//        self.name = json["first_name"].stringValue + " " + json["last_name"].stringValue
//        self.imageUrl = json["photo_50"].stringValue
//    }
//}
//
//struct NewsResponseGroupJson {
//    var id: Int
//    var name: String
//    var imageUrl: String?
//
//    init(json: JSON){
//        self.id = json["id"].intValue
//        self.name = json["name"].stringValue
//        self.imageUrl = json["photo_50"].stringValue
//    }
//}
//
//
//final class GetNewsJson {
//
//    func get (comlition: @escaping ([News]) -> Void){
//
//        DispatchQueue.global(qos: .userInitiated).async {
//
//
//            let configuration = URLSessionConfiguration.default
//            let session =  URLSession(configuration: configuration)
//
//
//            var urlConstructor = URLComponents()
//            urlConstructor.scheme = "https"
//            urlConstructor.host = "api.vk.com"
//            urlConstructor.path = "/method/newsfeed.get"
//            urlConstructor.queryItems = [
//                URLQueryItem(name: "owner_id", value: String(Session.instance.userId)),
//                URLQueryItem(name: "access_token", value: Session.instance.token),
//                URLQueryItem(name: "filters", value: "post,photo"),
//                URLQueryItem(name: "count", value: "10"),
//                URLQueryItem(name: "v", value: "5.131")
//            ]
//
//
//            let task = session.dataTask(with: urlConstructor.url!) { [weak self] (data, _, error) in
//
//
//                if let error = error {
//                    print("Error in GetNewsJson: \(error.localizedDescription)")
//                    DispatchQueue.main.async {
//                        comlition([])
//                    }
//                    return
//                }
//
//                let newsItems = self?.parsed(data) ?? []
//                DispatchQueue.main.async {
//                    comlition(newsItems)
//                }
//
//            }
//            task.resume()
//        }
//    }
//
//    func parsed(_ data: Data?) -> [News] {
//        guard let data = data else { return [] }
//
//        do {
//
//            let json = try JSON(data: data)
//
//            let items = json["response"]["items"]
//                .arrayValue
//                .map { NewsResponseJson(json: $0) }
//
//            let profiles = json["response"]["profiles"]
//                .arrayValue
//                .map { NewsResponseProfileJson(json: $0) }
//
//            let groups = json["response"]["groups"]
//                .arrayValue
//                .map { NewsResponseGroupJson(json: $0) }
//
//            return makeNews(items, profiles, groups)
//
//        } catch {
//            print(error)
//            return []
//        }
//    }
//
//    func makeNews(_ items: [NewsResponseJson],
//                      _ profiles: [NewsResponseProfileJson],
//                      _ groups: [NewsResponseGroupJson]) -> [News] {
//
//        var news: [News] = []
//
//            for item in items {
//
//                var newItems = News(name: "", avatar: "", date: "", NewsText: item.text, textImage: item.imgUrl, likes: item.likes, comments: item.comments, reposts: item.reposts, views: item.views)
//
//                newItems.date = self.getDateText(timestamp: item.date)
//
//                if item.sourceID > 0 {
//                    let profile = profiles
//                        .filter({ item.sourceID == $0.id })
//                        .first
//                    newItems.name = profile?.name ?? ""
//                    newItems.avatar = profile?.imageUrl ?? ""
//                } else {
//                    let group = groups
//                        .filter({ abs(item.sourceID) == $0.id })
//                        .first
//                    newItems.name = group?.name ?? ""
//                    newItems.avatar = group?.imageUrl ?? ""
//                }
//                news.append(newItems)
//            }
//        return news
//    }
//
//    let dateFormatter: DateFormatter = {
//        let df = DateFormatter()
//        df.dateFormat = "dd.MM.yyyy HH.mm"
//        return df
//    }()
//
//    func getDateText(timestamp: Double) -> String {
//        let date = Date(timeIntervalSince1970: timestamp)
//        let stringDate = dateFormatter.string(from: date)
//        return stringDate
//    }
//
//}
