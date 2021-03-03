//
//  AvatarView.swift
//  VKClient
//
//  Created by Константин Кузнецов on 27.10.2020.
//

import UIKit

@IBDesignable
class AvatarView: UIView {
    
    //MARK: - Properties
    
    @IBInspectable
    var shadowRadius: CGFloat = 15 {
        didSet{
            apdateShadow()
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor = .vkGoodNight {
        didSet{
            apdateShadow()
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float = 0.7 {
        didSet{
            apdateShadow()
        }
    }
    
    var image: UIImage? {
        didSet{
            imageView.image = image
            setNeedsDisplay()
        }
    }
    
    //MARK: - Subviews

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var shadowView: UIView = {
        let shadowView = UIView()
        shadowView.clipsToBounds = false
        shadowView.backgroundColor = .white
        return shadowView
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
        addSubview(shadowView)
        addSubview(imageView)
        
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        let gesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        addGestureRecognizer(gesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.width / 2
        shadowView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    private func apdateShadow(){
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowOpacity = shadowOpacity
    }
    
    //MARK: - Actions
    
    @objc private func avatarTapped(sender: UITapGestureRecognizer){
        transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: []) {
            self.transform = .identity
        }
    }

}
