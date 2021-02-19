//
//  SearchGroupsTableViewController.swift
//  VKClient
//
//  Created by Константин Кузнецов on 18.10.2020.
//

import UIKit

class SearchGroupsTableViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    lazy var service = VkApiServices()
    lazy var contentView = self.view as! SearchGroupsView
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Life Circle

    override func viewDidLoad() {
        title = "Поиск групп"
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    // MARK: - Search
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        contentView.searchActive = false;
        }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        contentView.searchActive = false;
        contentView.tableView.reloadData()
        }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        contentView.searchActive = false;
        contentView.tableView.reloadData()
        }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        contentView.searchActive = false;
        contentView.tableView.reloadData()
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            service.searhGroups(query: searchText) { [weak self] (groups) in
                self?.contentView.groups = groups
            }
        } else {
            contentView.groups = []
        }
        contentView.tableView.reloadData()
    }

}
