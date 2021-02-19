//
//  FriendsPhotoCollectionViewController.swift
//  VKClient
//
//  Created by Константин Кузнецов on 18.10.2020.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class FriendsPhotoCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    var photosData: Results<Photo>!
    var friend: String = ""
    var userId: Int = 0
    lazy var service = VkApiServices()
    lazy var contentView = self.view as! FriendsPhotoView

    // MARK: - Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Фото \(friend)"
        loadFromApi()
        loadFromRealm()
        subscribeToRealmNotification()
    }

    // MARK: - Data Source
    
    func loadFromRealm(){
        photosData = realm.objects(Photo.self).filter("ownerId == %@", userId)
        contentView.photos = Array(photosData)
        contentView.photos.count > 0 ? self.contentView.indicator.stopAnimating() : self.contentView.indicator.startAnimating()
    }
    
    func loadFromApi(){
//        service.requestVk(.photos(id: "\(userId)"))
    }
    
    // MARK: - Realm
    
    private func subscribeToRealmNotification(){
        notificationToken = photosData.observe{ (change) in
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
    
    //MARK: - Seques
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let controller = segue.destination as? PhotoGallaryController,
            let indexPath = contentView.collectionView.indexPathsForSelectedItems?.first
        {
            controller.title = self.title
            controller.images = contentView.photos
            controller.currentIndex = indexPath.row
            
        }
    }
    
}
