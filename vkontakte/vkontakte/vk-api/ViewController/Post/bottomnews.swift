//
//  bottompost.swift
//  vkontakte
//
//  Created by Аня on 30.03.2022.
//

import UIKit
import Foundation

class bottomnews: UITableViewCell {

    @IBOutlet weak var LikeButton: UIButton!
    @IBOutlet weak var Commentsbutton: UIButton!
    @IBOutlet weak var Repostbutton: UIButton!
    @IBOutlet weak var ViewButton: UIButton!

    var numberLike: Int = 0
    var numberComments: Int = 0
    var numberViews: Int = 0
    var numberRepost: Int = 0


    @IBAction func PressedLike(_ sender: Any) {

        var YouLike: Bool = false

        if (YouLike == true) == true {
            numberLike += 1
        } else if (YouLike == false) == true {
            numberLike = 0
      }
    }

    @IBAction func PreessedComments(_ sender: Any) {

        var YouComment: Bool = false

        if (YouComment == true) == true {
            numberComments += 1
        }  else if  (YouComment == false) ==  true {
            numberComments = 0
        }
    }

    @IBAction func PressedRepost(_ sender: Any) {

        var YouRepost: Bool = false

        if (YouRepost == true) == true {
            numberRepost += 1
        }  else if  (YouRepost == false) ==  true {
            numberRepost = 0
        }
    }


    @IBAction func Viewtf(_ sender: Any) {

        var YouViews: Bool = false

        if (YouViews  == true) == true {
            numberViews += 1
        } else if (YouViews == false) == true {
        }
    }
}
