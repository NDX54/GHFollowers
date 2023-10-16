//
//  FavoritesListVC.swift
//  GHFollowers-Refresh
//
//  Created by Jared Juangco on 27/7/23.
//

import UIKit

class FavouritesListVC: GFDataLoadingVC {
    
    let tableView = UITableView()
    var favourites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavourites()
    }
    
    // This function is waiting for the moment to execute code when we tell it that the content unavailable view needs updating.
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        super.updateContentUnavailableConfiguration(using: state)
        
        if favourites.isEmpty {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "star")
            config.text = "No Favourites"
            config.secondaryText = "Add a favourite on the follower list screen"
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
        
    }
    
    func configureViewController() {
        // We are in a different tab, so we have to set up the navigation controller here.
        view.backgroundColor = .systemBackground
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        // The FavouritesListVC is now listening to UITableViewDataSource and UITableViewDelegate.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    func getFavourites() {
        PersistenceManager.retrieveFavourites { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let favourites):
                self.updateUI(with: favourites)
                break
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
                }
                break
            }
        }
    }
    
    func updateUI(with favourites: [Follower]) {
        self.favourites = favourites
        setNeedsUpdateContentUnavailableConfiguration()
        DispatchQueue.main.async {
            self.favourites = favourites
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
        }
        
    }
}

extension FavouritesListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // This is our number of rows in section.
        // The number of rows that our table view will have is the number of favourite users in the array.
        return favourites.count
    }
    
    // This func gets called every time you scroll at the screen.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favourite = favourites[indexPath.row]
        cell.set(favourite: favourite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favourite = favourites[indexPath.row]
        let destVC = FollowerListVC(username: favourite.login)
        
        // push: navController
        // presenting: showing controller modally
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        PersistenceManager.updateWith(favourite: favourites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self else { return }
            guard let error else {
                self.favourites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                setNeedsUpdateContentUnavailableConfiguration()
                return
            }
            
            DispatchQueue.main.async {
                self.presentGFAlert(title: "Unable to remove", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
}

