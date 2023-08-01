//
//  GFSecondaryTitleLabel.swift
//  GHFollowers
//
//  Created by Jared Juangco on 1/8/23.
//

import UIKit

class GFSecondaryTitleLabel: UILabel {
    // Copy paste errors are a thing, and they are hard to debug
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(fontSize: CGFloat) {
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        configure()
    }
    
    private func configure() {
        textColor = .secondaryLabel
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        // We can tell how much the label will shrink by the minimumScaleFactor variable.
        minimumScaleFactor = 0.90
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
