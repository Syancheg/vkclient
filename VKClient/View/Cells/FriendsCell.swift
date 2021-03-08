//
//  FriendsCell.swift
//  VKClient
//
//  Created by Константин Кузнецов on 18.10.2020.
//

import UIKit

class FriendsCell: UITableViewCell {

    @IBOutlet weak var friendsNameLabel: UILabel!
    @IBOutlet weak var avatarView: AvatarView!
    
    func configure(with viewModel: UserViewModel){
        friendsNameLabel.text = viewModel.name
        avatarView.image = viewModel.avatar
    }
}
