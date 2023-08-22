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
    let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // @escaping is a type attribute that returns something. If successful, it returns completed(.success(whatever)).
    // If unsuccessful, it returns completed(.failure(whateverFailure)).
    // Array of followers can return an error since we are not guaranteed followers.
    // Error is also an optional string because if we have an array of followers, we don't have an error
    // and vice versa.*
    // * It is now an optional enum ErrorMessage
    // UPDATE 2: Refactored all of the code here to use async and async throws where appropriate.
    // Network calls get a lot of error handling
    
    // New in iOS 15 - Swift 5.5 - async/await
    // When we want to throw an error, we just type in throw.
    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        let endpoint = baseURL + "/users/\(username)/followers?per_page=100&page=\(page)"
        
        // If this returns a valid URL, we're gonna get a URL.
        // Otherwise, we're going to get an error.
        // We are going to pass the error message as a string
        // in this closure to our VCs that can present
        // the error.
        guard let url = URL(string: endpoint) else { throw GFError.invalidUsername }
        
        // If this fails, getFollowers will throw an error based on this tuple failing.
        // This tuple does not return an optional.
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // This code checks whether the response isn't nil.
        // If it isn't nil, we check whether the response status code is 200 otherwise
        // throw an error.
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw GFError.invalidResponse }
        
        do {
            // What this says is that we want an array of followers.
            // We want to decode this, and the type we have is an array of followers.
            // We want to create that array from data.
            return try decoder.decode([Follower].self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
    
    // Same function from GFAvatarImageView. It's just transferred here in NetworkManager.
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            // Once we have our image, we need to return out of the function.
            // Otherwise if we don't have the image, do the network call below.
            return image
        }
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
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
    func getUserInfo(for username: String) async throws -> User {
        let endpoint = baseURL + "/users/\(username)"
        
        guard let url = URL(string: endpoint) else { throw GFError.invalidUsername }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw GFError.invalidResponse }
        
        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
    
}
