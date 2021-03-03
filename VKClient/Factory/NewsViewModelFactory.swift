//
//  NewsViewModelFactory.swift
//  VKClient
//
//  Created by Константин Кузнецов on 03.03.2021.
//

import UIKit

final class NewsViewModelFactory {
    
    func constructViewModels(from news: [News]) -> [NewsViewModel]{
        return news.compactMap(self.viewModel)
    }
    
    private func viewModel(from news: News) -> NewsViewModel{
        let name = news.name
        var avatar = UIImage()
        if let image = UIImage.getImageForUrl(urlPath: news.avatar){
            avatar = image
        }
        let date = NewsViewModelFactory.dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(news.unixDate)))
        let unixDate = news.unixDate
        let text = news.text
        var postImage = UIImage()
        if let image = UIImage.getImageForUrl(urlPath: news.image?.imageUrl ?? ""){
            postImage = image
        }
        let views = news.views
        let likes = news.likes
        let comments = news.comments
        let reposts = news.reposts
        let aspectRatio = news.image?.aspectRatio ?? 1
        let type = news.type
        return NewsViewModel(name: name, avatar: avatar, date: date, unixDate: unixDate, text: text, image: postImage, views: views, likes: likes, comments: comments, reposts: reposts, aspectRatio: aspectRatio, type: type)
    }
    
    private static let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH.mm"
            return dateFormatter
        }()

    
}
