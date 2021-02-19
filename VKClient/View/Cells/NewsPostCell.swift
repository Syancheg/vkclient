//
//  NewsPostCell.swift
//  VKClient
//
//  Created by Константин Кузнецов on 13.01.2021.
//

import UIKit

protocol NewsPostCellDelegate: class {
    func didTappedShowMore(_ cell: NewsPostCell)
}

class NewsPostCell: UITableViewCell, NewsConfigurable {
    
    //MARK: - Outlets

    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var heigthConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    
    let baseHeigth: CGFloat = 200
    var textHeight: CGFloat = 0
    weak var delegate: NewsPostCellDelegate?
    
    var isExpanded = false {
        didSet{
            updatePostLabel()
            updateShowMoreButton()
        }
    }
    
    //MARK: - life circle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updatePostLabel()
        updateShowMoreButton()
    }
    
    //MARK: - Actions
    
    @IBAction func showMoreTapped(_ sendler: UIButton){
        delegate?.didTappedShowMore(self)
    }
    
    //MARK: - Setup

    func configure(item: News){
        postLabel.text = item.text
        textHeight = postLabel.getHeight()
        if  baseHeigth > textHeight {
            heigthConstraint.constant = textHeight
            showMoreButton.alpha = 0
        } else {
            heigthConstraint.constant = baseHeigth
            showMoreButton.alpha = 1
        }
    }
    
    func updatePostLabel(){
        heigthConstraint.constant = isExpanded ? textHeight : baseHeigth
    }
    
    func updateShowMoreButton(){
        let title = isExpanded ? "Скрыть" : "Смотреть полностью"
        showMoreButton.setTitle(title, for: .normal)
    }
}
