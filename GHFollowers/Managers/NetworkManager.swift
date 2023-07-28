//
//  NetworkManager.swift
//  GHFollowers-Refresh
//
//  Created by Jared Juangco on 28/7/23.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.github.com"
    
    private init() {}
    
    // @escaping is a type attribute that returns something.
    // Array of followers can return an error since we are not guaranteed followers.
    // Error is also an optional string because if we have an array of followers, we don't have an error
    // and vice versa.*
    // * It is now an optional enum ErrorMessage
    // Network calls get a lot of error handling
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
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
        
        // This closure handles the data given, its response, and error should
        // things go awry.
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
                // We want to decode this, and the type we have is an array
                // of followers.
                // We want to create that array from data.
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
//                completed(nil, error.localizedDescription)
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
