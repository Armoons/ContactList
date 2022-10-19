//
//  UserModel.swift
//  ContactList
//
//  Created by Stepanyan Arman  on 19.10.2022.
//

import Foundation

struct ParserModel: Decodable {
    let results: [UserModel]
}

struct userName: Decodable {
    let first: String
    let last: String
}

struct userLocation: Decodable {
    let timezone: userTimezone
}

struct userTimezone: Decodable {
    let offset: String
    let description: String
}

struct userDob: Decodable {
    let date: String
    let age: Int
}

struct userPicture: Decodable {
    let thumbnail: String
}

class UserModel: Decodable {
    var gender: String
    var name: userName
    var location: userLocation
    var email: String
    var dob: userDob
    var picture: userPicture

    
    init(gender: String,  name: userName,  location: userLocation,  email: String,  dob: userDob,  picture: userPicture) {
        self.gender = gender
        self.name = name
        self.location = location
        self.email = email
        self.dob = dob
        self.picture = picture
    }
    
}

