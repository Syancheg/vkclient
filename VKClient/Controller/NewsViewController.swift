//
//  NewsViewController.swift
//  VKClient
//
//  Created by Константин Кузнецов on 01.11.2020.
//

import UIKit


class NewsViewController: UIViewController, NewsViewDelegate, UITableViewDelegate {
    
    // MARK: - Properies
    
    lazy var contentView = self.view as! NewsView
    private let viewModelFactory = NewsViewModelFactory()
    lazy var service = VkApiServices()
    var pullToRefresh:UIRefreshControl!
    
    
    //MARK: - Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новости"
        contentView.indicator.startAnimating()
        contentView.delegate = self
        contentView.tableView.prefetchDataSource = contentView
        loadNews()
        setupPullToRefresh()
    }
    
    // MARK: - Refresh Control
    
    private func setupPullToRefresh(){
        pullToRefresh = UIRefreshControl()
        pullToRefresh.attributedTitle = NSAttributedString(string: "Обновление новостей...")
        pullToRefresh.addTarget(self, action: #selector(refresh), for: .valueChanged)
        contentView.tableView.addSubview(pullToRefresh)
    }
    
    // MARK: - Loading Data
    
    func loadNews(){
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.service.getNews(completion: { (newsFeed, nextFrom) in
                DispatchQueue.main.async {
                    strongSelf.contentView.nextFrom = nextFrom
                    strongSelf.contentView.news = strongSelf.viewModelFactory.constructViewModels(from: newsFeed)
                    strongSelf.contentView.tableView.reloadData()
                    strongSelf.contentView.indicator.stopAnimating()
                }
            })
        }
    }
    
    func appendNews(startFrom: String, indexPaths: [IndexPath]){
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.service.getNews(startFrom: startFrom, completion: { (newsFeed, nextFrom) in
                DispatchQueue.main.async {
                    guard let strongSelf = self else { return }
                    let oldNewsCont = strongSelf.contentView.news.count
                    let newSections = (oldNewsCont..<(oldNewsCont + newsFeed.count)).map{$0}
                    strongSelf.contentView.nextFrom = nextFrom
                    strongSelf.contentView.news.append(contentsOf: strongSelf.viewModelFactory.constructViewModels(from: newsFeed))
                    strongSelf.contentView.tableView.insertSections(IndexSet(newSections), with: .automatic)
                    strongSelf.contentView.isLoading = false
                }
            })
        }
    }
    
    @objc func refresh(){
        var mostFreshDate: TimeInterval?
        if let firstItem = contentView.news.first {
            mostFreshDate = firstItem.unixDate + 1
        }
        service.getNews(from: mostFreshDate) { [weak self] (news, nextFrom) in
            guard let strongSelf = self else { return }
            strongSelf.contentView.nextFrom = nextFrom
            let newsModel = strongSelf.viewModelFactory.constructViewModels(from: news)
            strongSelf.contentView.news = newsModel + strongSelf.contentView.news
            strongSelf.contentView.tableView.reloadData()
            strongSelf.pullToRefresh.endRefreshing()
        }
    }

}
