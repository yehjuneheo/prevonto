import SwiftUI

struct EmotionSelectionView: View {
    @State private var selectedEmotionIndex = 2

    let next: () -> Void
    let back: () -> Void

    let emotions: [(icon: String, description: String)] = [
        ("😔", "sad"),
        ("🙁", "a bit down"),
        ("😐", "neutral"),
        ("🙂", "content"),
        ("😄", "happy")
    ]

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("What is your\ncurrent emotion right now?")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))

            EmotionScrollPicker(emotions: emotions, selectedIndex: $selectedEmotionIndex)

            Text("I’m feeling \(emotions[selectedEmotionIndex].description).")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.2))

            Button {
                next()
            } label: {
                Text("Three more!")
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

struct EmotionScrollPicker: View {
    let emotions: [(icon: String, description: String)]
    @Binding var selectedIndex: Int

    let itemWidth: CGFloat = 70
    let spacing: CGFloat = 24

    @State private var scrollOffset: CGFloat = 0
    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let totalWidth = CGFloat(emotions.count) * (itemWidth + spacing)
            let center = geo.size.width / 2

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(emotions.indices, id: \.self) { index in
                        let position = CGFloat(index) * (itemWidth + spacing)
                        let distance = abs((scrollOffset + dragOffset) - position)
                        let scale = max(1.0, 1.2 - (distance / 200))
                        let isSelected = index == selectedIndex

                        Text(emotions[index].icon)
                            .font(.system(size: 40))
                            .frame(width: itemWidth, height: itemWidth)
                            .background(isSelected ? Color(red: 0.01, green: 0.33, blue: 0.18) : Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .scaleEffect(scale)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: dragOffset)
                    }
                }
                .padding(.horizontal, (geo.size.width - itemWidth) / 2)
                .background(GeometryReader {
                    Color.clear.preference(key: ScrollOffsetKey.self,
                                           value: -$0.frame(in: .named("scroll")).origin.x)
                })
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    scrollOffset = value

                    let rawIndex = (value + center - itemWidth / 2) / (itemWidth + spacing)
                    let newIndex = min(max(0, Int(round(rawIndex))), emotions.count - 1)
                    if newIndex != selectedIndex {
                        selectedIndex = newIndex
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                }
            }
            .coordinateSpace(name: "scroll")
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width * -1
                    }
            )
        }
        .frame(height: 100)
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
