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
    
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    var usersData: Results<User>!
    lazy var contentView = self.view as! FriendsView
    lazy var operationService = VkApiOperationService()

    // MARK: - Life Circle

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.tableView.register(CustomHeader.nib, forHeaderFooterViewReuseIdentifier: CustomHeader.reuseId)
        contentView.letterPicker.delegate = contentView
        contentView.searchBar.delegate = contentView
        title = "Друзья"
        contentView.delegate = self
        operationService.getRequest()
        loadFromRealm()
        subscribeToRealmNotification()
        
    }
    
    // MARK: - Data Source
    
    func loadFromRealm(){
        usersData = realm.objects(User.self)
        self.contentView.users = Array(usersData)
        contentView.users.count > 0 ? self.contentView.indicator.stopAnimating() : self.contentView.indicator.startAnimating()
    }

    
    func seque(user: User){
        let controller = AsyncAlbumController()
        controller.friend = "\(user.lastName) \(user.firstName)"
        controller.userId = user.id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Prepare for segue
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if
//            let controller = segue.destination as? FriendsPhotoCollectionViewController,
//            let indexPath = contentView.tableView.indexPathForSelectedRow
//        {
//            let index = contentView.userOfSection[indexPath.section]![indexPath.row]
//            let data: [User] = contentView.searchActive ? contentView.filterUsers : contentView.users
//            let friend = data[index]
//            controller.friend = "\(friend.lastName) \(friend.firstName)"
//            controller.userId = friend.id
//        }
//    }
    // MARK: - Realm
    
    private func subscribeToRealmNotification(){
        notificationToken = usersData.observe{ (change) in
            switch change {
            case .initial:
                break
            case .update:
                self.loadFromRealm()
            case .error(let error):
                print(error)
            }
        }
    }
}
