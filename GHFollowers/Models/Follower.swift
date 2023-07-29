//
//  Follower.swift
//  GHFollowers-Refresh
//
//  Created by Jared Juangco on 27/7/23.
//

import Foundation

// When using Codable, variable names have to match with what is in the data structure.
// Furthermore, Codable combines Encodable & Decodable
// You can use camelCase instead of snake_case, but do not modify the name of the variable.
// Note about Hashable: you could write your own hashable function if you don't want
// everything to be hashable.
struct Follower: Codable, Hashable {
    // We're going to pass login to the user info screen via didSelectItem
    // And we're going to use login as a parameter to get the user's info
    var login: String
    var avatarUrl: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
    }
}
