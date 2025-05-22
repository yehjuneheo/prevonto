import SwiftUI

struct WeightSelectionView: View {
    @State private var selectedUnit: String = "lbs"
    @State private var selectedWeight: Int = 140

    let lbRange = Array(80...300)
    let kgRange = Array(36...136)

    let next: () -> Void
    let back: () -> Void
    let step: Int

    var currentRange: [Int] {
        selectedUnit == "lbs" ? lbRange : kgRange
    }

    var body: some View {
        OnboardingStepWrapper(step: step, title: "What is your weight?") {
            VStack(spacing: 24) {
                // Unit selection
                HStack(spacing: 32) {
                    UnitButton(title: "lbs", selected: $selectedUnit) {
                        selectedWeight = Int(Double(selectedWeight) * 2.20462)
                    }
                    UnitButton(title: "kg", selected: $selectedUnit) {
                        selectedWeight = Int(Double(selectedWeight) * 0.453592)
                    }
                }

                // Big number display
                HStack(spacing: 4) {
                    Text("\(selectedWeight)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(Color(red: 0.39, green: 0.59, blue: 0.38)) // Match design
                    Text(selectedUnit)
                        .foregroundColor(.gray)
                        .font(.title3)
                }

                // Picker
                WeightPickerView(values: currentRange, selected: $selectedWeight)

                // Next button
                Button {
                    next()
                } label: {
                    Text("Next")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(red: 0.01, green: 0.33, blue: 0.18))
                        .cornerRadius(12)
                }
            }
        }
    }
}


struct WeightPickerView: View {
    let values: [Int]
    @Binding var selected: Int

    let itemWidth: CGFloat = 40
    let spacing: CGFloat = 12

    @State private var scrollOffset: CGFloat = 0.0
    @State private var scrollViewWidth: CGFloat = 0.0

    var body: some View {
        GeometryReader { geo in
            let totalItemWidth = itemWidth + spacing
            let horizontalPadding = (geo.size.width - itemWidth) / 2

            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: spacing) {
                        ForEach(values, id: \.self) { val in
                            GeometryReader { itemGeo in
                                let center = itemGeo.frame(in: .global).midX
                                let screenCenter = geo.frame(in: .global).midX
                                let distance = abs(center - screenCenter)

                                let isSelected = distance < totalItemWidth / 2

                                Color.clear
                                    .onAppear {
                                        if isSelected {
                                            selected = val
                                        }
                                    }
                                    .onChange(of: distance) { _ in
                                        if isSelected {
                                            selected = val
                                        }
                                    }

                                VStack(spacing: 6) {
                                    Rectangle()
                                        .frame(width: 2, height: val % 10 == 0 ? 30 : 15)
                                        .foregroundColor(isSelected ? .green : .gray.opacity(0.4))

                                    if val % 10 == 0 {
                                        Text("\(val)")
                                            .font(.caption)
                                            .foregroundColor(isSelected ? .green : .gray)
                                    }
                                }
                                .frame(width: itemWidth)
                            }
                            .frame(width: itemWidth)
                            .id(val)
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                    .onAppear {
                        scrollViewWidth = geo.size.width
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            proxy.scrollTo(selected, anchor: .center)
                        }
                    }
                }
            }
        }
        .frame(height: 100)
        .overlay(
            Rectangle()
                .frame(width: 2, height: 60)
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
        )
    }
}



struct UnitButton: View {
    let title: String
    @Binding var selected: String
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: {
            if selected != title {
                selected = title
                onTap()
            }
        }) {
            Text(title)
                .fontWeight(.medium)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .frame(minWidth: 80)
                .background(selected == title ? Color(red: 0.39, green: 0.59, blue: 0.38) : Color.clear)
                .foregroundColor(selected == title ? .white : .gray)
                .cornerRadius(12)
                .shadow(color: selected == title ? Color.green.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
        }
    }
}
