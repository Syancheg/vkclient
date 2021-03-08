//
//  UserViewModelFactory.swift
//  VKClient
//
//  Created by Константин Кузнецов on 01.03.2021.
//

import UIKit

final class UserViewModelFactory {
    
    func constructViewModels(from users: [NewUser]) -> [UserViewModel]{
        return users.compactMap(self.viewModel)
    }
    
    private func viewModel(from user: NewUser) -> UserViewModel{
        let name = "\(user.firstName) \(user.lastName)"
        let id = user.id
        
        if let image = UIImage.getImageForUrl(urlPath: user.avatarUrl){
            return UserViewModel(id: id, name: name, avatar: image)
        } else {
            return UserViewModel(id: id, name: name, avatar: UIImage())
        }
    }
}

