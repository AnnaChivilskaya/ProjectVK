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

            let CloudPath = UIBezierPath()
            CloudPath.move(to: CGPoint(x: 10, y: 60))
            CloudPath.addQuadCurve(to: CGPoint(x: 20, y: 40), controlPoint: CGPoint(x: 5, y: 50))
            CloudPath.addQuadCurve(to: CGPoint(x: 40, y: 20), controlPoint: CGPoint(x: 20, y: 20))
            CloudPath.addQuadCurve(to: CGPoint(x: 70, y: 20), controlPoint: CGPoint(x: 55, y: 0))
            CloudPath.addQuadCurve(to: CGPoint(x: 90, y: 30), controlPoint: CGPoint(x: 85, y: 15))
            CloudPath.addQuadCurve(to: CGPoint(x: 110, y: 60), controlPoint: CGPoint(x: 110, y: 35))
            CloudPath.close()
            
    
            let CloudView = CAShapeLayer()
            CloudView.path = CloudPath.cgPath
            CloudView.strokeColor = UIColor.systemBlue.cgColor
            CloudView.lineWidth = 5
            CloudView.fillColor = UIColor.clear.cgColor
            CloudView.lineCap = .round
            
       
            self.layer.addSublayer(CloudView)
            
            let AnimationStart = CABasicAnimation(keyPath: "strokeStart")
            AnimationStart.beginTime = 0.5
            AnimationStart.fromValue = 0
            AnimationStart.toValue = 1
            AnimationStart.duration = 2
            
       
            let AnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
            AnimationEnd.fromValue = 0
            AnimationEnd.toValue = 1
            AnimationEnd.duration = 2
            
     
            let GroupAnimation = CAAnimationGroup()
            GroupAnimation.duration = 2.5
            GroupAnimation.fillMode = CAMediaTimingFillMode.backwards
            GroupAnimation.repeatCount = .infinity
            GroupAnimation.isRemovedOnCompletion = false
            GroupAnimation.animations = [AnimationStart, AnimationEnd]
            
            CloudView.add(GroupAnimation, forKey: nil)

        }

}
