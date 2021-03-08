//
//  NewsImageCell.swift
//  VKClient
//
//  Created by Константин Кузнецов on 13.01.2021.
//

import UIKit

class NewsImageCell: UITableViewCell, NewsConfigurable {

    @IBOutlet weak var postImage: UIImageView!

    func configure(item: NewsViewModel){
        postImage.image = item.image
    }
}
