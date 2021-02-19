//
//  VkApiOperationService.swift
//  VKClient
//
//  Created by Константин Кузнецов on 19.01.2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class VkApiOperationService {

    func getRequest(){
        
        let queue = OperationQueue()
        let receiveOperation = ReceiveVkDataFriends()
        let parseOperation = ParseVkDataFriends()
        let saveOperation = SaveVkDataToRealm()
        
        parseOperation.addDependency(receiveOperation)
        saveOperation.addDependency(parseOperation)

        let operations = [
            receiveOperation,
            parseOperation,
            saveOperation
        ]
        queue.addOperations(operations, waitUntilFinished: false)
    }
}

class ReceiveVkDataFriends: AsyncOperation {
    
    var outputData: Data?

    override func main() {
        let url = "https://api.vk.com/method/friends.get"
        let parameters: Parameters = [
            "fields": "bdate, photo_50",
            "access_token": Session.start.token,
            "v": "5.126"
        ]
        AF.request(url, parameters: parameters).responseData { [weak self] (response) in
            print(response)
            guard let data = response.data else {
                return
            }
            self?.outputData = data
            self?.state = .finished
        }
    }
}
class ParseVkDataFriends: Operation {
    
    var outputData: [User]?
    
    override func main() {
        if let receiveOperation = dependencies.first as? ReceiveVkDataFriends {
            guard let data = receiveOperation.outputData else { return }
            do {
                let friendsResponse = try JSON(data: data)
                let friends = friendsResponse["response"]["items"].arrayValue.compactMap {
                    User(json: $0)
                }
                outputData = friends
            } catch {
                print(error)
            }
        }
        
        
    }
}
class SaveVkDataToRealm: Operation {
    override func main() {
        if let parseOperation = dependencies.first as? ParseVkDataFriends {
            guard let users = parseOperation.outputData else { return }
            let realm = RealmService()
            realm.saveToRealm(saveData: users)
        }
    }
}
