//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Jared Juangco on 29/8/22.
//

import UIKit

extension UIView {
    
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    // Variadic parameter: Can pass any number of views into addSubviews
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
