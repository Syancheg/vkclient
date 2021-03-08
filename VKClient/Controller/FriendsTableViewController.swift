//
//  FriendsTableViewController.swift
//  VKClient
//
//  Created by Константин Кузнецов on 18.10.2020.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UIViewController, FriendsViewDelegate {
    
    //MARK: - Propertires
    
    lazy var contentView = self.view as! FriendsView
    lazy var operationService = VkApiOperationService()
    private let vkServiceAdaptor = VkApiAdaptor()
    private let viewModelFactory = UserViewModelFactory()


    // MARK: - Life Circle

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.tableView.register(CustomHeader.nib, forHeaderFooterViewReuseIdentifier: CustomHeader.reuseId)
        contentView.letterPicker.delegate = contentView
        contentView.searchBar.delegate = contentView
        title = "Друзья"
        contentView.delegate = self
        vkServiceAdaptor.getFirends { [weak self] (users) in
            guard let strongSelf = self else { return }
            strongSelf.contentView.users = strongSelf.viewModelFactory.constructViewModels(from: users)
            strongSelf.contentView.users.count > 0 ? strongSelf.contentView.indicator.stopAnimating() : strongSelf.contentView.indicator.startAnimating()
        }
        
    }
        
    func seque(user: UserViewModel){
        let controller = AsyncAlbumController()
        controller.friend = "\(user.name)"
        controller.userId = user.id
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
