//
//  NewsTableViewController.swift
//  vkontakte
//
//  Created by Аня on 21.04.2022.
//

import UIKit

class NewsTableViewController: UITableViewController, UITableViewDataSourcePrefetching {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        //Указываем, что мы делегат
        tableView.prefetchDataSource = self
    }
    
    lazy var newsJson = NewsJson()
    lazy var photoService = PhotoService(container: self.tableView)
    var postNews: [News] = []
    
    var nextFrom = ""
    var isLoading = false
    
    let dateFormatter: DateFormatter =  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter
    }()
    
    func loadNewsView() {
        
        newsJson.get { [weak self] (news, nextFrom) in
            self?.postNews = news
            self?.nextFrom = nextFrom
        }
    }
    
   
    //Свайп вниз для обновления ленты новостей
    fileprivate func setupRefreshControl() {
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Загрузка")
        refreshControl?.tintColor = .darkGray
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc func refreshNews() {
        //Начинаем обновление новостей
        if let dateFrom = postNews.first?.date {
            let time = dateFormatter.date(from: dateFrom)?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
            
            newsJson.get(newsFrom: time + 1)  { [weak self] (news, _) in
                guard let self = self else { return }
                //Провееряем,что более свежиие новости действительно есть
                guard news.count > 0 else { return }
                
                self.postNews = news + self.postNews
                
                //Добавление новых ячееек в начало
                let indexSet = (0..<news.count)
                    .map { IndexPath(row: $0, section: 0) }
                self.tableView.insertRows(at: indexSet, with: .automatic)
            }
            
        }
        
        self.refreshControl?.endRefreshing()
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight: CGFloat
        
        if postNews[indexPath.row].NewsText.isEmpty {
            let imageHeight =  tableView.bounds.width * postNews[indexPath.row].aspect
            cellHeight = 119 + ceil(imageHeight)
        } else {
            cellHeight = UITableView.automaticDimension
        }
        return  cellHeight
    }
    
    //Загрузка доп новостей в конце ленты
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard
            isLoading == false,
            //Выбираемм максимальный номер секции, которую нужно будет отоборазить в ближайшее время
            let maxSection = indexPaths.map({$0.row}).max(),
            // Проверяем, является  ли эта секция из трех ближайших к концу
            maxSection > (postNews.count - 3)
        else { return }
            
        //Начинаем загрузку данных и меняем флаг
        isLoading = true
        
        newsJson.get(nextPageNews: nextFrom) { [weak self] (news, nextFrom) in
            guard let self = self else { return }
            
            let newsCount = self.postNews.count
            self.postNews.append(contentsOf: news)
            
            //Прикрепляем  новости к существующим новостям
            let indexSet = (newsCount..<(newsCount + news.count))
                .map { IndexPath(row: $0, section: 0)}
            
            //Обновляем таблицу
            self.tableView.insertRows(at: indexSet, with: .automatic)
            self.nextFrom  = nextFrom
            //Включаем статус флага
            self.isLoading = false
        }
    }
    
    
    
        override func numberOfSections(in tableView: UITableView) -> Int {
        return  postNews.count
    }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  post: String
        
        if postNews[indexPath.row].NewsText.isEmpty {
            post = "ImageCell"
        } else {
            post = "PostCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: post, for: indexPath) as! NewsTableViewCell
        
        //Аватарка группы
        cell.avatarsGroup.avatarImage.image = photoService.photo(at: indexPath, url: postNews[indexPath.row].avatar)
        
        //Название группы
        cell.nameGroup.text = postNews[indexPath.row].name
        
        //Дата поста
        cell.dateGroup.text = postNews[indexPath.row].date
        cell.dateGroup.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        cell.dateGroup.textColor = UIColor.gray.withAlphaComponent(0.5)
        
        //Кол-во лайков
        cell.countLikes.countLikes = postNews[indexPath.row].likes
        cell.countLikes.labelLikes.text = String(postNews[indexPath.row].likes)
        
        //Кол-во комментариев
        cell.countComments.setTitle(String(postNews[indexPath.row].comments), for: .normal)
        
        //Кол-во репостов
        cell.countReposts.setTitle(String(postNews[indexPath.row].reposts), for: .normal)
        
        //Кол-во просмотров на посте
        cell.countViews.setTitle(String(postNews[indexPath.row].views), for: .normal)
        
        //Текст поста
        if post == "PostCell"{
            cell.textGroup.text = postNews[indexPath.row].NewsText
            cell.buttonShowMore()
            
            cell.textGroup.sizeToFit()
            let heightText = cell.textGroup.frame.size.height
            
            cell.textGroup.adjustUITextViewHeight()
            cell.showMore.setTitle(" Показать полностью...", for: .normal)
            
        } else {
            cell.showMore.isHidden = true
        }
        
        //Картинка к посту
        guard let imgUrl = URL(string: postNews[indexPath.row].textImage) else { return cell }
        cell.imageGroup.image  = UIImage(systemName: "person.3")
        cell.imageGroup.load(url: imgUrl)
        cell.imageGroup.contentMode = .scaleAspectFit
        
        return cell
    }
}



