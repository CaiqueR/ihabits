import GoogleSignIn
import SDWebImageSwiftUI
import SwiftUI

struct GoogleSignInButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            HStack {
                WebImage(url: URL(string: "https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .shadow(radius: 10)
                    .padding(5)

                Text("Sign in with Google")
                    .foregroundColor(.white)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
                .cornerRadius(5)
        })
        .frame(maxHeight: 50)
        .onAppear {}
    }
}

struct GoogleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSignInButton {
            print("Hello World")
        }
    }
}
