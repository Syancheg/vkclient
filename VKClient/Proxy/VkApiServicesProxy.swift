//
//  VkApiServicesProxy.swift
//  VKClient
//
//  Created by Константин Кузнецов on 11.03.2021.
//

import Foundation

class VkApiServicesProxy: VkApiServicesInterface {
    
    let vkService: VkApiServices
    
    init(vkService: VkApiServices) {
        self.vkService = vkService
    }
    
    
    func getFriends() {
        self.vkService.getFriends()
        print("<----Выполнен запрос на получение списка друзей---->")
    }
    
    func getGroups() {
        self.vkService.getGroups()
        print("<----Выполнен запрос на получение списка групп пользователя---->")
    }
    
    func searhGroups(query: String, completion: @escaping ([Group]) -> Void) {
        print("<----Запрос поиска групп по слову '\(query)'---->")
        self.vkService.searhGroups(query: query) { (groups) in
            completion(groups)
            print("<----Найдено \(groups.count) ответов---->")
        }
    }
    
    func getAlbum(ownerId: Int, completion: @escaping ([Album]) -> Void) {
        print("<----Запрос альбомов пользователя '\(ownerId)'---->")
        self.vkService.getAlbum(ownerId: ownerId) { (albums) in
            completion(albums)
            print("<----Найдено \(albums.count) альбомов---->")
        }
    }
    
    func getPhoto(ownerId: String, albumId: String, completion: @escaping ([Photo]) -> Void) {
        print("<----Запрос фотографий пользователя '\(ownerId)', из альбома '\(albumId)'---->")
        self.vkService.getPhoto(ownerId: ownerId, albumId: albumId) { (photos) in
            completion(photos)
            print("<----Найдено \(photos.count) фотографий---->")
        }
    }
    
    func getNews(from startTime: TimeInterval?, startFrom: String?, completion: @escaping ([News], String) -> Void) {
        print("<----Запрос новостей пользователя---->")
        self.vkService.getNews(from: startTime, startFrom: startFrom) { (news, str) in
            completion(news, str)
            print("<----Найдено \(news.count) новостей---->")
        }
    }
}
