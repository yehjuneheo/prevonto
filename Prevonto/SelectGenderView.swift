import SwiftUI

struct SelectGenderView: View {
    let next: () -> Void
    let back: () -> Void

    @State private var selectedGender: String? = nil

    let genderOptions = ["Female", "Male", "Other", "Prefer not to say"]

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Select Gender")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))

            ForEach(genderOptions, id: \.self) { gender in
                Button(action: {
                    selectedGender = gender
                }) {
                    HStack {
                        Image(systemName: icon(for: gender))
                        Text(gender)
                        Spacer()
                        Image(systemName: selectedGender == gender ? "checkmark.square.fill" : "square")
                    }
                    .padding()
                    .background(selectedGender == gender ? Color(red: 0.01, green: 0.33, blue: 0.18).opacity(0.1) : Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                }
            }

            if selectedGender == nil {
                Text("Please select a gender to continue")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, -10)
            }

            Button {
                if selectedGender != nil {
                    next()
                }
            } label: {
                Text("Let’s keep going")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(red: 0.01, green: 0.33, blue: 0.18))
                    .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
    }

    private func icon(for gender: String) -> String {
        switch gender {
        case "Female": return "plus"
        case "Male": return "person.fill"
        case "Other": return "person.crop.circle.badge.questionmark"
        default: return "questionmark.circle"
        }
    }
}
