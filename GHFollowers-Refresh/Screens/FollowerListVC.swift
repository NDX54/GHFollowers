//
//  FollowerListVC.swift
//  GHFollowers-Refresh
//
//  Created by Jared Juangco on 27/7/23.
//

import UIKit

class FollowerListVC: UIViewController {
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getFollowers(for: username, page: 1) { followers, errorMessage in
            guard let followers = followers else {
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: errorMessage!.rawValue, buttonTitle: "OK")
                return
            }
            
            print("Followers.count = \(followers.count)")
            print(followers)
        }
        // When passing data, you'd have to have a variable on this screen to set.
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

}
