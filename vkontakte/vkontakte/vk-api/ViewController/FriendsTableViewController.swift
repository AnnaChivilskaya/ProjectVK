//
//  FriendsTableViewController.swift
//  vkontakte
//
//  Created by Аня on 06.04.2022.
//

import UIKit
import Kingfisher
import RealmSwift

class FriendsTableViewController: UITableViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       subscribeToNotificationRealm()
        
//       GetFriends().loadData()
        
        FriendsPromiseKit().getData()
        searchBar.delegate = self
    }
    
    var realm: Realm = {
        let configrealm = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: configrealm)
        return realm
    }()
    
    lazy var friendsFromRealm: Results<Friends> = {
        return realm.objects(Friends.self)
    }()
    
    var notificationToken: NotificationToken?
    
    var friendsList: [Friends] = []
    var namesListFixed: [String] = []
    var namesListModifed: [String] = []
    var letersOfNames: [String] = []
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return letersOfNames.count
    }
    
  
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        let leter: UILabel = UILabel(frame: CGRect(x: 30, y: 5, width: 20, height: 20))
        leter.textColor = UIColor.black.withAlphaComponent(0.5)
        leter.text = letersOfNames[section]
        leter.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        header.addSubview(leter)
        
        return header
    }
    
  
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return letersOfNames
    }
    
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countOfRows = 0

        for name in namesListModifed {
            if letersOfNames[section].contains(name.first!) {
                countOfRows += 1
            }
        }
        return countOfRows
    }
    
    class FriendsUITableViewCell: UITableViewCell {
        
        @IBOutlet weak var avatarFriendView: Avatars!
        @IBOutlet weak var nameFriendLabel: UILabel!
        @IBOutlet weak var searchBar: UISearchBar!
        
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsUITableViewCell
        
        let friendInfo = getFriendInfoForCell(indexPath)
        
        
        cell.nameFriendLabel.text = friendInfo.name
        
       
        guard let imgUrl = friendInfo.avatar else { return cell }
        let avatar = ImageResource(downloadURL: imgUrl)
        cell.avatarFriendView.avatarImage.kf.indicatorType = .activity
        cell.avatarFriendView.avatarImage.kf.setImage(with: avatar)
        
        
        return cell
    }
    
    private func subscribeToNotificationRealm() {
        notificationToken = friendsFromRealm.observe { [weak self] (changes) in
            switch changes {
            case .initial:
                self?.loadFriendsFromRealm()

            case .update:
                self?.loadFriendsFromRealm()
            case let .error(error):
                print(error)
            }
        }
    }
    
    func loadFriendsFromRealm() {
        friendsList = Array(friendsFromRealm).sorted{ $0.userName < $1.userName }
        guard friendsList.count != 0 else { return }
        makeNamesList()
        sortCharacterOfNamesAlphabet()
        tableView.reloadData()
    }
    

    func makeNamesList() {
        namesListFixed.removeAll()
        for item in 0...(friendsList.count - 1){
            namesListFixed.append(friendsList[item].userName)
        }
        namesListModifed = namesListFixed
    }
    
   
    func sortCharacterOfNamesAlphabet() {
        var letersSet = Set<Character>()
        letersOfNames = []
        
  
        for name in namesListModifed {
            letersSet.insert(name[name.startIndex])
        }
        
        
        for leter in letersSet.sorted() {
            letersOfNames.append(String(leter))
        }
    }
    
    func getFriendInfoForCell(_ indexPath: IndexPath) -> (name: String, avatar: URL?, ownerID: String) {
        var friendInfo: [(name: String, avatar: URL?, ownerID: String)] = []
        let letter = letersOfNames[indexPath.section]
        
        for friend in friendsList {
            if letter.contains(friend.userName.first!){
                let name = friend.userName
                let avatar = URL(string: friend.userAvatar)
                let ownerID = friend.ownerID
                
                friendInfo.append((name, avatar, ownerID))
            }
        }
        
        return friendInfo[indexPath.row]
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        namesListModifed = searchText.isEmpty ? namesListFixed : namesListFixed.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        sortCharacterOfNamesAlphabet()
        tableView.reloadData()
    }
    

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        makeNamesList()
        sortCharacterOfNamesAlphabet()
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto"{
           
            guard let friend = segue.destination as? PhotosViewController else { return }
            
           
            if let indexPath = tableView.indexPathForSelectedRow {
                let friendInfo = getFriendInfoForCell(indexPath)
                friend.title = friendInfo.name
                friend.ownerID = friendInfo.ownerID
            }
        }
    }
    
    
}
