//
//  GFButton.swift
//  GHFollowers-Refresh
//
//  Created by Jared Juangco on 27/7/23.
//

import UIKit

class GFButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Custom code
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, title: String, systemImageName: String) {
        self.init(frame: .zero)
        set(color: color, title: title, systemImageName: systemImageName)
    }
    
    private func configure() {
        // New in iOS 15, you can just invoke configuration to make changes to the design of the button.
        // configuration is Apple's default style for buttons. Refer to documentation for more details.
        // This function is a basic configuration. This is the stuff that every single button is going to have.
        
        configuration = .filled()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    final func set(color: UIColor, title: String, systemImageName: String) {
        
        // baseBackgroundColor = Color of the button.
        configuration?.baseBackgroundColor = color
        // baseForegroundColor = Color of the text.
        configuration?.baseForegroundColor = .white
        configuration?.title = title
        
        configuration?.image = UIImage(systemName: systemImageName)
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
    
}
