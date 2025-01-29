//
//  AuthManager.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 29/01/25.
//

import SwiftUI

class AuthManager: ObservableObject {
    static let shared = AuthManager() // Singleton instance
    @Published var isUserLoggedIn: Bool = true

    private init() {} // Prevent external instances

    func logout() {
        clearUserData()
        isUserLoggedIn = false
    }
    func clearUserData() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "ucode")
        defaults.removeObject(forKey: "isLoggedIn")
        // Perform any additional cleanup
    }
}

