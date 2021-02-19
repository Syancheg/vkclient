//
//  CustomInteractivTransiotion.swift
//  VKClient
//
//  Created by Константин Кузнецов on 13.11.2020.
//

import UIKit

class CustomInteractivTransiotion: UIPercentDrivenInteractiveTransition {

    var viewController: UIViewController? {
        didSet{
            let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(backPan))
            pan.edges = [.left]
            viewController?.view.addGestureRecognizer(pan)
        }
    }
    var hasStarted = false
    var finished = false
    
    @objc func backPan(_ pan: UIScreenEdgePanGestureRecognizer){
        switch pan.state {
        case .began:
            hasStarted = true
            viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = pan.translation(in: pan.view)
            let relTranslation = abs(translation.x / (pan.view?.bounds.width ?? 1))
            let progress = max(0, min(1, relTranslation)) * 10
            finished = progress > 0.33
            update(progress)
        case .ended:
            hasStarted = false
            finished ? finish() : cancel()
        case .cancelled:
            hasStarted = false
            cancel()
        default:
            return
        }
    }
    
}
