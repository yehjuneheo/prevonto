//
//  SleepLevelSelectionView.swift
//  Prevonto
//
//  Created by Yehjune Heo on 4/3/25.
//


import SwiftUI

struct SleepLevelSelectionView: View {
    @State private var sleepLevel: Int = 3
    @State private var navigateNext = false
    
    let next: () -> Void
    let back: () -> Void

    let descriptions = [
        ("😴 Very Low", "~0–3hr daily"),
        ("😪 Low", "~3–5hr daily"),
        ("💤 Moderate", "~5–8hr daily"),
        ("😌 High", "~8–10hr daily"),
        ("🛌 Excellent", "10+ hr daily")
    ]

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("What is your\ncurrent sleep level?")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))

            ZStack {
                DiagonalSleepSliderView(sleepLevel: $sleepLevel)

                VStack(alignment: .leading, spacing: 4) {
                    Text(descriptions[sleepLevel - 1].0)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                    Text(descriptions[sleepLevel - 1].1)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .offset(x: -100, y: -60)

                Text("\(sleepLevel)")
                    .font(.system(size: 72, weight: .bold))
                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.2))
                    .offset(x: 100, y: 60)
            }
            .frame(height: 250)
            
            Button {
                next()
            } label: {
                Text("Almost Done!")
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


struct DiagonalSleepSliderView: View {
    @Binding var sleepLevel: Int

    let totalLevels = 5
    let trackLength: CGFloat = 200
    let stepDistance: CGFloat = 50 // distance between points

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let angle = Angle(degrees: -45)
            let vector = CGVector(dx: cos(angle.radians), dy: sin(angle.radians))

            ZStack {
                // Diagonal line
                Path { path in
                    path.move(to: CGPoint(
                        x: center.x + vector.dx * -trackLength / 2,
                        y: center.y + vector.dy * -trackLength / 2
                    ))
                    path.addLine(to: CGPoint(
                        x: center.x + vector.dx * trackLength / 2,
                        y: center.y + vector.dy * trackLength / 2
                    ))
                }
                .stroke(Color.gray.opacity(0.3), lineWidth: 4)

                // Circles for levels
                ForEach(0..<totalLevels) { i in
                    let offset = CGFloat(i - 2) * stepDistance
                    let x = center.x + vector.dx * offset
                    let y = center.y + vector.dy * offset

                    Circle()
                        .fill(i + 1 == sleepLevel ? Color(red: 0.01, green: 0.33, blue: 0.18) : Color.gray.opacity(0.4))
                        .frame(width: 16, height: 16)
                        .position(x: x, y: y)
                }

                // Draggable diamond handle
                let dragOffset = CGFloat(sleepLevel - 3) * stepDistance
                let handleX = center.x + vector.dx * dragOffset
                let handleY = center.y + vector.dy * dragOffset

                DiamondShape()
                    .fill(Color(red: 0.01, green: 0.33, blue: 0.18))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)
                    )
                    .position(x: handleX, y: handleY)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let dx = value.translation.width * vector.dx + value.translation.height * vector.dy
                                let stepsMoved = Int(round(dx / stepDistance))
                                let newLevel = min(max(1, 3 + stepsMoved), totalLevels)
                                if newLevel != sleepLevel {
                                    sleepLevel = newLevel
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                }

                            }
                    )

            }
        }
    }
}


struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: CGPoint(x: center.x, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: center.y))
        path.addLine(to: CGPoint(x: center.x, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: center.y))
        path.closeSubpath()
        return path
    }
}
