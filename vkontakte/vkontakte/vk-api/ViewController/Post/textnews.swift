//
//  textnews.swift
//  vkontakte
//
//  Created by Аня on 30.03.2022.
//

import UIKit

class textnews: UITableViewCell {

 @IBOutlet weak var NewsText: UILabel!
    
    func textpost(textpost:  String) {
        self.NewsText.text = textpost
    }
    
}
