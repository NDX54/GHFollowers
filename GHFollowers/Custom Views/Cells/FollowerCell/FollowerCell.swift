//
//  FollowerCell.swift
//  GHFollowers-Refresh
//
//  Created by Jared Juangco on 28/7/23.
//

import UIKit
import SwiftUI

class FollowerCell: UICollectionViewCell {
    
    static let reuseID = "FollowerCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // iOS 17 Update: No need for the UIKit stuff and version check.
    func set(follower: Follower) {
        contentConfiguration = UIHostingConfiguration { FollowerView(follower: follower) }
    }
    
}
