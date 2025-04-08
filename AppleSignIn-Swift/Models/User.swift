//
//  User.swift
//  AppleSignIn-Swift
//
//  Created by Sanket Vaghela on 08/04/25.
//

import Foundation

struct User {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    
    init(id: String, firstName: String, lastName: String, email: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
