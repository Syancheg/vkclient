//
//  LikeControl.swift
//  VKClient
//
//  Created by Константин Кузнецов on 27.10.2020.
//

import UIKit


class LikeControl: UIControl {
    
    //MARK: - Properties

    var isLiked: Bool = false {
        didSet{
            updateLikeStatus()
        }
    }
    
    var likesCount: Int = 0 {
        didSet{
            setup()
        }
    }

    //MARK: - Subviews

    lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = .white
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return likeButton
    }()
    
    lazy var likeLabel: UILabel = {
        let likeLabel = UILabel()
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        likeLabel.textColor = .white
        likeLabel.text = "\(likesCount)"
        return likeLabel
    }()
    
    lazy var likeStackView: UIStackView = {
        let likeStack = UIStackView()
        likeStack.translatesAutoresizingMaskIntoConstraints = false
        likeStack.axis = .horizontal
        likeStack.spacing = 5
        likeStack.alignment = .trailing
        return likeStack
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        likeLabel.text = "\(likesCount)"
        backgroundColor = .clear
        addSubview(likeStackView)
        NSLayoutConstraint.activate([
            likeStackView.topAnchor.constraint(equalTo: topAnchor),
            likeStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            likeStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            likeStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        likeStackView.addArrangedSubview(likeLabel)
        likeStackView.addArrangedSubview(likeButton)
    }
    
    // MARK: - Action
    
    @objc private func likeButtonTapped(_ sender: UIButton){
        isLiked.toggle()
        startAnimation()
        sendActions(for: .valueChanged)
    }
    
    private func updateLikeStatus(){
        if isLiked {
            likeButton.tintColor = .vkRedOrange
            likeLabel.textColor = .vkRedOrange
            likesCount += 1
        } else {
            likeButton.tintColor = .white
            likeLabel.textColor = .white
            likesCount -= 1
        }
    }
    
    func startAnimation(){
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.likeStackView.frame.origin.y -= 100
                       })
        
    }
}
