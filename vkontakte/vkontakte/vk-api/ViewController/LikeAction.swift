//
//  LikeAction.swift
//  vkontakte
//
//  Created by Аня on 22.04.2022.
//

import UIKit

@IBDesignable class LikeAction: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        ActionLike()
    }
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        ActionLike()
    }
    
    var countLikes = 0
    var youLiked = false
    
    @IBInspectable var noLike: UIColor = UIColor.white {
        didSet {
            likeImgView.tintColor = noLike
            labelLikes.textColor = noLike
        }
    }
    @IBInspectable var colorYesLike: UIColor = UIColor.red
    
    let likeImgView = UIImageView(image: UIImage(systemName: "heart"))
   let labelLikes = UILabel(frame: CGRect(x: 23, y: -1, width: 40, height: 20))
    
   func ActionLike() {
      
        likeImgView.tintColor = noLike
        likeImgView.layer.shadowColor = UIColor.gray.cgColor
        likeImgView.layer.shadowOpacity = 0.9
        likeImgView.layer.shadowRadius = 10
        likeImgView.layer.shadowOffset = CGSize.zero
  
        labelLikes.text = String(countLikes)
        labelLikes.textColor = noLike
        labelLikes.font = .systemFont(ofSize: 18)

        self.addSubview(likeImgView)
        self.addSubview(labelLikes)
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
       let original = self.likeImgView.transform
        UIView.animate(withDuration: 0.1, delay: 0, options: [ .autoreverse], animations: {
            self.likeImgView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            self.likeImgView.transform = original
        })
        
        if youLiked {
            youLiked = false
            countLikes -= 1
            labelLikes.text = String(countLikes)
            labelLikes.textColor = noLike
            likeImgView.tintColor = noLike
            likeImgView.image =  UIImage(systemName: "heart")
        } else {
            youLiked = true
            countLikes += 1
            labelLikes.text = String(countLikes)
            labelLikes.textColor = colorYesLike
            likeImgView.tintColor = colorYesLike
            likeImgView.image =  UIImage(systemName: "heart.fill")
        }
        return false
    }
}
