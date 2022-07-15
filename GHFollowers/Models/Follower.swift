//
//  Follower.swift
//  GHFollowers
//
//  Created by Jared Juangco on 28/6/22.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String
}

/*

 Alternate version of Follower Struct - Converts login to a hashable
 
 struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String
 
    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
  }
}
 
*/
