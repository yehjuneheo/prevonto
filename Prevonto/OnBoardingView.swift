import SwiftUI

struct OnboardingContainerView: View {
    @State private var currentPageIndex = 0
    @State private var showContent = false
    @State private var showAdditionalContent = false
    @Environment(\.dismiss) private var dismiss
    
    // Content for each onboarding page
    let pages = [
        OnboardingPage(
            boldTitle: "Track your ",
            italicTitle: "metrics.",
            subtitle: "We make it easy to stay in control of your health."
        ),
        OnboardingPage(
            boldTitle: "Connect with ",
            italicTitle: "your doctors.",
            subtitle: "Keep your doctor in the loop with real-time trends and information."
        ),
        OnboardingPage(
            boldTitle: "Understand ",
            italicTitle: "yourself",
            subtitle: "See your unique trends from your data and turn them into decisions that work for you."
        )
    ]
    
    var body: some View {
        ZStack {
            // Main content
            VStack {
                // Skip intro button
                HStack {
                    Spacer()
                    Button(action: { showContent = true }) {
                        HStack(spacing: 2) {
                            Text("Skip intro")
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                        .font(.system(size: 16, weight: .regular))
                    }
                    .padding(.top, 24)
                    .padding(.trailing, 24)
                }
                
                Spacer()
                
                // Onboarding content
                VStack(spacing: showAdditionalContent ? 16 : 0) {
                    VStack(spacing: 0) {
                        Text(pages[currentPageIndex].boldTitle)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                            .multilineTextAlignment(.center)
                        Text(pages[currentPageIndex].italicTitle)
                            .font(.system(size: 45, weight: .light))
                            .italic()
                            .tracking(2)
                            .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                            .multilineTextAlignment(.center)
                    }
                    if showAdditionalContent {
                        Text(pages[currentPageIndex].subtitle)
                            .font(.body)
                            .fontWeight(.light)
                            .foregroundColor(Color(red: 0.25, green: 0.33, blue: 0.44))
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                            .padding(.horizontal, 48)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Next button
                VStack(spacing: 4) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if showAdditionalContent {
                                // Move to next page
                                if currentPageIndex < pages.count - 1 {
                                    currentPageIndex += 1
                                    showAdditionalContent = false
                                } else {
                                    // Go to sign up view
                                    showContent = true
                                }
                            } else {
                                // Show additional content
                                showAdditionalContent = true
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(8)
                            .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                    }
                    
                    Text("Next")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                }
                .padding(.bottom, 40)
            }
            
            // Vertical progress indicator
            VStack {
                Spacer()
                VerticalProgressIndicator(
                    currentStep: currentPageIndex * 2 + (showAdditionalContent ? 1 : 0),
                    totalSteps: pages.count * 2
                )
                Spacer()
            }
            .padding(.trailing, 16)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .background(Color.white)
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    let verticalAmount = value.translation.height
                    let horizontalAmount = value.translation.width
                    
                    // Ensure the drag is more vertical than horizontal
                    if abs(verticalAmount) > abs(horizontalAmount) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if verticalAmount < 0 {
                                // Swipe up
                                if showAdditionalContent {
                                    // Move to next page
                                    if currentPageIndex < pages.count - 1 {
                                        currentPageIndex += 1
                                        showAdditionalContent = false
                                    } else {
                                        // Go to sign up view
                                        showContent = true
                                    }
                                } else {
                                    // Show additional content
                                    showAdditionalContent = true
                                }
                            } else {
                                // Swipe down
                                if showAdditionalContent {
                                    // Hide additional content
                                    showAdditionalContent = false
                                } else if currentPageIndex > 0 {
                                    // Go to previous page with additional content shown
                                    currentPageIndex -= 1
                                    showAdditionalContent = true
                                } else {
                                    // Go to the Welcome page
                                    dismiss()
                                }
                            }
                        }
                    }
                }
        )
        .fullScreenCover(isPresented: $showContent) {
            AuthView()
        }
    }
}

// Data model for onboarding page content
struct OnboardingPage {
    let boldTitle: String
    let italicTitle: String
    let subtitle: String
}

// Custom vertical progress indicator
struct VerticalProgressIndicator: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Capsule()
                    .fill(index == currentStep
                          ? Color(red: 0.01, green: 0.33, blue: 0.18)
                          : Color.gray.opacity(0.3))
                    .frame(width: 4, height: index == currentStep ? 36 : 12)
            }
        }
    }
}

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView()
    }
}
