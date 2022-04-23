//
//  NewsTableViewCell.swift
//  vkontakte
//
//  Created by Аня on 22.04.2022.
//

import Foundation
import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameGroup: UILabel!
    @IBOutlet weak var avatarsGroup: Avatars!
    @IBOutlet weak var textGroup: UILabel!
    @IBOutlet weak var dateGroup: UILabel!
    @IBOutlet weak var imageGroup: UIImageView!
    @IBOutlet weak var countLikes: LikeAction!
    @IBOutlet weak var countComments: UIButton!
    @IBOutlet weak var countViews: UIButton!
    @IBOutlet weak var countReposts: UIButton!
}
