//
//  GallaryView.swift
//  VKClient
//
//  Created by Константин Кузнецов on 01.02.2021.
//

import UIKit

enum PanDirection {
    case left, right
    
    init(x: CGFloat){
        self = x > 0 ? .right : .left
    }
}

class GallaryView: UIView {
    
    //MARK: - Properties

    var currentIndex: Int = 0
    var images: [Photo] = []
    lazy var nextImageView = UIImageView()
    private var animator: UIViewPropertyAnimator!
    
    //MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Setup
    
    func setup(index: Int, photos: [Photo]) {
        currentIndex = index
        images = photos
        imageView.contentMode = .scaleAspectFit
        nextImageView.contentMode = .scaleAspectFit
        imageView.downloadImage(urlPath: images[currentIndex].imageUrl)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panPhoto))
        addGestureRecognizer(pan)
    }
    
    
    @objc private func panPhoto(_ recognizer: UIPanGestureRecognizer){
        guard let panView = recognizer.view else { return }
        let translation = recognizer.translation(in: panView)
        let direction = PanDirection(x: translation.x)
        switch recognizer.state {
        case .began:
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.imageView.alpha = 0
            })
            if canSlide(direction: direction){
                let nextIndex = direction == .left ? currentIndex + 1 : currentIndex - 1
                nextImageView.downloadImage(urlPath: images[nextIndex].imageUrl)
                self.addSubview(nextImageView)
                let offsetX = direction == .left ? self.bounds.width : -self.bounds.width
                nextImageView.frame = self.bounds.offsetBy(dx: offsetX, dy: 0)
                animator.addAnimations({
                    self.nextImageView.center = self.imageView.center
                }, delayFactor: 0.2)
            }
            animator.addCompletion { (position) in
                guard position == .end else { return }
                self.currentIndex = direction == .left ? self.currentIndex + 1 : self.currentIndex - 1
                self.imageView.alpha = 1
                self.imageView.transform = .identity
                self.imageView.downloadImage(urlPath: self.images[self.currentIndex].imageUrl)
                self.nextImageView.removeFromSuperview()
            }
            animator.pauseAnimation()
        case .changed:
            let relativeTranslation = abs(translation.x) / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            animator.fractionComplete = progress
            
        case .ended:
            if canSlide(direction: direction), animator.fractionComplete > 0.6 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            } else {
                animator.stopAnimation(true)
                UIView.animate(withDuration: 0.2) {
                    self.imageView.transform = .identity
                    self.imageView.alpha = 1
                    let offsetX = direction == .left ? self.bounds.width : -self.bounds.width
                    self.nextImageView.frame = self.bounds.offsetBy(dx: offsetX, dy: 0)
                    self.nextImageView.transform = .identity
                }
            }
        default:
            break
        }
    }
    
    private func canSlide(direction: PanDirection) -> Bool {
        if direction == .left {
            return currentIndex < images.count - 1
        } else {
            return currentIndex > 0
        }
    }

}
