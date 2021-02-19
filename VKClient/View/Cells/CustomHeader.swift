//
//  CustomHeader.swift
//  VKClient
//
//  Created by Константин Кузнецов on 02.11.2020.
//

import UIKit

class CustomHeader: UITableViewHeaderFooterView {
    
    static let nib = UINib(nibName: "CustomHeader", bundle: nil)
    static let reuseId = "CustomHeader"

    @IBOutlet weak var textLabet: UILabel!
     
}
