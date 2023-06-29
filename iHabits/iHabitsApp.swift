//
//  iHabitsApp.swift
//  iHabits
//
//  Created by Caique Ribeiro on 09/06/23.
//

import Firebase
import SwiftUI

@main
struct iHabitsApp: App {
    @StateObject var viewModel = AuthenticationViewModel()

    init() {
        setupAuthentication()
    }

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}

extension iHabitsApp {
    private func setupAuthentication() {
        FirebaseApp.configure()
    }
}
