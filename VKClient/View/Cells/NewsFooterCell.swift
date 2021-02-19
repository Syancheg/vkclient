//
//  NewsFooterCell.swift
//  VKClient
//
//  Created by Константин Кузнецов on 13.01.2021.
//

import UIKit

class NewsFooterCell: UITableViewCell, NewsConfigurable {

    @IBOutlet weak var viewsButton: UIButton!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var repostButton: UIButton!
    
    func configure(item: News){
        viewsButton.setTitle("\(item.views)", for: .normal)
        likesButton.setTitle("\(item.likes)", for: .normal)
        commentButton.setTitle("\(item.comments)", for: .normal)
        repostButton.setTitle("\(item.reposts)", for: .normal)
    }

}
