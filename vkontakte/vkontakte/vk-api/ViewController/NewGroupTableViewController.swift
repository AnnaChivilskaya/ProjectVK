//
//  NewGroupTableViewController.swift
//  vkontakte
//
//  Created by Аня on 06.04.2022.
//

import UIKit
import Kingfisher

class NewGroupTableViewController: UITableViewController, UISearchResultsUpdating {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }

    var searchController:UISearchController!
    var GroupsView: [Groups] = []
    lazy var photoService = PhotoService(container: self.tableView)
    
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Поиск"
    
        tableView.tableHeaderView = searchController.searchBar
        searchController.obscuresBackgroundDuringPresentation = false
        
       
        searchController.isActive = true
        DispatchQueue.main.async {
          self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func searchGroupVK(searchText: String) {
        
        SearchGroupService().loadData(searchText: searchText) { [weak self] (complition) in
            DispatchQueue.main.async {
             
                self?.GroupsView = complition
                self?.tableView.reloadData()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            searchGroupVK(searchText: searchText)
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupsView.count
    }
    
    class NewGroupUITableViewCell: UITableViewCell {
        
        @IBOutlet weak var nameNewGroupLabel: UILabel!
        @IBOutlet weak var createNewGroup: UIButton!
        @IBOutlet weak var avatarNewGroupView: Avatars!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddGroup", for: indexPath)  as! NewGroupUITableViewCell

        cell.nameNewGroupLabel.text = GroupsView[indexPath.row].groupName
        
        if let imgUrl = URL(string: GroupsView[indexPath.row].groupLogo) {
            cell.avatarNewGroupView.avatarImage.load(url: imgUrl)
        
        let imgUrl = GroupsView[indexPath.row].groupLogo
        cell.avatarNewGroupView.avatarImage.image = photoService.photo(at: indexPath, url: imgUrl)
        }

        return cell
    }
    
    //Избавление смешивания цветов меняем при  нажатии
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! NewGroupUITableViewCell
        cell.nameNewGroupLabel.backgroundColor = cell.backgroundColor
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
