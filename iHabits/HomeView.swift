//
//  HomeView.swift
//  iHabits
//
//  Created by Caique Ribeiro on 21/06/23.
//

import GoogleSignIn
import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel = FirestoreManager()

    @State var showSheet = false
    @State var habitSelected: Habit?

    var body: some View {
        TabView {
            Group {
                NavigationView {
                    List {
                        if viewModel.loading {
                            ProgressView()
                        } else {
                            ForEach(viewModel.habits) { habit in
                                HStack {
                                    Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(habit.isCompletedToday ? .green : .black)
                                        .onTapGesture {
                                            viewModel.toggleCompletion(for: habit)
                                        }
                                        .animation(.easeInOut)
                                    VStack(alignment: .leading) {
                                        Text(habit.name)
                                            .font(.headline)
                                        Text(habit.description ?? "")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        viewModel.toggleCompletion(for: habit)
                                    } label: {
                                        Label("Check", systemImage: habit.isCompletedToday ? "minus" : "checkmark")
                                    }
                                    .tint(habit.isCompletedToday ? .red : .green)
                                }
                                .contextMenu {
                                    Button {
                                        viewModel.toggleCompletion(for: habit)
                                    } label: {
                                        Label(habit.isCompletedToday ? "Desfazer" : "Completar", systemImage: habit.isCompletedToday ? "minus" : "checkmark")
                                    }
                                    Button {
                                        habitSelected = habit
                                        showSheet.toggle()
                                    } label: {
                                        Label("Editar", systemImage: "pencil")
                                    }
                                    Button {
                                        viewModel.deleteHabit(for: habit)

                                    } label: {
                                        Label("Deletar", systemImage: "trash")
                                    }
                                }
                            }.onDelete(perform: { indexSet in
                                viewModel.deleteHabit(for: viewModel.habits[indexSet.first!])
                            })
                        }
                    }
                    .refreshable {
                        viewModel.fetchHabits()
                    }
                    .navigationTitle("Hábitos")
                    .navigationBarItems(trailing: Button("Add +") {
                        showSheet.toggle()
                    })
                }.tabItem {
                    Label("Tarefas", systemImage: "person.fill")
                }.onAppear {
                    viewModel.fetchHabits()
                    UITabBar.appearance().backgroundColor = colorScheme == .dark ? .white : .systemGray6
                }
                Settings().tabItem {
                    Label("Configurações", systemImage: "gear")
                }
            }
        }.sheet(isPresented: $showSheet) {
            AddTasks(habit: habitSelected)
                .environmentObject(viewModel)
        }
        .toolbarBackground(.green, for: .tabBar)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
