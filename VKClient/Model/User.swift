//
//  User.swift
//  VKClient
//
//  Created by Константин Кузнецов on 18.10.2020.
//

import UIKit
import SwiftyJSON
import RealmSwift

class User: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var avatarUrl: String = ""
    
    static override func primaryKey() -> String {
        return "id"
    }
    
    convenience init?(json: JSON) {
        self.init()
        guard let id = json["id"].int,
              let firstName = json["first_name"].string,
              let lastName = json["last_name"].string,
              let avatar = json["photo_50"].string
              else { return nil }
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.avatarUrl = avatar
    
    }
}
