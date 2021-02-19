//
//  LoaderCloud.swift
//  VKClient
//
//  Created by Константин Кузнецов on 10.11.2020.
//

import UIKit

class LoaderCloud: UIView {

    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: // Animations
    
    func setup(){
        let cloudLayer = CAShapeLayer()
        cloudLayer.fillColor = UIColor.clear.cgColor
        let cloudPath = UIBezierPath()
        cloudLayer.strokeColor = UIColor.orange.cgColor
        cloudLayer.lineWidth = 5
        cloudLayer.lineCap = .round
        cloudLayer.miterLimit = 5
        cloudPath.move(to: CGPoint(x: 0, y: 100))
        cloudPath.addLine(to: CGPoint(x:100, y: 100))
        cloudPath.addArc(withCenter: CGPoint(x:90, y: 85),
                        radius: 20,
                        startAngle: CGFloat.pi * 0.2,
                        endAngle: 3 * CGFloat.pi / 2,
                        clockwise: false)
        cloudPath.addArc(withCenter: CGPoint(x:65, y: 60),
                        radius: 25,
                        startAngle: CGFloat.pi * 0.2,
                        endAngle: CGFloat.pi,
                        clockwise: false)
        cloudPath.addArc(withCenter: CGPoint(x:40, y:80),
                        radius: 20,
                        startAngle: 3 * CGFloat.pi / 2,
                        endAngle: CGFloat.pi,
                        clockwise: false)
        cloudPath.addArc(withCenter: CGPoint(x:20, y: 100),
                        radius: 20,
                        startAngle: 3 * CGFloat.pi / 2,
                        endAngle: CGFloat.pi,
                        clockwise: false)
        cloudPath.close()
        cloudPath.stroke()
        cloudLayer.path = cloudPath.cgPath
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1.7

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2
        animationGroup.repeatCount = .infinity
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        cloudLayer.add(animationGroup, forKey: nil)
        let cloudView = UIView(frame: CGRect(x: center.x - 50, y: center.y - 80, width: 100, height: 100))
        cloudView.layer.addSublayer(cloudLayer)
        addSubview(cloudView)
    }

}
