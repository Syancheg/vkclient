//
//  FriendsPhotoView.swift
//  VKClient
//
//  Created by Константин Кузнецов on 01.02.2021.
//

import UIKit

class FriendsPhotoView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Properties

    var photos: [Photo] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    lazy var photoService = PhotoService(container: collectionView)
    
    private enum Constants {
        static let padding: CGFloat = 5
        static let columns: CGFloat = 3
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        cell.photoFriends.image = photoService.photo(atIndexpath: indexPath, byUrl: photo.imageUrl)
        cell.likeControl.isLiked = photo.userLikes == 1 ? true : false
        cell.likeControl.likesCount = photo.likes
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) ->CGSize {
        let width = ((collectionView.frame.width) - (Constants.padding * (Constants.columns - 1)))/Constants.columns
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) ->UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.padding
    }

}
