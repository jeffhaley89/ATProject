//
//  UIImageView+ATProject.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/27/21.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class PlacePhotoImageView: UIImageView {
    let service: RestaurantsService = DefaultRestaurantsService()
    
    func setImage(reference: String?) {
        guard let reference = reference else {
            setDefaultImage()
            return
        }

        if let imageFromCache = imageCache.object(forKey: reference as NSString) {
            image = imageFromCache
        } else {
            setDefaultImage()
            loadImage(reference: reference) { [weak self] loadedImage in
                guard let image = loadedImage else { return }
                self?.image = image
                imageCache.setObject(image, forKey: reference as NSString)
            }
        }
    }
    
    private func loadImage(reference: String, completion: @escaping (UIImage?) -> ()) {
        service.getPlacePhoto(with: reference) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(image):
                    completion(image)

                case let .failure(error):
                    print(error)
                    completion(nil)
                }
            }
        }
    }
    
    private func setDefaultImage() {
        image = UIImage(image: .atDefault)
    }
}
