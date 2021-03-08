//
//  LoadImage.swift
//  VKClient
//
//  Created by Константин Кузнецов on 07.12.2020.
//

import UIKit

extension UIImage {

    static func getImageForUrl(urlPath: String) -> UIImage? {
        
        if let url = URL(string: urlPath),
           let data = try? Data(contentsOf: url){
            return UIImage(data: data)!
        } else {
            return UIImage(systemName: "photo")!
        }
    }

}

extension UIImageView{
    
    func downloadImage(urlPath: String?){
        if let urlPath = urlPath, let url = URL(string: urlPath) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, respons, error) in
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            task.resume()
        } else {
            self.image = UIImage(systemName: "photo")!
        }
    }
    
}

