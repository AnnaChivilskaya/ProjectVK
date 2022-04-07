//
//  NewsViewController.swift
//  vkontakte
//
//  Created by Аня on 29.03.2022.
//

//import UIKit
//import Kingfisher
//
//class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        GetNews().loadData { [weak self] (complition) in
//            DispatchQueue.main.async {
//                self?.postNews = complition
//                self.tableView.reloadData()
//            }
//        }
//    }
//
//    var postNews: [PostNews] = []
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return postNews.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let identifier: String
//
//        let  cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! NewsTableViewCell
//
//
//        //Имя/Название
//        cell.NameNews.text = postNews[indexPath.row].name
//
//        //Дата
//        cell.TimeNews.text = postNews[indexPath.row].date
//        cell.TimeNews.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
//        cell.TimeNews.textColor = UIColor.gray.withAlphaComponent(0.5)
//
//
//
//    }
//
//}

