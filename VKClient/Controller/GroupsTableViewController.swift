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
    private let vkServiceAdaptor = VkApiAdaptor()
    
    // MARK: - Life Circle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Мои группы"
        vkServiceAdaptor.getGroups { [weak self] (groups) in
            guard let strongSelf = self else { return }
            strongSelf.contentView.groups = groups
            strongSelf.contentView.groups.count > 0 ? strongSelf.contentView.indicator.stopAnimating() : strongSelf.contentView.indicator.startAnimating()
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
