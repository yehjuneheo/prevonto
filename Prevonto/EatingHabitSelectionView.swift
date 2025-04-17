//
//  EatingHabitSelectionView.swift
//  Prevonto
//
//  Created by Yehjune Heo on 4/3/25.
//


import SwiftUI

struct EatingHabitSelectionView: View {
    @State private var selectedHabit: String? = "Mostly Vegetarian"
    @State private var navigateNext = false
    
    let next: () -> Void
    let back: () -> Void

    struct HabitOption: Identifiable {
        let id = UUID()
        let icon: String
        let label: String
    }

    let habits: [HabitOption] = [
        HabitOption(icon: "🍎", label: "Balanced Diet"),
        HabitOption(icon: "🥦", label: "Mostly Vegetarian"),
        HabitOption(icon: "🍖", label: "Low Carb"),
        HabitOption(icon: "🥗", label: "Gluten Free")
    ]

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("What are your usual\neating habits?")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))

            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
                ForEach(habits) { habit in
                    Button(action: {
                        selectedHabit = habit.label
                    }) {
                        VStack(spacing: 12) {
                            Text(habit.icon)
                                .font(.system(size: 32))
                            Text(habit.label)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(habit.label == selectedHabit ? Color(red: 0.01, green: 0.33, blue: 0.18) : Color.white)
                        )
                        .foregroundColor(habit.label == selectedHabit ? .white : .black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(habit.label == selectedHabit ? Color(red: 0.8, green: 0.2, blue: 0.2) : Color.clear, lineWidth: 2)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                }
            }

            Button {
                next()
            } label: {
                Text("Two more to go!")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(red: 0.01, green: 0.33, blue: 0.18))
                    .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
