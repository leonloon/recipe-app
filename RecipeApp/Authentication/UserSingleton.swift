//
//  UserSingleton.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 12/12/2020.
//

import Foundation

class UserSingleton {
    
    static let shared = UserSingleton()
    
    var name: String = ""
    
    func logout() {
        name = ""
    }
}
