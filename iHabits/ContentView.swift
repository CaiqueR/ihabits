//
//  ContentView.swift
//  iHabits
//
//  Created by Caique Ribeiro on 09/06/23.
//

import Inject
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject private var iO = Inject.observer

    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView()
            } else {
                switch viewModel.state {
                    case .signedIn: HomeView()
                    case .signedOut: LoginView()
                }
            }
        }.enableInjection()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
