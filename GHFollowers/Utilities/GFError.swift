//
//  GFError.swift
//  GHFollowers
//
//  Created by Jared Juangco on 30/7/23.
//

import Foundation

// This is a raw value
// Raw values conform to one type
// Associated values' cases can have different types
/// Raw value enum containing strings of error messages.
enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again"
    case unableToFavourite = "There was an error favouriting this user. Please try again."
    case alreadyInFavourites = "You've already favourited this user. You must REALLY like them!"
}
