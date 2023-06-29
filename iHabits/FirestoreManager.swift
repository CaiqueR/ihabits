//
//  FirestoreManager.swift
//  iHabits
//
//  Created by Caique Ribeiro on 25/06/23.
//

import Firebase
import Foundation

struct Habit: Identifiable {
    let id: String
    let name: String
    let description: String?
    var dateHabitCompleted: [Date]

    var isCompletedToday: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return dateHabitCompleted.contains { Calendar.current.isDate($0, inSameDayAs: today) }
    }
}

class FirestoreManager: ObservableObject {
    @Published var habits = [Habit]()
    @Published var loading = true

    func fetchHabits() {
        let db = Firestore.firestore()

        let docRef = db.collection("habits")
        docRef.getDocuments { snapshot, error in
            guard error == nil else {
                print("Error while fetching tasks", error ?? "")
                return
            }

            self.habits.removeAll()

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()

                    let id = document.documentID

                    let name = data["name"] as? String ?? ""
                    let description = data["description"] as? String ?? ""

                    if let dateHabitCompleted = data["dateHabitCompleted"] as? [Timestamp] {
                        let dates = dateHabitCompleted.map { $0.dateValue() }

                        self.habits.append(Habit(id: id, name: name, description: description, dateHabitCompleted: dates))
                    }
                }
            }
        }

        loading = false
    }

    func toggleCompletion(for habit: Habit) {
        let habitRef = Firestore.firestore().collection("habits").document(habit.id)

        habitRef.getDocument { document, error in
            if let error = error {
                print("Error fetching habit document: \(error)")
                return
            }

            guard let document = document, document.exists, var data = document.data() else {
                print("Habit document does not exist or is missing data.")
                return
            }

            var dateHabitCompleted = data["dateHabitCompleted"] as? [Timestamp] ?? []

            let today = Calendar.current.startOfDay(for: Date())

            if habit.isCompletedToday {
                dateHabitCompleted.removeAll { Calendar.current.isDate($0.dateValue(), inSameDayAs: today) }
            } else {
                dateHabitCompleted.append(Timestamp(date: Date()))
            }

            data["dateHabitCompleted"] = dateHabitCompleted

            habitRef.updateData(data) { error in
                if let error = error {
                    print("Error updating habit document: \(error)")
                } else {
                    print("Habit document updated successfully")
                    self.habits = self.habits.map { habit in
                        if habit.id == document.documentID {
                            return Habit(id: habit.id, name: habit.name, description: habit.description, dateHabitCompleted: dateHabitCompleted.map { $0.dateValue() })
                        } else {
                            return habit
                        }
                    }
                }
            }
        }
    }

    func deleteHabit(for habit: Habit) {
        let db = Firestore.firestore()

        let docRef = db.collection("habits").document(habit.id)
        docRef.delete()

        fetchHabits()
    }

    func addHabit(name: String, description: String?) {
        let db = Firestore.firestore()

        var habitData: [String: Any] = [
            "name": name,
            "dateHabitCompleted": [Timestamp]()
        ]

        if let description = description {
            habitData["description"] = description
        }

        db.collection("habits").addDocument(data: habitData) { error in
            if let error = error {
                print("Error adding habit: \(error)")
            } else {
                print("Habit added successfully")
                self.fetchHabits() // Fetch habits again to update the local list
            }
        }
    }

    func updateHabit(habitId: String, name: String, description: String?) {
        let db = Firestore.firestore()

        var habitData: [String: Any] = [
            "name": name,
            "dateHabitCompleted": [Timestamp]()
        ]

        if let description = description {
            habitData["description"] = description
        }

        db.collection("habits").document(habitId).updateData(habitData) { error in
            if let error = error {
                print("Error updating habit: \(error)")
            } else {
                print("Habit updated successfully")
                self.fetchHabits() // Fetch habits again to update the local list
            }
        }
    }
}
