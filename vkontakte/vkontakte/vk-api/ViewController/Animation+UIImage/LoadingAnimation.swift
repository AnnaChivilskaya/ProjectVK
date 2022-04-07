//
//  LoadingAnimation.swift
//  vkontakte
//
//  Created by Аня on 06.04.2022.
//

import UIKit
import Foundation

@IBDesignable class LoadingAnimation: UIView {

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupLoadingAnimationView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupLoadingAnimationView()
        }
    
    let circle1: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let circle2: UIView = UIView(frame: CGRect(x: 30, y: 0, width: 20, height: 20))
    let circle3: UIView = UIView(frame: CGRect(x: 60, y: 0, width: 20, height: 20))
        
        func setupLoadingAnimationView(){
            circle1.backgroundColor = .gray
            circle1.layer.cornerRadius = self.circle1.frame.width / 2
            circle2.backgroundColor = .gray
            circle2.layer.cornerRadius = self.circle2.frame.width / 2
            circle3.backgroundColor = .gray
            circle3.layer.cornerRadius = self.circle3.frame.width / 2
        
            UIView.animate(withDuration: 0.6, delay: 0.0, options: [.repeat, .autoreverse], animations: {self.circle1.alpha = 0})
            UIView.animate(withDuration: 0.6, delay: 0.2, options: [.repeat, .autoreverse], animations: {self.circle2.alpha = 0})
            UIView.animate(withDuration: 0.6, delay: 0.4, options: [.repeat, .autoreverse], animations: {self.circle3.alpha = 0})

            self.addSubview(circle1)
            self.addSubview(circle2)
            self.addSubview(circle3)
        }
}
