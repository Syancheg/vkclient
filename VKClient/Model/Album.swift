//
//  Album.swift
//  VKClient
//
//  Created by Константин Кузнецов on 06.02.2021.
//

import Foundation
import SwiftyJSON

struct AlbumPhoto{
    let id: Int
    let ownerId: Int
    let image: SizeImage?
    
    init(json: JSON){
        self.id = json["id"].intValue
        self.ownerId = json["owner_id"].intValue
        self.image = SizeImage(json: json["sizes"])
    }
}
struct SizeImage {
    let src:URL?
    let width: Int
    let heidth: Int
    
    init?(json: JSON) {
        guard let sizesArray = json.array,
              let xSize = sizesArray.first(where: { $0["type"].stringValue == "x" }),
              let url = URL(string: xSize["url"].stringValue) else { return nil }
        
        self.width = xSize["width"].intValue
        self.heidth = xSize["heigth"].intValue
        self.src = url
       }
}

struct Album {
    let id: Int
    let ownerId: Int
    let title: String
    let thumbSrc: URL?
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.ownerId = json["owner_id"].intValue
        self.title = json["title"].stringValue
        if let url = URL(string: json["thumb_src"].stringValue) {
            self.thumbSrc = url
        } else {
            self.thumbSrc = nil
        }
    }
}
