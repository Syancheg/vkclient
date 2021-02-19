//
//  LoaderView.swift
//  VKClient
//
//  Created by Константин Кузнецов on 04.11.2020.
//

import UIKit

class LoaderView: UIView {
    
    private var circles: [UIView] = []
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    enum Setting {
        static let countFigure: Int = 3
    }
    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    
    func setup(){
        self.layer.backgroundColor = UIColor.blue.cgColor
        
        for _ in 0..<Setting.countFigure {
            let circle = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            circle.layer.backgroundColor = UIColor.white.cgColor
            circle.layer.cornerRadius = circle.frame.height / 2
            circle.layer.opacity = 0
            circles.append(circle)
            stackView.addArrangedSubview(circle)
            
            
        }
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: 110),
            stackView.heightAnchor.constraint(equalToConstant: 30),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -15),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -15)
        ])
        startAnimation()
    }
    
    //MARK: - Animation
    
    func startAnimation(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat]) {
            self.circles[0].layer.opacity = 1
        }
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.autoreverse, .repeat]) {
            self.circles[1].layer.opacity = 1
        }
        UIView.animate(withDuration: 0.5, delay: 0.4, options: [.autoreverse, .repeat]) {
            self.circles[2].layer.opacity = 1
        }
        UIView.animate(withDuration: 0.5, delay: 2.5, options: []) {
            self.layer.opacity = 0
        }
    }
    
}
