//
//  AsyncAlbumCell.swift
//  VKClient
//
//  Created by Константин Кузнецов on 06.02.2021.
//

import UIKit
import AsyncDisplayKit

class AsyncAlbumCell: ASCellNode {
    
    private let source: Album
    private let titleAlbum = ASTextNode()
    private let thumdAlbum = ASNetworkImageNode()
    private let imageHeight: CGFloat = 150
    
    private enum Constants {
        static let padding: CGFloat = 8
    }

    init(source: Album) {
        self.source = source
        super.init()
        backgroundColor = UIColor.white
        setupSubnodes()
    }
    
    private func setupSubnodes() {
        titleAlbum.attributedText = NSAttributedString(string: source.title, attributes: [.font : UIFont.systemFont(ofSize: 17)])
        titleAlbum.backgroundColor = .clear
        addSubnode(titleAlbum)
        
        thumdAlbum.url = source.thumbSrc
        thumdAlbum.cornerRadius = 5
        thumdAlbum.clipsToBounds = true
        thumdAlbum.shouldRenderProgressImages = true
        thumdAlbum.contentMode = .scaleAspectFill
        addSubnode(thumdAlbum)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        thumdAlbum.style.preferredSize = CGSize(width: imageHeight, height: imageHeight)
        let insets = UIEdgeInsets(top: Constants.padding, left: 0, bottom: Constants.padding, right: 0)
        let imageWithInset = ASInsetLayoutSpec(insets: insets, child: thumdAlbum)
        let textCenterSpec = ASCenterLayoutSpec(centeringOptions: .Y, sizingOptions: [], child: titleAlbum)
        let verticalStackSpec = ASStackLayoutSpec()
        verticalStackSpec.justifyContent = .start
        verticalStackSpec.direction = .vertical
        verticalStackSpec.children = [imageWithInset, textCenterSpec]
        let paddedMainStack = ASInsetLayoutSpec(insets: UIEdgeInsets(top: Constants.padding, left: Constants.padding, bottom: Constants.padding, right: Constants.padding), child: verticalStackSpec)

        return paddedMainStack
    }
}
