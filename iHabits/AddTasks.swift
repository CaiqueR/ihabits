//
//  AddTasks.swift
//  iHabits
//
//  Created by Caique Ribeiro on 25/06/23.
//

import Inject
import SwiftUI

let DESC = "Descrição"

struct AddTasks: View {
    @EnvironmentObject var viewModel: FirestoreManager
    @ObservedObject private var iO = Inject.observer

    var habitId: String?
    @State private var habitName = ""
    @State private var habitDescription = DESC

    @Environment(\.dismiss) var dismiss

    init(habit: Habit? = nil) {
        _habitName = State(initialValue: habit?.name ?? "")
        _habitDescription = State(initialValue: habit?.description ?? DESC)
        habitId = habit?.id

    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalhes do novo hábito")) {
                    TextField("Nome", text: $habitName)
                    TextEditor(text: $habitDescription).foregroundColor(habitDescription == DESC ? .gray : .primary)
                        .onTapGesture {
                            if habitDescription == DESC {
                                habitDescription = ""
                            }
                        }
                }
            }
            .navigationTitle(habitId == nil ? "Novo Hábito" : "Editar Hábito")
            .navigationBarItems(trailing: Button("Salvar", action: saveHabit))
        }.enableInjection()
    }

    func saveHabit() {
        if habitId != nil {
            viewModel.updateHabit(habitId: habitId!, name: habitName, description: habitDescription)
            dismiss()
            return
        }
        
        viewModel.addHabit(name: habitName, description: habitDescription)
        dismiss()
    }
}

struct AddTasks_Previews: PreviewProvider {
    static var previews: some View {
        AddTasks()
    }
}
