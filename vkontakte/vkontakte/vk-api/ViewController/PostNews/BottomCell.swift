//
//  BottomCell.swift
//  vkontakte
//
//  Created by Аня on 21.04.2022.
//

//import Foundation
//import UIKit
//
//class BottomCell: UITableViewCell {
//
//    @IBOutlet weak var likeGroup: UIButton!
//    @IBOutlet weak var commentsGroup: UIButton!
//    @IBOutlet weak var repostGroup: UIButton!
//    @IBOutlet weak var viewsGroups: UIButton!
//
//    @IBAction func buttonPress(_ sender: Any) {
//    }
//
//    func config(youLiked: Bool, numberLikes: Int, numberComments: Int, numberRepost: Int, numberViews: Int) {
//        if youLiked {
//            likeGroup.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//            likeGroup.setTitle("\(numberLikes)", for: .normal)
//            likeGroup.tintColor = .systemBlue
//        } else {
//            likeGroup.setImage(UIImage(systemName: "heart"), for: .normal)
//            likeGroup.setTitle("\(numberLikes)", for: .normal)
//            likeGroup.tintColor =  .darkGray
//        }
//
//        commentsGroup.setTitle("\(numberComments)", for: .normal)
//        repostGroup.setTitle("\(numberRepost)", for: .normal)
//        viewsGroups.setTitle("\(numberViews)", for: .normal)
//    }
//}
