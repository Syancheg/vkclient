//
//  NewsView.swift
//  VKClient
//
//  Created by Константин Кузнецов on 01.02.2021.
//

import UIKit

protocol NewsViewDelegate: class {
    func appendNews(startFrom: String, indexPaths: [IndexPath])
}

class NewsView: UIView, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching, NewsPostCellDelegate  {
    
    //MARK: - Properties

    var news: [NewsViewModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    weak var delegate: NewsViewDelegate?
    
    enum CellType: Int, CaseIterable{
        case header
        case content
        case footer
    }
    
    var isLoading: Bool = false
    var nextFrom: String = ""
    
    //MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = news[indexPath.section]
        guard
            let cellType = CellType(rawValue: indexPath.row),
            cellType == .content,
            item.type == .image
        else { return UITableView.automaticDimension}
        let tableWidth = tableView.bounds.width
        let cellHeight = tableWidth * item.aspectRatio
    
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = news[indexPath.section]
        let cellType = CellType(rawValue: indexPath.row) ?? .content
        var cellIdentifire = ""
        
        switch cellType {
        case .header:
            cellIdentifire = "NewsHeaderCell"
        case .content:
            cellIdentifire = contetnCellIdentifire(item)
        case .footer:
            cellIdentifire = "NewsFooterCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath) as! NewsCell
        cell.configure(item: item)
        if let postCell = cell as? NewsPostCell  {
            postCell.delegate = self
        }
        return cell

    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]){
        
        guard
            let maxSection = indexPaths.map(\.section).max(),
            maxSection > news.count - 3,
            isLoading == false
        else
        { return }
        isLoading = true
        delegate?.appendNews(startFrom: nextFrom, indexPaths: indexPaths)
        
    }
    
    private func contetnCellIdentifire(_ item: NewsViewModel) -> String {
        switch item.type {
        case .post:
            return "NewsPostCell"
        case .image:
            return "NewsImageCell"
        }
    }
    
    
    //MARK: - NewsPostCellDelegate
    
    func didTappedShowMore(_ cell: NewsPostCell){
        tableView.beginUpdates()
        cell.isExpanded.toggle()
        tableView.endUpdates()
        if !cell.isExpanded {
            if var indexPath = tableView.indexPath(for: cell) {
                indexPath.row = 0
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
}
