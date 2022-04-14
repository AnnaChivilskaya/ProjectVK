//
//  GetFriendsOperations.swift
//  vkontakte
//
//  Created by Аня on 11.04.2022.
//

import Foundation
import RealmSwift

final class GroupsOperations {
    
    var opQueue = OperationQueue()
    
    func getData() {
        
        let loadJSON = LoadJsonData()
        let parsData = ParsingData()
        let saveData = SaveData()
        
        parsData.addDependency(loadJSON)
        saveData.addDependency(parsData)
        let operation = [loadJSON, parsData, saveData]
        opQueue.addOperations(operation, waitUntilFinished: false)
    }
    
            final class LoadJsonData: AsyncOperations {
                var jsonVk: Data?
                var errorVk: Error?
                override func main() {
                    
                    let configuration = URLSessionConfiguration.default
                    let session =  URLSession(configuration: configuration)
                     
                    var urlConstructor = URLComponents()
                     urlConstructor.scheme = "https"
                     urlConstructor.host = "api.vk.com"
                     urlConstructor.path = "/method/groups.get"
                     urlConstructor.queryItems = [
                         URLQueryItem(name: "user_id", value: String(Session.instance.userId)),
                         URLQueryItem(name: "extended", value: "1"),
                         URLQueryItem(name: "access_token", value: Session.instance.token),
                         URLQueryItem(name: "v", value: "5.131")
                     ]
                    
                    let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
                        
                        guard let data = data else { return }
                        
                        self.jsonVk = data
                        self.errorVk = error
                        self.state = .finished
                }
                    task.resume()
            }
    }
    
    final class ParsingData: Operation {
        var dataJson: [Groups]?
        var errorJson: Error?

        override func main() {
            guard
            let operation = dependencies.first as? LoadJsonData,
            let data = operation.jsonVk
            else { return }

            do {
                let arrayGroups = try JSONDecoder().decode(GroupsResponse.self, from: data)
                var groupList: [Groups] = []
                for index in 0...arrayGroups.response.items.count-1 {
                    let name = ((arrayGroups.response.items[index].name))
                    let logo = arrayGroups.response.items[index].logo
                    let id = arrayGroups.response.items[index].id
                    groupList.append(Groups.init(groupName: name, groupLogo: logo, id: id))
                }

                dataJson = groupList
                }
            catch let error {
                errorJson = error
            }
            }

        }
    
    final class SaveData: Operation {
        override func main() {
            guard
                let operation = dependencies.first as? ParsingData,
                let data = operation.dataJson
                else { return }
            DispatchQueue.main.async {
                Realms().SaveGroupsToRealm(data)
            }
                        }
                    }
}

