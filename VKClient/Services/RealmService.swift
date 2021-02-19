//
//  RealmService.swift
//  VKClient
//
//  Created by Константин Кузнецов on 17.01.2021.
//

import UIKit
import RealmSwift

class RealmService{
    
    func saveToRealm<T: Object>(saveData: [T]){
        do {
            let realm = try Realm()
            try realm.write{
                realm.add(saveData, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
}
