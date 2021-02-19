//
//  FirebaseService.swift
//  VKClient
//
//  Created by Константин Кузнецов on 23.12.2020.
//

import UIKit
//import FirebaseDatabase

class FirebaseService {
    
    let database = Database.database()
    let refStr = "LoginId"
    
    func saveUserId(){
        let ref = database.reference(withPath: refStr)
        let refChild = ref.child(Session.start.userId)
        getAddedGroups { (groups) in
            refChild.setValue(groups)
        }
    }
    
    func addGroup(addedGroups: [Int]){
        let ref = database.reference(withPath: refStr)
        let refChild = ref.child(Session.start.userId)
        refChild.setValue(addedGroups)
    }
    
    func getAddedGroups(completion: @escaping ([Int]) -> Void ){
        let ref = database.reference(withPath: refStr)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let arr = snapshot.value as? [String: Any],
               let groups = arr["\(Session.start.userId)"] as? [Int]
            {
                completion(groups.filter {$0 > 0})
            } else {
                completion([0])
            }
            
        }
        
    }
    
}
