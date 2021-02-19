//
//  Photo.swift
//  VKClient
//
//  Created by Константин Кузнецов on 02.12.2020.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Photo: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var likes: Int = 0
    @objc dynamic var userLikes: Int = 0
    
    static override func primaryKey() -> String {
        return "id"
    }
    
    convenience init?(json: JSON) {
        self.init()
        guard let id = json["id"].int,
              let ownerId = json["owner_id"].int,
              let image = json["sizes"][2]["url"].string,
              let likes = json["likes"]["count"].int,
              let userLikes = json["likes"]["user_likes"].int
              else { return nil }
        self.id = id
        self.ownerId = ownerId
        self.likes = likes
        self.userLikes = userLikes
        self.imageUrl = image
    }
}
