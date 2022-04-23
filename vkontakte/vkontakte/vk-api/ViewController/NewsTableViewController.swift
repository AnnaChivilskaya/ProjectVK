//
//  NewsTableViewController.swift
//  vkontakte
//
//  Created by Аня on 21.04.2022.
//

//import UIKit
//
//class NewsTableViewController: UITableViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//    lazy var photoService = PhotoService(container: self.tableView)
//    var postNews: [News] = []
//    
//        func numberOfSections(in tableView: UITableView) -> Int {
//        return  postNews.count
//    }
//    
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let  post: String
//        
//        if postNews[indexPath.row].NewsText.isEmpty {
//            post = "ImageCell"
//        } else {
//            post = "PostCell"
//        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: post, for: indexPath) as! NewsTableViewCell
//        
//        //Аватарка группы
//        cell.avatarsGroup.avatarImage.image = photoService.photo(at: indexPath, url: postNews[indexPath.row].avatar)
//        
//        //Название группы
//        cell.nameGroup.text = postNews[indexPath.row].name
//        
//        //Дата поста
//        cell.dateGroup.text = postNews[indexPath.row].date
//        cell.dateGroup.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
//        cell.dateGroup.textColor = UIColor.gray.withAlphaComponent(0.5)
//        
//        //Кол-во лайков
//        cell.countLikes.countLikes = postNews[indexPath.row].likes
//        cell.countLikes.labelLikes.text = String(postNews[indexPath.row].likes)
//        
//        //Кол-во комментариев
//        cell.countComments.setTitle(String(postNews[indexPath.row].comments), for: .normal)
//        
//        //Кол-во репостов
//        cell.countReposts.setTitle(String(postNews[indexPath.row].reposts), for: .normal)
//        
//        //Кол-во просмотров на посте
//        cell.countViews.setTitle(String(postNews[indexPath.row].views), for: .normal)
//        
//        //Текст поста
//        if post == "PostCell"{
//            cell.textGroup.text = postNews[indexPath.row].NewsText
//        }
//        
//        //Картинка к посту
//        guard let imgUrl = URL(string: postNews[indexPath.row].textImage) else { return cell }
//        cell.imageGroup.image  = UIImage(systemName: "icloud.and.arrow.down")
//        cell.imageGroup.load(url: imgUrl)
//        cell.imageGroup.contentMode = .scaleAspectFit
//        
//        return cell
//    }
//}
//
//}
//
