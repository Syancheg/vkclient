//
//  LettterPicker.swift
//  VKClient
//
//  Created by Константин Кузнецов on 28.10.2020.
//

import UIKit

protocol LetterPickerDelegate: class {
    func letterPicked(_ letter: String)
}

class LettterPicker: UIView {
    
    weak var delegate: LetterPickerDelegate?

    var letters: [String] = "abcdefghijklmnnopqrstuvwxyz".map { String($0) }{
        didSet{
            reload()
        }
    }
    
    //MARK: - Subviews
    
    private var buttons: [UIButton] = []
    private var lastPressedButton: UIButton?
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
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
    
    //MARK: - Setup
    
    private func setup() {
        setupButtons()
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        addGestureRecognizer(pan)
    }
    
    func setupButtons(){
        for letter in letters {
            let button = UIButton(type: .system)
            button.setTitle(letter.uppercased(), for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
            stackView.addArrangedSubview(button)
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true
            buttons.append(button)
            
        }
    }
    
    //MARK: - Actions
    
    @objc private func buttonTapped(_ sender: UIButton){
        guard lastPressedButton != sender else {
            return
        }
        lastPressedButton = sender
        guard let indexButton = buttons.firstIndex(of: sender) else {
            return
        }
        let letterTapped = letters[indexButton]
        delegate?.letterPicked(letterTapped)
    }
    
    @objc private func panAction(_ recognizer: UIPanGestureRecognizer){
        let anchorPoint = recognizer.location(in: self)
        let buttonHeight = bounds.height / CGFloat(buttons.count)
        let buttonIndex = Int(anchorPoint.y / buttonHeight)
        if(buttonIndex >= 0 && buttonIndex <= (buttons.count - 1)){
            let buttonActive = buttons[buttonIndex]
            anHighlightButtons()
            buttonActive.isHighlighted = true
            buttonTapped(buttonActive)
            switch recognizer.state {
            
            case .ended:
                anHighlightButtons()
            default:
                break
            }
        }
        anHighlightButtons()
        
    }
    
    private func anHighlightButtons(){
        buttons.forEach { $0.isHighlighted = false }
    }
    
    private func reload(){
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons = []
        lastPressedButton = nil
        setupButtons()
    }

}
