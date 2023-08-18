//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Jared Juangco on 18/8/23.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static let defaults = UserDefaults.standard
    
    enum Keys {
        static let favourites = "favorites"
    }
    
    // When adding or removing, we can get errors because the data can get improperly encoded.
    static func updateWith(favourite: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> ()) {
        retrieveFavourites { result in
            switch result {
            case .success(var favourites):
                
                switch actionType {
                case .add:
                    guard !favourites.contains(favourite) else {
                        completed(.alreadyInFavourites)
                        return
                    }

                    favourites.append(favourite)
                    
                    break
                case .remove:
                    favourites.removeAll { $0.login == favourite.login }
                    break
                }
                completed(save(favourites: favourites))
                break
            case .failure(let error):
                completed(error)
                break
            }
        }
    }
    
    // Anytime you're saving a custom object to UserDefaults, it has to be encoded/decoded.
    // It gets saved as data.
    // If we're saving something basic like an Int, Boolean, UD could hold it no problem.
    static func retrieveFavourites(completed: @escaping (Result<[Follower], GFError>) -> ()) {
        // We don't want to return an error here because it might be a first time use.
        guard let favouritesData = defaults.object(forKey: Keys.favourites) as? Data else {
            // Instead of giving an array of followers, we'll be giving back an empty array.
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            // What this says is that we want an array of followers.
            // We want to decode this, and the type we have is an array of followers.
            // We want to create that array from data.
            let favourites = try decoder.decode([Follower].self, from: favouritesData)
            completed(.success(favourites))
        } catch {
            // We don't want to use the localized description of the error because it is vague for the average user.
            // completed(nil, error.localizedDescription)
            completed(.failure(.unableToFavourite))
        }
    }
    
    // Saving = Encoding
    // Retrieving = Decoding
    static func save(favourites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavourites = try encoder.encode(favourites)
            defaults.setValue(encodedFavourites, forKey: Keys.favourites)
            return nil // nil because there will be no errors.
        } catch {
            return .unableToFavourite
        }
    }
}
