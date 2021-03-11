//
//  UserAdaptor.swift
//  VKClient
//
//  Created by Константин Кузнецов on 27.02.2021.
//

import Foundation
import RealmSwift

final class VkApiAdaptor {
    
    enum apiMethod {
        case friends
        case groups
    }
    
    private let vkApiService = VkApiServices()
    private lazy var vkApiServiceProxy = VkApiServicesProxy(vkService: vkApiService)
    private var realmNotificationToken: NotificationToken?
    
    private func getRequest<T:Object>(object: T.Type, method: apiMethod, completion: @escaping ([T]) -> Void){
        guard let realm = try? Realm()
        else { return }
        let data = realm.objects(object.self)

        let token = data.observe{ (changes: RealmCollectionChange) in
            switch changes {
            case .update(let realm, _, _, _):
                completion(Array(realm))
            case .error(let error):
                print(error)
            case .initial(let realm):
                // почему-то иногда вылетает сюда, а иногда в update не могу понять от чего зависит и где ошибка
                // но если completion выводить и тут, то таблица обновляется 2 раза, а если не выводить то не всегда и один
                completion(Array(realm))
            }
        }
        self.realmNotificationToken = token
        switch method {
        case .friends:
            vkApiServiceProxy.getFriends()
        case .groups:
            vkApiServiceProxy.getGroups()
        }


    }
    
    func getFirends(completion: @escaping ([NewUser]) -> Void){
        getRequest(object: User.self, method: .friends) { [weak self] (users) in
            guard let strongSelf = self else { return }
            var newUsers: [NewUser] = []
            for user in users {
                newUsers.append(strongSelf.user(form: user))
            }
            completion(newUsers)
        }
    }
    
    func getGroups(completion: @escaping ([NewGroup]) -> Void){
        getRequest(object: Group.self, method: .groups) { [weak self] (groups) in
            guard let strongSelf = self else { return }
            var newGroups: [NewGroup] = []
            for group in groups {
                newGroups.append(strongSelf.group(form: group))
            }
            completion(newGroups)
        }
    }
    
    func searchGroups(q: String, completion: @escaping ([NewGroup]) -> Void){
        vkApiServiceProxy.searhGroups(query: q) { [weak self] (groups) in
            guard let strongSelf = self else { return }
            var newGroups: [NewGroup] = []
            for group in groups {
                newGroups.append(strongSelf.group(form: group))
            }
            completion(newGroups)
        }
    }
    
    private func user(form rlmUser: User) -> NewUser{
        return NewUser(id: rlmUser.id, firstName: rlmUser.firstName, lastName: rlmUser.lastName, avatarUrl: rlmUser.avatarUrl)
    }
    private func group(form rlmGroup: Group) -> NewGroup{
        return NewGroup(id: rlmGroup.id, name: rlmGroup.name, avatarUrl: rlmGroup.avatarUrl)
    }
    
    
}
