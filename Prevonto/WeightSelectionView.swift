import SwiftUI

struct WeightSelectionView: View {
    @State private var selectedUnit: String = "lbs"
    @State private var selectedWeight: Int = 140

    let lbRange = Array(80...300)
    let kgRange = Array(36...136)

    let next: () -> Void
    let back: () -> Void

    var currentRange: [Int] {
        selectedUnit == "lbs" ? lbRange : kgRange
    }

    var displayText: String {
        "\(selectedWeight) \(selectedUnit)"
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("What is your\nweight?")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))

            HStack(spacing: 16) {
                UnitButton(title: "lbs", selected: $selectedUnit) {
                    selectedWeight = Int(Double(selectedWeight) * 2.20462)
                }
                UnitButton(title: "kg", selected: $selectedUnit) {
                    selectedWeight = Int(Double(selectedWeight) * 0.453592)
                }
            }

            Text(displayText)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))

            WeightPickerView(values: currentRange, selected: $selectedWeight)

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
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(selected == title ? Color(red: 0.01, green: 0.33, blue: 0.18) : Color.clear)
                .foregroundColor(selected == title ? .white : .gray)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.01, green: 0.33, blue: 0.18), lineWidth: 1)
                )
                .cornerRadius(10)
        }
    }
}
