//
//  CustomNavigationController.swift
//  VKClient
//
//  Created by Константин Кузнецов on 13.11.2020.
//

import UIKit

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    let interactivePan = CustomInteractivTransiotion()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning?
    {
        if operation == .push{
            interactivePan.viewController = toVC
            return CustomPushAnimator()
        } else if operation == .pop {
            if navigationController.viewControllers.first != toVC {
                interactivePan.viewController = toVC
            }
            return CustomPopAnimator()
        }
        return nil
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        return interactivePan.hasStarted ? interactivePan : nil
    }
    


}
