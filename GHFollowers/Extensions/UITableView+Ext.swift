//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Jared Juangco on 29/8/22.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
