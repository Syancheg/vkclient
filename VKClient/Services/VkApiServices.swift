//
//  VkApiServices.swift
//  VKClient
//
//  Created by Константин Кузнецов on 27.11.2020.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

protocol VkApiServicesInterface {
    func getFriends()
    func getGroups()
    func searhGroups(query: String, completion: @escaping ([Group]) -> Void )
    func getAlbum(ownerId: Int, completion: @escaping ([Album]) -> Void )
    func getPhoto(ownerId: String, albumId: String, completion: @escaping ([Photo]) -> Void )
    func getNews(from startTime: TimeInterval?, startFrom: String?, completion: @escaping ([News], String) -> Void)
}

class VkApiServices: VkApiServicesInterface {
    
    // MARK: - Properties
    
    lazy var realm = RealmService()
    let baseUrl = "https://api.vk.com/method/"
    var accessToken = Session.start.token
    let version = 5.126
    let lang = 0
    
    enum ApiMethod {
        case friends
        case photos(id: String, albumId: String)
        case albums(ownerId: String)
        case groups
        case searchGroups(query: String)
        case news(start: TimeInterval?, startFrom: String?)
        
        var path: String {
            switch self {
            case .friends:
                return "friends.get"
            case .photos:
                return "photos.get"
            case .albums:
                return "photos.getAlbums"
            case .groups:
                return "groups.get"
            case .searchGroups:
                return "groups.search"
            case .news:
                return "newsfeed.get"
            }
            
            
        }
        
        var parameters: [String: String] {
            switch self {
            case .friends:
                return ["fields": "bdate, photo_50"]
            case .photos(let id, let albumId):
                return ["owner_id": id, "extended" : "1", "album_id": albumId]
            case .albums(let ownerId):
                return ["owner_id": ownerId, "need_system": "1", "need_covers": "1"]
            case .groups:
                return ["extended" : "1"]
            case .searchGroups(let query):
                return ["q": query]
            case .news(let start, let from):
                var param = ["filters":"post,wall_photo", "count": "10"]
                if let startTime = start {
                    param["startTime"] = "\(startTime)"
                }
                if let startFrom = from {
                    param["startTime"] = startFrom
                }
                return param
            }
        }
    }
    
    func requestVk(_ method: ApiMethod, completion: @escaping (Data?) -> Void ){
        let url = baseUrl + method.path
        var parameters = method.parameters
        parameters["access_token"] = accessToken
        parameters["v"] = "\(version)"
        AF.request(url, parameters: parameters).responseData { (response) in
            guard let data = response.data else {
                return
            }
            completion(data)
        }
    }
    
    func getFriends(){
        requestVk(.friends) { [weak self] (data) in
            guard let data = data else {
                return
            }
            do {
                let response = try JSON(data: data)
                let friends = response["response"]["items"].arrayValue.compactMap {
                    User(json: $0)
                }
                self?.realm.saveToRealm(saveData: friends)
            } catch {
                print(error)
            }
        }
    }
    
    func getGroups(){
        requestVk(.groups) { [weak self] (data) in
            guard let data = data else {
                return
            }
            do {
                let response = try JSON(data: data)
                let groups = response["response"]["items"].arrayValue.compactMap {
                    Group(json: $0)
                }
                self?.realm.saveToRealm(saveData: groups)
            } catch {
                print(error)
            }
        }
    }
    
    func searhGroups(query: String, completion: @escaping ([Group]) -> Void ){
        requestVk(.searchGroups(query: query)) { (data) in
            guard let data = data else {
                return
            }
            do {
                let response = try JSON(data: data)
                let groups = response["response"]["items"].arrayValue.compactMap {
                    Group(json: $0)
                }
                completion(groups)
            } catch {
                completion([])
            }
        }
    }
    
    func getAlbum(ownerId: Int, completion: @escaping ([Album]) -> Void ){
        
        requestVk(.albums(ownerId: "\(ownerId)")) { (data) in
            guard let data = data else {
                return
            }
            do {
                let response = try JSON(data: data)
                let albums = response["response"]["items"].arrayValue.compactMap { Album(json: $0)
                }
                completion(albums)
            } catch {
                completion([])
            }
        }
    }
    
    func getPhoto(ownerId: String, albumId: String, completion: @escaping ([Photo]) -> Void ){
        requestVk(.photos(id: ownerId, albumId: albumId)) { (data) in
            guard let data = data else {
                return
            }
            do {
                let response = try JSON(data: data)
                let photos = response["response"]["items"].arrayValue.compactMap { Photo(json: $0) }
                completion(photos)
            } catch {
                completion([])
            }
        }
    }
    
    func getNews(from startTime: TimeInterval? = nil,
                 startFrom: String? = nil, completion: @escaping ([News], String) -> Void){
        requestVk(.news(start: startTime, startFrom: startFrom)) { (data) in
            guard let data = data else {
                return
            }
            do {
                let response = try JSON(data: data)
                let arr = response["response"].dictionaryValue
                self.parseNews(news: arr, completion: { (news, nextFrom) in
                    if let nextFrom = nextFrom {
                        completion(news, nextFrom)
                    } else {
                        completion(news, "")
                    }
                    
                })
            } catch {
                completion([], "")
            }
        }
    }
    // MARK: - Parse News
    
    private func parseNews(news: [String: JSON], completion: @escaping ([News], String?) -> Void ){
        let nextFrom = news["next_from"]?.stringValue
        let profiles = news["profiles"]?.arrayValue.compactMap {
            User(json: $0)
        }
        let groups = news["groups"]?.arrayValue.compactMap {
            Group(json: $0)
        }
        var items: [News] = []
        JSON(news["items"]!).arrayValue.forEach { (json) in
            var item = [String: String]()
            let source_id = json["source_id"].intValue
            if source_id > 0 {
                profiles?.forEach {
                    if source_id == $0.id {
                        item["name"] = $0.firstName + " " + $0.lastName
                        item["photo_50"] = $0.avatarUrl
                    }
                }
            } else {
                groups?.forEach{
                    if source_id * -1 == $0.id {
                        item["name"] = $0.name
                        item["photo_50"] = $0.avatarUrl
                    }
                }
            }
            item["source_id"] = "\(source_id)"
            let new = News(json: json, item: item)!
            items.append(new)
        }
        completion(items, nextFrom)
    }
}

