//
//  PhotoGallaryController.swift
//  VKClient
//
//  Created by Константин Кузнецов on 06.11.2020.
//

import UIKit

class PhotoGallaryController: UIViewController {
    
    // MARK: - Properties
    
    var currentIndex: Int = 0
    var images: [Photo] = []
    
    lazy var contentView = self.view as! GallaryView
    
    //MARK: - life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.setup(index: currentIndex, photos: images)
    }
    
}
