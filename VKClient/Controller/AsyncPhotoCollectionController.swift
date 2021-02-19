//
//  AsyncPhotoCollectionController.swift
//  VKClient
//
//  Created by Константин Кузнецов on 07.02.2021.
//

import UIKit
import AsyncDisplayKit

class AsyncPhotoCollectionController: ASDKViewController<ASDisplayNode>, ASCollectionDataSource, ASCollectionDelegate {
    
    var albumTitle = ""
    var ownerId = 0
    var albumId = 0
    var photos: [Photo] = []
    
    lazy var service = VkApiServices()
    
    var collectionNode: ASCollectionNode {
        return node as! ASCollectionNode
    }
    
    private enum Constants {
        static let padding: CGFloat = 5
        static let columns: CGFloat = 3
    }
    
    override init() {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: collectionNode)
        collectionNode.delegate = self
        collectionNode.dataSource = self
        collectionNode.view.backgroundColor = .white
        collectionNode.contentInset = UIEdgeInsets(top: Constants.padding, left: Constants.padding, bottom: Constants.padding, right: Constants.padding)
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = albumTitle
        loadData()
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let width = ((collectionNode.frame.width - (Constants.padding * 2)) - (Constants.padding * (Constants.columns - 1)))/Constants.columns
        return ASSizeRange(min: CGSize(width: width, height: width), max: CGSize(width: width, height: width))
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
      guard photos.count > indexPath.row else { return { ASCellNode() } }

      let photo = photos[indexPath.row]

      let cellNodeBlock = { () -> ASCellNode in
        let cellNode = AsyncPhotoCell(source: photo)
        return cellNode
      }

      return cellNodeBlock
    }

    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PhotoGallaryController") as! PhotoGallaryController
        vc.currentIndex = indexPath.row
        vc.images = photos
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func loadData(){
        service.getPhoto(ownerId: "\(ownerId)", albumId: "\(albumId)") { [weak self] (photos) in
            guard let strongSelf = self else { return }
            strongSelf.photos = photos
            strongSelf.collectionNode.reloadData()
        }
    }
}
