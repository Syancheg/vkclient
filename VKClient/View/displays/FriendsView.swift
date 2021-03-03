//
//  FriendsView.swift
//  VKClient
//
//  Created by Константин Кузнецов on 29.01.2021.
//

import UIKit

protocol FriendsViewDelegate: class {
    func seque(user: UserViewModel)
}

class FriendsView: UIView, UITableViewDataSource, UITableViewDelegate, LetterPickerDelegate, UISearchBarDelegate {
    
    //MARK: - Properties
    
    weak var delegate: FriendsViewDelegate?
    
    var users: [UserViewModel] = []{
        didSet{
            buildingRelationships()
            tableView.reloadData()
        }
    }
    var sections: [String] = []
    var userOfSection: [Int: [Int]] = [:]
    var searchActive : Bool = false
    var filterUsers: [UserViewModel] = []
    lazy var operationService = VkApiOperationService()
    lazy var photoService = PhotoService(container: tableView)
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var letterPicker: LettterPicker!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeader.reuseId) as? CustomHeader else { return nil }
        headerView.textLabet.text = sections[section]
        return headerView
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userOfSection[section]!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
        let index = userOfSection[indexPath.section]![indexPath.row]
        let data: [UserViewModel] = searchActive ? filterUsers : users
        let friend = data[index]
        cell.configure(with: friend)
//        cell.friendsNameLabel.text = "\(friend.name) \(friend.firstName)"
//        cell.avatarView.imageView.image = photoService.photo(atIndexpath: indexPath, byUrl: friend.avatarUrl)
        cell.selectionStyle = .none
        startAnimation(cell)
        return cell
    }
    
    // MARK: - Search
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        tableView.reloadData()
        }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        tableView.reloadData()
        }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        tableView.reloadData()
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterUsers = []
        for i in 0..<users.count{
            let name = "\(users[i].name.lowercased())"
            if name.contains(searchText.lowercased()){
                filterUsers.append(users[i])
            }
        }
        if(filterUsers.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        buildingRelationships()
        tableView.reloadData()
    }
    
    //MARK: - Functions
    
    func letterPicked(_ letter: String){
        let data: [UserViewModel] = searchActive ? filterUsers : users
        if
            let index = data.firstIndex(where: { $0.name.lowercased().prefix(1) == letter.lowercased() }),
            let section = sections.firstIndex(where: {$0 == letter}),
            let row = userOfSection[section]?.firstIndex(where: {$0 == index})
        {
            let indexPath = IndexPath(row: row, section: section)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print(#function)
        if let indexPath = tableView.indexPathForSelectedRow {
            let index = userOfSection[indexPath.section]![indexPath.row]
            let data: [UserViewModel] = searchActive ? filterUsers : users
            let friend = data[index]
            delegate?.seque(user: friend)
        }
    }
    
    // MARK: - Relationships
    
    func buildingRelationships() {
        let data: [UserViewModel] = searchActive ? filterUsers : users
        let allLetters = data.map { String($0.name.uppercased().prefix(1)) }
        let sortLetters = Array(Set(allLetters)).sorted()
        letterPicker.letters = sortLetters
        sections = sortLetters
        for i in 0..<sortLetters.count {
            var array: [Int] = []
            for n in 0..<allLetters.count {
                if sortLetters[i] == allLetters[n]{
                    array.append(n)
                }
            }
            userOfSection[i] = array
        }
    }
    
    // MARK: - Animations
    
    func startAnimation(_ cell: FriendsCell){
        cell.avatarView.alpha = 0
        cell.friendsNameLabel.alpha = 0
        cell.avatarView.transform = CGAffineTransform(scaleX: 2, y: 2)
        UIView.animate(withDuration: 1) {
            cell.avatarView.alpha = 1
        }
        UIView.animate(withDuration: 0.5) {
            cell.friendsNameLabel.alpha = 1
        }
        UIView.animate(withDuration: 0.5) {
            cell.avatarView.transform = .identity
        }
        UIView.animate(withDuration: 1,
                       delay: 0.3,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        cell.avatarView.frame.origin.x = +100
                       })
        
    }


}
