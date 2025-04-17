import SwiftUI

struct FitnessLevelSelectionView: View {
    @State private var selectedLevel: Int = 3

    let next: () -> Void
    let back: () -> Void

    let fitnessDescriptions = [
        "Level 1 (Rarely Exercise)",
        "Level 2 (1× Exercise/Week)",
        "Level 3 (2–3× Exercise/Week)",
        "Level 4 (4–5× Exercise/Week)",
        "Level 5 (Daily Exercise)"
    ]

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("What is your\ncurrent fitness level?")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))

            DiscreteSlider(selected: $selectedLevel)

            Text(fitnessDescriptions[selectedLevel - 1])
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))

            Button {
                next()
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
        .navigationBarBackButtonHidden(true)
    }
}

struct DiscreteSlider: View {
    @Binding var selected: Int

    var body: some View {
        VStack {
            Slider(
                value: Binding(
                    get: { Double(selected) },
                    set: { newValue in
                        let rounded = Int(round(newValue))
                        if rounded != selected {
                            selected = rounded
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }
                ),
                in: 1...5,
                step: 1
            )
            .accentColor(Color(red: 0.01, green: 0.33, blue: 0.18))
        }
        .padding(.horizontal)
    }
}
