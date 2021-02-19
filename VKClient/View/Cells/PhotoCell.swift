//
//  PhotoCell.swift
//  VKClient
//
//  Created by Константин Кузнецов on 18.10.2020.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoFriends: UIImageView!
    @IBOutlet weak var likeControl: LikeControl!
    
    @IBAction func likeControlChanged(_ sender: LikeControl) {
        print(#function)
    }
    
}
