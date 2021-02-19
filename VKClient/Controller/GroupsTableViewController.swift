//
//  GroupsTableViewController.swift
//  VKClient
//
//  Created by Константин Кузнецов on 18.10.2020.
//

import UIKit
import RealmSwift

class GroupsTableViewController: UIViewController {
    
    //MARK: - Properties
    
    lazy var promiseService = VkPromiseService()
    lazy var contentView = self.view as! GroupsView
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    var groupsData: Results<Group>!
    
    // MARK: - Life Circle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Мои группы"
        loadFromApi()
        loadFromRealm()
        subscribeToRealmNotification()
    }
    
    // MARK: - Data Source
    
    func loadFromRealm(){
        groupsData = realm.objects(Group.self)
        contentView.groups = Array(groupsData)
        contentView.groups.count > 0 ? contentView.indicator.stopAnimating() : contentView.indicator.startAnimating()
    }
    func loadFromApi(){
        promiseService.getGroups()
    }
    
    // MARK: - Realm
    
    private func subscribeToRealmNotification(){
        notificationToken = groupsData.observe{ (change) in
            switch change {
            case .initial:
                break
            case .update:
                self.loadFromRealm()
            case .error(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Seques
    
    @IBAction func addGroups(_ sender: UIStoryboardSegue){
        guard let searchGroupController = sender.source as? SearchGroupsTableViewController,
              let indexPath = searchGroupController.contentView.tableView.indexPathForSelectedRow
                else { return  }
        let group = searchGroupController.contentView.groups[indexPath.row]
        for item in contentView.groups {
            if item.name == group.name {
                return
            }
        }
        contentView.groups.append(group)
    }
    
}
