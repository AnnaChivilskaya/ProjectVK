//
//  NewsTableViewCell.swift
//  vkontakte
//
//  Created by Аня on 22.04.2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameGroup: UILabel!
    @IBOutlet weak var avatarsGroup: Avatars!
    @IBOutlet weak var textGroup: UITextView!
    @IBOutlet weak var dateGroup: UILabel!
    @IBOutlet weak var imageGroup: UIImageView!
    @IBOutlet weak var countLikes: LikeAction!
    @IBOutlet weak var countComments: UIButton!
    @IBOutlet weak var countViews: UIButton!
    @IBOutlet weak var countReposts: UIButton!
    @IBOutlet weak var showMore: UIButton!
    
    @IBAction  func showMore(_ sender: Any) {
        
        let size = textGroup.frame.size.height
        if size <= 200.5 {
            textGroup.adjustUITextViewHeight()
            showMore.setTitle("Свернуть", for: .normal)
        } else {
            textGroup.adjustUITextViewHeightDefault()
            showMore.setTitle("Показать полностью...", for: .normal)
        }
    }
    
    func buttonShowMore() {
        showMore.isHidden = false
        showMore.setTitle("Показать полностью...", for: .normal)
    }
}
    
extension UITextView {
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
    }
    
    func adjustUITextViewHeightDefault() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
