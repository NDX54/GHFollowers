//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Jared Juangco on 30/7/23.
//

import UIKit


enum UIHelper {
    
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        // What this variable is giving us is the full width of screen,
        // we're subtracting the padding on either side of the screen,
        // and we're also subtracting the minimum spacing on the left middle
        // and right middle of the column.
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(with: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
}
