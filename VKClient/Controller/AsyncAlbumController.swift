//
//  AsyncAlbumController.swift
//  VKClient
//
//  Created by Константин Кузнецов on 07.02.2021.
//

import UIKit
import AsyncDisplayKit

class AsyncAlbumController: ASDKViewController<ASDisplayNode>, ASCollectionDataSource, ASCollectionDelegate{
    
    
    var friend: String = ""
    var userId: Int = 0 {
        didSet{
            loadData()
        }
    }
    var albums: [Album] = []
    lazy var service = VkApiServices()
    
    var collectionNode: ASCollectionNode {
        return node as! ASCollectionNode
    }

    private enum Constants {
        static let padding: CGFloat = 5
        static let columns: CGFloat = 2
    }
    
    override init() {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: collectionNode)
        collectionNode.delegate = self
        collectionNode.dataSource = self
        collectionNode.view.backgroundColor = .white
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Альбомы " + friend
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        albums.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let width = ((collectionNode.frame.width - (Constants.padding * 2)) - (Constants.padding * (Constants.columns - 1)))/Constants.columns
        return ASSizeRange(min: CGSize(width: width, height: 220), max: CGSize(width: width, height: 220))
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
      guard albums.count > indexPath.row else { return { ASCellNode() } }

      let album = albums[indexPath.row]

      let cellNodeBlock = { () -> ASCellNode in
        let cellNode = AsyncAlbumCell(source: album)
        return cellNode
      }

      return cellNodeBlock
    }
    

    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        print(album.id)
        let controller = AsyncPhotoCollectionController()
        controller.albumId = album.id
        controller.albumTitle = album.title
        controller.ownerId = album.ownerId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func loadData(){
        service.getAlbum(ownerId: userId, completion: { [weak self] (loadAlbums) in
            guard let strongSelf = self else { return }
            strongSelf.albums = loadAlbums
            strongSelf.collectionNode.reloadData()
        })
    }
    
}
