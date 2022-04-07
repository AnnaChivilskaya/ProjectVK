//
//  GroupsViewController.swift
//  vkontakte
//
//  Created by Аня on 01.02.2022.
//

import UIKit
import Kingfisher
import RealmSwift

class GroupsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        subscribeToNotificationRealm()

        GetGroups().loadData()
    }
    
    var realm: Realm = {
        let configrealm = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: configrealm)
        return realm
    }()
    
    lazy var groupsFromRealm: Results<Groups> = {
        return realm.objects(Groups.self)
    }()
    
    var notificationToken: NotificationToken?
    
    var myGroups: [Groups] = []

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups.count
    }
    
    class GroupsUITableViewCell:  UITableViewCell  {
        
        @IBOutlet weak var nameGroupLabel: UILabel!
        @IBOutlet weak var avatarGroupView: Avatars!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as! GroupsUITableViewCell
        
        cell.nameGroupLabel.text = myGroups[indexPath.row].groupName
        
        if let imgUrl = URL(string: myGroups[indexPath.row].groupLogo) {
            let avatar = ImageResource(downloadURL: imgUrl)
            cell.avatarGroupView.avatarImage.kf.indicatorType = .activity
            cell.avatarGroupView.avatarImage.kf.setImage(with: avatar)
            
    
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            do {
                try realm.write{
                    realm.delete(groupsFromRealm.filter("groupName == %@", myGroups[indexPath.row].groupName))
                }
            } catch {
                print(error)
            }
            
        }
    }
    
    private func subscribeToNotificationRealm() {
        notificationToken = groupsFromRealm.observe { [weak self] (changes) in
            switch changes {
            case .initial:
                self?.loadGroupsFromRealm()
           
            case .update:
                self?.loadGroupsFromRealm()

            case let .error(error):
                print(error)
            }
        }
    }
    
    func loadGroupsFromRealm() {
            myGroups = Array(groupsFromRealm)
            guard groupsFromRealm.count != 0 else { return }
            tableView.reloadData()
    }
    
   
        @IBAction func addNewGroup(segue:UIStoryboardSegue) {
           
            if segue.identifier == "AddGroup"{
                
                guard let newGroupFromController = segue.source as? NewGroupTableViewController else { return }
               
                if let indexPath = newGroupFromController.tableView.indexPathForSelectedRow {
                    let newGroup = newGroupFromController.GroupsView[indexPath.row]
                    
                    guard myGroups.description.contains(newGroup.groupName) == false else { return }
                    
                  
                    do {
                        try realm.write{
                            realm.add(newGroup)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    

}
