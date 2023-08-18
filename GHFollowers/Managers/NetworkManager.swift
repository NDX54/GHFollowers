//
//  NetworkManager.swift
//  GHFollowers-Refresh
//
//  Created by Jared Juangco on 28/7/23.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    // @escaping is a type attribute that returns something. If successful, it returns completed(.success(whatever)).
    // If unsuccessful, it returns completed(.failure(whateverFailure)).
    // Array of followers can return an error since we are not guaranteed followers.
    // Error is also an optional string because if we have an array of followers, we don't have an error
    // and vice versa.*
    // * It is now an optional enum ErrorMessage
    // Network calls get a lot of error handling
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> ()) {
        let endpoint = baseURL + "/users/\(username)/followers?per_page=100&page=\(page)"
        
        // If this returns a valid URL, we're gonna get a URL.
        // Otherwise, we're going to get an error.
        // We are going to pass the error message as a string
        // in this closure to our VCs that can present
        // the error.
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        // This closure handles the data given, its response, and error should things go awry.
        // This is the basic native way to do network calls.
        // This is like the long division of doing networking.
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // If there is no error, then it is nil.
            // _ means no var name.
            // We just want to check whether it's nil.
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            
            // This code checks whether the response isn't nil.
            // If it isn't nil, we check whether the response status code is 200 otherwise
            // throw an error.
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            // If this data is good, then we have our data.
            // Otherwise throw an error.
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                // What this says is that we want an array of followers.
                // We want to decode this, and the type we have is an array of followers.
                // We want to create that array from data.
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                // We don't want to use the localized description of the error because it is vague for the average user.
                // completed(nil, error.localizedDescription)
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    // Same function from GFAvatarImageView. It's just transferred here in NetworkManager.
    func downloadImage(from urlString: String, completed: @escaping (UIImage) -> ()) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            // Once we have our image, we need to return out of the function
            // because we don't need to do the network call.
            // Otherwise if we don't have the image, do the network call below.
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            // Our placeholder image conveys the error, hence we don't handle the errors here.
            // We can set the image to the cache by using cache.setObject().
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else { return }
            
            self.cache.setObject(image, forKey: cacheKey)
            // Set the image to the main thread.
            DispatchQueue.main.async { completed(image) }
        }
        
        task.resume()
    }
    /* ABOUT CLOSURES
     
     Closures are either escaping or non-escaping; @escaping closures can outlive their respective functions.
     Closures are used for asynchronous stuff; they are called in a background thread.
     By default, closures are non-escaping; it doesn't outlive the function.
     
     Our closure can be called after a period of time. In the example of having a bad internet connection, loading the followers can take a while.
     This is why we need our closures to be escaping – we need it to live longer than the function.
     When a closure escapes, we have to do something about it.
     
     */
    
    // Repeated coding of network calls are unavoidable.
    func getUserInfo(for username: String, completed: @escaping (Result<User, GFError>) -> ()) {
        let endpoint = baseURL + "/users/\(username)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                // What this says is that we want a follower.
                // We want to decode this, and the type we have is a user.
                // We want to create that user from data.
                let user = try decoder.decode(User.self, from: data)
                completed(.success(user))
            } catch {
                // We don't want to use the localized description of the error because it is vague for the average user.
                // completed(nil, error.localizedDescription)
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
}
