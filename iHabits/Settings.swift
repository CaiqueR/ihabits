//
//  Settings.swift
//  iHabits
//
//  Created by Caique Ribeiro on 20/06/23.
//

import GoogleSignIn
import SDWebImageSwiftUI
import SwiftUI

let IDENTIFIER = "DailyNotification"

struct Settings: View {
    @AppStorage("notificationsEnabled") var notificationsEnabled = false
    @EnvironmentObject var viewModel: AuthenticationViewModel
    private let user = GIDSignIn.sharedInstance.currentUser

    var body: some View {
        NavigationView {
            Form {
                // Create a section with user details, name, email, picture, etc.
                Section(header: Text("Detalhes do usuário \(viewModel.user?.displayName ?? "")")) {
                    // Imagem do usuario

                    if user?.profile?.imageURL != nil {
                        WebImage(url: user?.profile?.imageURL(withDimension: 200))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .shadow(radius: 10).frame(maxWidth: .infinity)

                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .frame(maxWidth: .infinity)
                    }

                    Text("Nome: \(user?.profile?.name ?? "Não disponível")")
                    Text("Email: \(user?.profile?.email ?? "Não disponível")")
                    // Add user picture here
                }

                Section(header: Text("Notificações")) {
                    Toggle("Enviar notificações diárias", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { value in
                            if value {
                                requestNotificationAuthorization()
                                scheduleDailyNotifications()
                            } else {
                                cancelScheduledNotifications()
                            }
                        }
                    // Signout button
                    Button(action: {
                        viewModel.signOut()
                    }, label: {
                        Text("Sair")
                    }).foregroundColor(.red)
                }
            }.navigationBarTitle("Configurações")
        }
    }

    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
            if let error = error {
                // Tratar erro de autorização aqui
                print("Erro na autorização das notificações: \(error)")
            }
        }
    }

    func scheduleDailyNotifications() {
        let notificationTimes: [(hour: Int, minute: Int)] = [(11, 30), (12, 30), (14, 30), (18, 15), (20, 16)]

        for time in notificationTimes {
            let content = UNMutableNotificationContent()
            content.title = "Háitos completados?"
            content.body = "Não se esqueça de registrar seus hábitos diários!"
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.hour = time.hour
            dateComponents.minute = time.minute

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: "dailyNotification\(time.hour)\(time.minute)", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    // Tratar erro ao agendar notificação aqui
                    print("Erro ao agendar notificação: \(error)")
                }
            }
        }
    }

    func cancelScheduledNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyNotification"])
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
