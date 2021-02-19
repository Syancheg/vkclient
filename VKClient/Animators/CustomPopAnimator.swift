//
//  CustomPopAnimator.swift
//  VKClient
//
//  Created by Константин Кузнецов on 13.11.2020.
//

import UIKit

final class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let sourse = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to)
            else { return }
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = sourse.view.frame
        destination.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        destination.view.layer.position = CGPoint(x: 0, y: 0)
        destination.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        sourse.view.layer.position = CGPoint(x: sourse.view.frame.width, y: 0)
        sourse.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        
        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [],
            animations: {
            
            UIView.addKeyframe(
                withRelativeStartTime: 0,
                relativeDuration: 1,
                animations: {
                    sourse.view.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 2))
                }
            )
            UIView.addKeyframe(
                withRelativeStartTime: 0,
                relativeDuration: 1,
                animations: {
                    destination.view.transform = .identity
                }
            )
                
            
        }, completion: { finished in
            let finishedAndNotCanceled = finished && !transitionContext.transitionWasCancelled
            if finishedAndNotCanceled {
                sourse.view.transform = .identity
            }
            transitionContext.completeTransition(finishedAndNotCanceled)
        })

        
    }
    
}
