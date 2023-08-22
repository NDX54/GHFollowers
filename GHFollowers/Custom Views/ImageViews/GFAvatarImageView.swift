//
//  GFAvatarImageView.swift
//  GHFollowers-Refresh
//
//  Created by Jared Juangco on 28/7/23.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let cache = NetworkManager.shared.cache
    let placeholderImage = Images.placeholder
    
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
    
    func downloadImage(fromURL urlString: String) {
        Task { image = await NetworkManager.shared.downloadImage(from: urlString) ?? placeholderImage }
    }
}
