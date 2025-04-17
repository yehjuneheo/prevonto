//
//  AgeSelectionView.swift
//  Prevonto
//
//  Created by Yehjune Heo on 4/3/25.
//


import SwiftUI

struct AgeSelectionView: View {
    @State private var selectedAge: Int = 19
    @State private var navigateNext = false
    
    let next: () -> Void
    let back: () -> Void

    let ageRange = Array(13...100)

    var body: some View {
            VStack(spacing: 20) {
                Spacer()

                Text("What is your age?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))

                ZStack {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.01, green: 0.33, blue: 0.18), lineWidth: 2)
                                .frame(height: 60)
                        )

                    CenteredVerticalAgePicker(ages: ageRange, selectedAge: $selectedAge)
                        .frame(height: 200)
                }

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


struct CenteredVerticalAgePicker: View {
    let ages: [Int]
    @Binding var selectedAge: Int

    let itemHeight: CGFloat = 40
    let spacing: CGFloat = 12

    var body: some View {
        GeometryReader { geo in
            let totalHeight = itemHeight + spacing
            let centerY = geo.frame(in: .global).midY

            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: spacing) {
                        ForEach(ages, id: \.self) { age in
                            GeometryReader { itemGeo in
                                let itemCenterY = itemGeo.frame(in: .global).midY
                                let distance = abs(itemCenterY - centerY)
                                let isSelected = distance < totalHeight / 2

                                Color.clear
                                    .onAppear {
                                        if isSelected {
                                            selectedAge = age
                                        }
                                    }
                                    .onChange(of: distance) { _ in
                                        if isSelected {
                                            selectedAge = age
                                        }
                                    }

                                Text("\(age)")
                                    .font(.system(size: isSelected ? 36 : 20, weight: isSelected ? .bold : .regular))
                                    .foregroundColor(isSelected ? .white : .gray)
                                    .frame(height: itemHeight)
                                    .frame(maxWidth: .infinity)
                                    .background(isSelected ? Color(red: 0.01, green: 0.33, blue: 0.18) : Color.clear)
                                    .cornerRadius(12)
                            }
                            .frame(height: itemHeight)
                            .id(age)
                        }
                    }
                    .padding(.vertical, (geo.size.height - itemHeight) / 2)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            proxy.scrollTo(selectedAge, anchor: .center)
                        }
                    }
                }
            }
        }
    }
}

