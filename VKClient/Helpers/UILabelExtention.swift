//
//  UILabelExtention.swift
//  VKClient
//
//  Created by Константин Кузнецов on 04.02.2021.
//

import UIKit

extension UILabel {

    func getHeight() -> CGFloat {
        var currentHeight: CGFloat!
        let label = UILabel(frame: CGRect(x: 0,
                                          y: 0,
                                          width: self.bounds.width,
                                          height: CGFloat.greatestFiniteMagnitude))
        label.text = self.text
        label.font = self.font
        label.numberOfLines = 0
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        currentHeight = label.frame.height
        label.removeFromSuperview()
        return currentHeight
    }

}
