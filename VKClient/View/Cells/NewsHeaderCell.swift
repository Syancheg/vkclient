//
//  NewsHeaderCell.swift
//  VKClient
//
//  Created by Константин Кузнецов on 13.01.2021.
//

import UIKit

class NewsHeaderCell: UITableViewCell, NewsConfigurable {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(item: News){
        avatarView.downloadImage(urlPath: item.avatar)
        avatarView.layer.cornerRadius = avatarView.frame.width / 2
        dateLabel.text = item.date
        nameLabel.text = item.name
    }

}
