//
//  MedicationSelectionView.swift
//  Prevonto
//
//  Created by Yehjune Heo on 4/3/25.
//


import SwiftUI

struct MedicationSelectionView: View {
    @State private var selectedMeds: [String] = ["Aspirin", "Ibuprofen"]
    @State private var searchQuery: String = ""
    @State private var navigateNext = false
    
    let next: () -> Void
    let back: () -> Void

    let allMedications = [
        "Abilify", "Abilify Maintena", "Abiraterone", "Acetaminophen",
        "Actemra", "Axpelliarmus", "Aspirin", "Ibuprofen", "Xanax", "Zoloft"
    ]

    var filteredMedications: [String] {
        if searchQuery.isEmpty {
            return allMedications
        } else {
            return allMedications.filter { $0.lowercased().contains(searchQuery.lowercased()) }
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Text("What medications\ndo you take?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                .multilineTextAlignment(.center)

            // Search bar (optional visual letter navigation skipped for now)
            HStack {
                TextField("Search medications", text: $searchQuery)
                    .padding(.horizontal)
                    .frame(height: 40)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)

            // Medication list
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(filteredMedications, id: \.self) { med in
                        HStack {
                            Text(med)
                                .foregroundColor(.primary)
                            Spacer()
                            Button(action: {
                                if selectedMeds.contains(med) {
                                    selectedMeds.removeAll { $0 == med }
                                } else {
                                    selectedMeds.append(med)
                                }
                            }) {
                                Image(systemName: selectedMeds.contains(med) ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(selectedMeds.contains(med) ? Color(red: 0.01, green: 0.33, blue: 0.18) : .gray)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }

            // Selected chips
            if !selectedMeds.isEmpty {
                HStack {
                    Text("Selected:")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(selectedMeds, id: \.self) { med in
                                HStack(spacing: 4) {
                                    Text(med)
                                        .font(.footnote)
                                    Image(systemName: "xmark.circle.fill")
                                        .onTapGesture {
                                            selectedMeds.removeAll { $0 == med }
                                        }
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(16)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }

            Button {
                next()
            } label: {
                Text("One more!")
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
