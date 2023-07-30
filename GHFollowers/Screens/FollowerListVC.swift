//
//  FollowerListVC.swift
//  GHFollowers-Refresh
//
//  Created by Jared Juangco on 27/7/23.
//

import UIKit

class FollowerListVC: UIViewController {
    
    // Enums are hashable by default.
    enum Section { case main }
    
    var username: String!
    var followers: [Follower] = []
    var collectionView: UICollectionView!
    // When we're passing in two variables that are generic,
    // they both must conform to Hashable.
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers()
        configureDataSource()
        // When passing data, you'd have to have a variable on this screen to set.
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func getFollowers() {
        NetworkManager.shared.getFollowers(for: username, page: 1) { [weak self] result in
            // [weak self] is a capture list.
            // Initially, the NetworkManager has a strong reference to the FollowerListVC.
            // This can make a memory leak, so we use the capture list to make self weak
            // and have a weak reference to the VC.
            guard let self = self else { return }
            // Since this code is in a closure, this is running in a background thread.
            // According to a WWDC 2019 video, we can say that self.updateData() is safe to call in a bg thread.
            switch result {
            case .success(let followers):
                self.followers = followers
                self.updateData()
                print("Followers.count = \(followers.count)")
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData() {
        // For data sources like this, you must always pass a section and the item.
        // The section and the item go through the hash function to give it a unique value.
        // This is how diffable data source tracks it; it tracks all the unique values in
        // the section and the items.
        // It takes a snapshot of the data and the snapshot of the new data, and then it gets
        // merged together.
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        // Put this code in the main thread
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
