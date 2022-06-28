//
//  GFButton.swift
//  GHFollowers
//
//  Created by Jared Juangco on 28/6/22.
//

import UIKit

class GFButton: UIButton {


    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    // Code below handles initialisation via Storyboard
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius                          = 10
        titleLabel?.textColor                       = .white
        titleLabel?.font                            = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints   = false
    }
    
}
