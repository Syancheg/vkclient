//
//  AsyncPhotoCell.swift
//  VKClient
//
//  Created by Константин Кузнецов on 07.02.2021.
//

import UIKit
import AsyncDisplayKit

class AsyncPhotoCell: ASCellNode {
    
    private let source: Photo
    private let photo = ASNetworkImageNode()
    private let imageHeight: CGFloat = 300
    
    private enum Constants {
        static let padding: CGFloat = 8
    }

    init(source: Photo) {
        self.source = source
        super.init()
        backgroundColor = UIColor.white
        setupSubnodes()
    }

    
    private func setupSubnodes() {
        
        photo.url = URL(string: source.imageUrl)
        photo.cornerRadius = 5
        photo.clipsToBounds = true
        photo.shouldRenderProgressImages = true
        photo.contentMode = .scaleAspectFill
        addSubnode(photo)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        photo.style.preferredSize = CGSize(width: imageHeight, height: imageHeight)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let imageWithInset = ASInsetLayoutSpec(insets: insets, child: photo)
        return ASWrapperLayoutSpec(layoutElement: imageWithInset)
    }
}
