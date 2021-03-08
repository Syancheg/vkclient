//
//  NewsViewModel.swift
//  VKClient
//
//  Created by Константин Кузнецов on 03.03.2021.
//

import UIKit

struct NewsViewModel {
    let name: String
    let avatar: UIImage
    let date: String
    let unixDate: Double
    let text: String?
    let image: UIImage?
    let views: Int
    let likes: Int
    let comments: Int
    let reposts: Int
    let aspectRatio: CGFloat
    let type: NewsType
}
