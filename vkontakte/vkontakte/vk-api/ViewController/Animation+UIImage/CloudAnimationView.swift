//
//  CloudAnimationView.swift
//  vkontakte
//
//  Created by Аня on 06.04.2022.
//

import UIKit

@IBDesignable class CloudAnimationView: UIView {

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupCloudAnimationView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupCloudAnimationView()
        }
        
        func setupCloudAnimationView(){

            let cloudPath = UIBezierPath()
            cloudPath.move(to: CGPoint(x: 10, y: 60))
            cloudPath.addQuadCurve(to: CGPoint(x: 20, y: 40), controlPoint: CGPoint(x: 5, y: 50))
            cloudPath.addQuadCurve(to: CGPoint(x: 40, y: 20), controlPoint: CGPoint(x: 20, y: 20))
            cloudPath.addQuadCurve(to: CGPoint(x: 70, y: 20), controlPoint: CGPoint(x: 55, y: 0))
            cloudPath.addQuadCurve(to: CGPoint(x: 90, y: 30), controlPoint: CGPoint(x: 85, y: 15))
            cloudPath.addQuadCurve(to: CGPoint(x: 110, y: 60), controlPoint: CGPoint(x: 110, y: 35))
            cloudPath.close()
            
    
            let cloudView = CAShapeLayer()
            cloudView.path = cloudPath.cgPath
            cloudView.strokeColor = UIColor.systemBlue.cgColor
            cloudView.lineWidth = 5
            cloudView.fillColor = UIColor.clear.cgColor
            cloudView.lineCap = .round
            
       
            self.layer.addSublayer(cloudView)
            
            let animationView = CABasicAnimation(keyPath: "strokeStart")
            animationView.beginTime = 0.5
            animationView.fromValue = 0
            animationView.toValue = 1
            animationView.duration = 2
            
       
            let AnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
            AnimationEnd.fromValue = 0
            AnimationEnd.toValue = 1
            AnimationEnd.duration = 2
            
     
            let groupAnimation = CAAnimationGroup()
            groupAnimation.duration = 2.5
            groupAnimation.fillMode = CAMediaTimingFillMode.backwards
            groupAnimation.repeatCount = .infinity
            groupAnimation.isRemovedOnCompletion = false
            groupAnimation.animations = [animationView, AnimationEnd]
            
            cloudView.add(groupAnimation, forKey: nil)

        }

}
