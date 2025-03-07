import SwiftUI

struct OnboardingContainerView: View {
    @State private var selection = 0 // current page index
    @State private var showContent = false
    
    var body: some View {
        VStack {
            // Top bar with a styled Skip Intro button
            HStack {
                Spacer()
                Button("Skip intro") {
                    // Immediately jump to the main app
                    showContent = true
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding()
            }
            
            TabView(selection: $selection) {
                OnboardingPageView(
                    title: "Understand Yourself",
                    index: 0,
                    selection: $selection,
                    showContent: $showContent
                )
                .tag(0)
                
                OnboardingPageView(
                    title: "Track your metrics",
                    index: 1,
                    selection: $selection,
                    showContent: $showContent
                )
                .tag(1)
                
                OnboardingPageView(
                    title: "Connect with your doctors",
                    index: 2,
                    selection: $selection,
                    showContent: $showContent
                )
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // hide default dots
            
            // Custom page indicator
            HStack(spacing: 8) {
                ForEach(0..<3) { idx in
                    Circle()
                        .fill(idx == selection
                              ? Color(red: 0.01, green: 0.33, blue: 0.18)
                              : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        // If this view is ever embedded in a NavigationStack, hide the default back button:
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showContent) {
            ContentView()
        }
    }
}

struct OnboardingPageView: View {
    let title: String
    let index: Int
    @Binding var selection: Int
    @Binding var showContent: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                .padding()
            
            Spacer()
            
            // Next button
            Button {
                if selection < 2 {
                    selection += 1
                } else {
                    showContent = true
                }
            } label: {
                Image(systemName: "arrow.right")
                    .font(.title2)
                    .padding(16)
                    .foregroundColor(.white)
                    .background(Color(red: 0.01, green: 0.33, blue: 0.18))
                    .clipShape(Circle())
            }
            .padding(.bottom, 40)
        }
    }
}

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView()
    }
}
