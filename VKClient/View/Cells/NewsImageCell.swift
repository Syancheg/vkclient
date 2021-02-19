//
//  NewsImageCell.swift
//  VKClient
//
//  Created by Константин Кузнецов on 13.01.2021.
//

import UIKit

class NewsImageCell: UITableViewCell, NewsConfigurable {

    @IBOutlet weak var postImage: UIImageView!

    func configure(item: News){
        guard let image = item.image?.imageUrl else {return}
        postImage.downloadImage(urlPath: image)
    }
}
