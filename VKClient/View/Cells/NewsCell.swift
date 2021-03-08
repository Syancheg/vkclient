//
//  NewsCell.swift
//  VKClient
//
//  Created by Константин Кузнецов on 13.01.2021.
//

import UIKit

typealias NewsCell = UITableViewCell & NewsConfigurable

protocol NewsConfigurable {
    func configure(item: NewsViewModel)
}
