//
//  Group.swift
//  VKClient
//
//  Created by Константин Кузнецов on 18.10.2020.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Group: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var avatarUrl: String = ""
    
    static override func primaryKey() -> String {
        return "id"
    }
    
    convenience init?(json: JSON){
        self.init()
        guard let id = json["id"].int,
              let name = json["name"].string,
              let avatar = json["photo_50"].string
        else { return nil }
        self.id = id
        self.name = name
        self.avatarUrl = avatar
    }
}
