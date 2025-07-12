//
//  tart_prototypeApp.swift
//  tart_prototype
//
//  Created by ZhengXian Lin on 4/28/25.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

@main
struct tart_prototypeApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("✅ Amplify configured successfully")
        } catch {
            print("❌ Failed to initialize Amplify: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView()
            } else {
                LoginView()
            }
        }
    }
}
