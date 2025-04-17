//
//  SymptomsAllergyInputView.swift
//  Prevonto
//
//  Created by Yehjune Heo on 4/3/25.
//


import SwiftUI

struct SymptomsAllergyInputView: View {
    @State private var inputText: String = ""
    @State private var symptoms: [String] = ["Headache", "Muscle Fatigue"]
    @State private var navigateToContent = false
    
    let next: () -> Void
    let back: () -> Void

    let maxTags = 10

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Do you have any\nsymptoms / allergy?")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))

            VStack(alignment: .leading, spacing: 12) {
                // Tag List
                FlowLayout(tags: symptoms, deleteAction: { tag in
                    symptoms.removeAll { $0 == tag }
                })

                // TextField for input
                TextField("Type symptom or allergy...", text: $inputText, onCommit: {
                    addTag()
                })
                .onChange(of: inputText) { newValue in
                    if newValue.last == " " || newValue.last == "," {
                        addTag()
                    }
                }
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal)
                .frame(height: 40)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

                HStack {
                    Spacer()
                    Text("\(symptoms.count)/\(maxTags)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).stroke(Color.blue.opacity(0.4), lineWidth: 2))

            NavigationLink(destination: ContentView(), isActive: $navigateToContent) {
                EmptyView()
            }

            Button {
                next()
            } label: {
                Text("Done!")
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

    func addTag() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !symptoms.contains(trimmed), symptoms.count < maxTags else {
            inputText = ""
            return
        }
        symptoms.append(trimmed)
        inputText = ""
    }
}


struct FlowLayout: View {
    let tags: [String]
    var deleteAction: (String) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            FlexibleView(data: tags, spacing: 8, alignment: .leading) { tag in
                HStack(spacing: 4) {
                    Text(tag)
                        .font(.footnote)
                        .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            deleteAction(tag)
                        }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(red: 0.9, green: 1, blue: 0.95))
                .cornerRadius(16)
            }
        }
    }
}


struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content

    init(data: Data, spacing: CGFloat = 8, alignment: HorizontalAlignment = .leading,
         @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        var rows: [[Data.Element]] = [[]]

        for item in data {
            let itemSize = CGSize(width: 80, height: 30) // Approx size
            if width + itemSize.width + spacing > geometry.size.width {
                width = 0
                height += itemSize.height + spacing
                rows.append([item])
            } else {
                rows[rows.count - 1].append(item)
            }
            width += itemSize.width + spacing
        }

        return VStack(alignment: alignment, spacing: spacing) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(row, id: \.self) { item in
                        content(item)
                    }
                }
            }
        }
    }
}
