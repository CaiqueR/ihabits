//
//  LoginView.swift
//  iHabits
//
//  Created by Caique Ribeiro on 21/06/23.
//

import AuthenticationServices
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            VStack {
                Text("iHabits")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                GoogleSignInButton {
                    viewModel.signIn()
                }
                .frame(width: 280, height: 45)
                .padding(.bottom)

            }.padding()
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
