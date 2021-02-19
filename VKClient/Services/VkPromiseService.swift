//
//  VkPromiseService.swift
//  VKClient
//
//  Created by Константин Кузнецов on 25.01.2021.
//

import UIKit
import PromiseKit
import Alamofire
import SwiftyJSON

class VkPromiseService {
    
    func getGroups(){
        firstly {
            getData()
        }.then { data in
            self.parseData(data: data)
        }.done { groups in
            let _ = RealmService().saveToRealm(saveData: groups)
        }.catch { error in
            print(error)
        }
    }
    
    func getData() -> Promise<Data>{
        let promise = Promise<Data> { (resolver) in
            let url = "https://api.vk.com/method/groups.get"
            let parameters: Parameters = [
                "extended": "1",
                "access_token": Session.start.token,
                "v": "5.126"
            ]
            AF.request(url, parameters: parameters).responseData { (response) in
                if let data = response.data {
                    resolver.fulfill(data)
                }
            }
        }
        return promise
    }
    
    func parseData(data: Data) -> Promise<[Group]> {
        let promise = Promise<[Group]> { (resolver) in
            do {
                let groupsResponse = try JSON(data: data)
                let groups = groupsResponse["response"]["items"].arrayValue.compactMap {
                    Group(json: $0)
                }
                resolver.fulfill(groups)
            } catch {
                resolver.reject(error)
            }
        }
        return promise
    }

}
