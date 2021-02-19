//
//  SearchGroupsView.swift
//  VKClient
//
//  Created by Константин Кузнецов on 01.02.2021.
//

import UIKit

class SearchGroupsView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Properties
    
    var groups: [Group] = []
    var filterGroups: [Group] = []
    var searchActive : Bool = false
    lazy var photoService = PhotoService(container: tableView)
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Table View

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data: [Group] = searchActive ? filterGroups : groups
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as! GroupsCell
        let data: [Group] = searchActive ? filterGroups : groups
        let group = data[indexPath.row]
        cell.groupsNameLabel.text = group.name
        cell.avatarGroup.imageView.image = photoService.photo(atIndexpath: indexPath, byUrl: group.avatarUrl)
        return cell
    }
    
    
}
