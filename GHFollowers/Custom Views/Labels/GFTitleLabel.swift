//
//  GFTitleLabel.swift
//  GHFollowers-Refresh
//
//  Created by Jared Juangco on 27/7/23.
//

import UIKit

class GFTitleLabel: UILabel {
    
    // This is a designated initialiser.
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // convenience inits have to call designated initialisers.
    // This means that we don't have to call configure() here because it calls the designated initialiser above.
    // Designated initialisers are what is required from the objects.
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    private func configure() {
        textColor = .label
        adjustsFontSizeToFitWidth = true
        // We can tell how much the label will shrink by the minimumScaleFactor variable.
        minimumScaleFactor = 0.90
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
