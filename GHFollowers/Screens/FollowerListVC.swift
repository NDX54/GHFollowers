//
//  FollowerListVC.swift
//  GHFollowers-Refresh
//
//  Created by Jared Juangco on 27/7/23.
//

import UIKit



class FollowerListVC: GFDataLoadingVC {
    
    // Enums are hashable by default.
    enum Section { case main }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true // We're gonna flip this to follows once we meet a certain condition.
    var isSearching = false
    var isLoadingMoreFollowers = false
    
    var collectionView: UICollectionView!
    // When we're passing in two variables that are generic,
    // they both must conform to Hashable.
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    // You can either restructure this code to conform to async/await or wrap asynchronous tasks with Task {}.
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
                updateUI(with: followers)
                dismissLoadingView()
                isLoadingMoreFollowers = false
            } catch {
                // Handle errors
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Bad stuff happened", message: gfError.rawValue, buttonTitle: "OK")
                } else {
                    presentDefaultError()
                }
                
                isLoadingMoreFollowers = false
                dismissLoadingView()
            }
            //            This only presents a default error. Nothing specific.
            //            guard let followers = try? await NetworkManager.shared.getFollowers(for: username, page: page) else {
            //                presentDefaultError()
            //                dismissLoadingView()
            //                return
            //            }
            //
            //            updateUI(with: followers)
            //            dismissLoadingView()
        }
    }
    
    func updateUI(with newFollowers: [Follower]) {
        if newFollowers.count < 100 { self.hasMoreFollowers = false }
        followers.append(contentsOf: newFollowers) // What happens here is that we add a hundred more followers to the previous array of hundred followers.
        
        if followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them 😃."
            DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
            return
        }
        updateData(on: followers)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]) {
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
    
    @objc func addButtonTapped() {
        showLoadingView()
        
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                addUserToFavourites(user: user)
                dismissLoadingView()
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Bad stuff happened", message: gfError.rawValue, buttonTitle: "OK")
                } else {
                    presentDefaultError()
                }
                
                dismissLoadingView()
            }
        }
    }
    
    func addUserToFavourites(user: User) {
        let favourite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.updateWith(favourite: favourite, actionType: .add) { [weak self] error in
            guard let self else { return }
            guard let error else {
                // If error is nil, do this...
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "Success!", message: "You have successfully favourited this user. 🥳", buttonTitle: "Hooray!")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.presentGFAlert(title: "User already in favourites", message: error.rawValue, buttonTitle: "Hehe")
            }
        }
    }
}


extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            // If hasMoreFollowers returns false, none of the code below the guard statement will be executed.
            guard hasMoreFollowers, !isLoadingMoreFollowers, !isSearching else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    // This function lets us know what item we tapped on,
    // and whatever follower it is we're going to pass the follower's login onto the next screen.
    // We're going to transition to the next screen when we tap.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // When we start searching, we're using the filtered followers array and not the original array.
        // We need to do something that allows us to dynamically switch between arrays.
        
        let activeArray = isSearching ? filteredFollowers : followers // Ternary operator: var/let x = W ? T : F
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self // The FollowerListVC is now listening to the UserInfoVC.
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        // Filtered array of followers
        // $0 in a closure is an anonymous variable, in this case it's a follower
        // We're going through the follower array, and we're filtering it out based on the searchBar.text filter above
        // The username and filter is lowercased.
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

// The FollowerListVC is waiting for somebody (a view controller) to invoke the specified functions below.
// The FollowerListVC is ready to listen; it doesn't know whose gonna tell what to do yet.
// The UserInfoVC is going to tell what the FollowerListVC is going to do.
extension FollowerListVC: UserInfoVCDelegate {
    
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }

}
