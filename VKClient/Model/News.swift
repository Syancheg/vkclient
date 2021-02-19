//
//  News.swift
//  VKClient
//
//  Created by Константин Кузнецов on 02.11.2020.
//

import UIKit
import SwiftyJSON

enum NewsType {
    case post
    case image
}

class News {
    var name: String = ""
    var avatar: String = ""
    var date: String = ""
    var unixDate: Double = 0
    var text: String?
    var image: NewsfeedPhoto?
    var views: Int = 0
    var likes: Int = 0
    var comments: Int = 0
    var reposts: Int = 0
    var type: NewsType = .post
    
    convenience init?(json: JSON, item: [String: String]) {
        self.init()
        
        name = item["name"] ?? ""
        avatar = item["photo_50"] ?? ""
        
        unixDate = json["date"].doubleValue
        let dateTime = NSDate(timeIntervalSince1970: TimeInterval(unixDate))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM YYYY"
        date = dateFormatter.string(from: dateTime as Date)
        let postType = json["type"].stringValue
        switch postType {
        case "post":
            type = .post
        case "wall_photo":
            type = .image
        default:
            break
        }
        switch type {
        case .post:
            text = json["text"].stringValue
//            type = text == "" ? .image : .post
//            image = NewsfeedPhoto(json: json["photos"]["items"][0])
            comments = json["comments"]["count"].intValue
            likes = json["likes"]["count"].intValue
            reposts = json["reposts"]["count"].intValue
            views = json["views"]["count"].intValue
        case .image:
            let imageInfo = json["photos"]["items"][0]
            image = NewsfeedPhoto(json: imageInfo)
            comments = imageInfo["comments"]["count"].intValue
            likes = imageInfo["likes"]["count"].intValue
            reposts = imageInfo["reposts"]["count"].intValue
        }
        

    }
}

struct NewsfeedPhoto {
    var imageUrl: String
    var width: Int
    var height: Int
    
    var aspectRatio: CGFloat{
        return CGFloat(height) / CGFloat(width)
    }
    
    init(json: JSON){
        self.imageUrl = json["sizes"][4]["url"].stringValue
        self.width = json["sizes"][4]["width"].intValue
        self.height = json["sizes"][4]["height"].intValue
    }
}
