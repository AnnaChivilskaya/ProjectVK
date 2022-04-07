//
//  SearchGroupService.swift
//  vkontakte
//
//  Created by Аня on 06.04.2022.
//

import Foundation

class SearchGroupService {
    
  
    func loadData(searchText:String, complition: @escaping ([Groups]) -> Void ) {
        
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.vk.com"
        url.path = "/method/groups.search"
        url.queryItems = [
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "type", value: "group"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.111")
        ]
        
  
        let task = session.dataTask(with: url.url!) { (data, response, error) in

            guard let data = data else { return }

            do {
                let arrayGroups = try JSONDecoder().decode(GroupsResponse.self, from: data)
                var searchGroupService: [Groups] = []
                
                for i in 0...arrayGroups.response.items.count-1 {
                    let name = ((arrayGroups.response.items[i].name))
                    let logo = arrayGroups.response.items[i].logo
                    let id = arrayGroups.response.items[i].id
                    searchGroupService.append(Groups.init(groupName: name, groupLogo: logo, id: id))
                }
                
                complition(searchGroupService)
            } catch let error {
                print(error)
                complition([])
            }
        }
        task.resume()
        
    }
    
}
