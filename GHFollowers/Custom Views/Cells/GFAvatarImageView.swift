//
//  GFAvatarImageView.swift
//  GHFollowers-Refresh
//
//  Created by Jared Juangco on 28/7/23.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let cache = NetworkManager.shared.cache
    let placeholderImage = UIImage(named: "avatar-placeholder")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            // Once we have our image, we need to return out of the function
            // because we don't need to do the network call.
            // Otherwise if we don't have the image, do the network call below.
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Our placeholder image conveys the error, hence we don't handle the errors here.
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            // We can set the image to the cache by using cache.setObject()
            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: cacheKey)
            // Set the image to the main thread.
            DispatchQueue.main.async { self.image = image }
        }
        
        task.resume()
    }

}
