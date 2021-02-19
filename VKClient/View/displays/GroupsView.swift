//
//  GroupsView.swift
//  VKClient
//
//  Created by Константин Кузнецов on 01.02.2021.
//

import UIKit

class GroupsView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Properties

    var groups: [Group] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    lazy var photoService = PhotoService(container: tableView)
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    
    // MARK: - Table View

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as! GroupsCell
        let group = groups[indexPath.row]
        cell.groupsNameLabel.text = group.name
        cell.avatarGroup.imageView.image = photoService.photo(atIndexpath: indexPath, byUrl: group.avatarUrl)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
