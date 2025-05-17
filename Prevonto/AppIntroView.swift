// These are the Prevonto app's intro pages that displays information about the Prevonto app's main features and purpose.
import SwiftUI

struct AppIntroView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPageIndex = 0
    @State private var showContent = false
    @State private var showAdditionalContent = false

    // Timer-based interaction control to prevent user interaction until subtitle appears
    @State private var canInteract = false
    @State private var timer: Timer?

    // Subtitle delay duration constant for easy customization (3 seconds)
    let subtitleDelayDuration: TimeInterval = 3.0

    // Important variables for animating Next button movement!
    @State private var dragOffset: CGFloat = 0.0
    let maxButtonMovement: CGFloat = -30
    let swipeThreshold: CGFloat = -30

    // Content for each app intro page
    let pages = [
        AppIntroPage(
            boldTitle: "Track your ",
            italicTitle: "metrics.",
            subtitle: "We make it easy to stay in control of your health."
        ),
        AppIntroPage(
            boldTitle: "Connect with ",
            italicTitle: "your doctors.",
            subtitle: "Keep your doctor in the loop with real-time trends and information."
        ),
        AppIntroPage(
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
                    Button(action: {
                        // Stop timer when skipping to prevent memory leaks
                        stopTimer()
                        showContent = true
                    }) {
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

                // App Intro content
                VStack(spacing: showAdditionalContent ? 16 : 0) {
                    // Offset animation for title movement when subtitle appears
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
                    // Title moves up when subtitle appears
                    .offset(y: showAdditionalContent ? -20 : 0)
                    .animation(.easeInOut(duration: 0.5), value: showAdditionalContent)
                    .id(currentPageIndex)

                    if showAdditionalContent {
                        Text(pages[currentPageIndex].subtitle)
                            .font(.body)
                            .fontWeight(.light)
                            .foregroundColor(Color(red: 0.25, green: 0.33, blue: 0.44))
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                            .padding(.horizontal, 48)
                            // Enhanced transition with asymmetric movement and opacity for smooth subtitle appearance
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .move(edge: .bottom).combined(with: .opacity)
                            ))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)

                Spacer()

                // Enhanced arrow button with visual state indicators (gray when disabled, green when enabled)
                VStack(spacing: 4) {
                    Button {
                        handleNextAction()
                    } label: {
                        Image(systemName: "arrow.up")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(8)
                            // Dynamic color based on interaction state - gray when can't interact, green when can interact
                            .foregroundColor(canInteract ?
                                Color(red: 0.01, green: 0.33, blue: 0.18) :
                                Color.gray.opacity(0.5))
                    }
                    // Disable button when interaction is not allowed (during 3-second timer)
                    .disabled(!canInteract)

                    // Dynamic text based on interaction state - shows "Swipe Up for Next" only when interaction is enabled
                    if canInteract {
                        Text("Swipe Up for Next")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                            // Animated appearance of the instruction text
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        // Placeholder to maintain layout consistency when text is hidden
                        Text("")
                            .font(.caption)
                            .frame(height: 16)
                    }
                }
                .offset(y: dragOffset < 0 ? max(dragOffset, maxButtonMovement) : 0)
                .animation(.easeOut, value: dragOffset)
                .padding(.bottom, 40)
            }

            // Vertical progress bar to show user's progress on the app intro pages
            VStack {
                Spacer()
                VerticalProgressIndicator(
                    currentStep: currentPageIndex,
                    totalSteps: pages.count
                )
                Spacer()
            }
            .padding(.trailing, 16)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .background(Color.white)
        // Only processes swipes when canInteract is true
        .gesture(
            DragGesture(minimumDistance: 10)
                .onChanged { value in
                    // Only allow drag feedback when interaction is enabled
                    if value.translation.height < 0 && canInteract {
                        dragOffset = value.translation.height
                    }
                }
                .onEnded { value in
                    // Only process swipe when interaction is enabled
                    if value.translation.height < swipeThreshold && canInteract {
                        handleNextAction()
                    }
                    withAnimation(.easeOut) {
                        dragOffset = 0
                    }
                }
        )
        // Starts timer when the app intro page view appears
        .onAppear {
            startSubtitleTimer()
        }
        // Cleanup timer when view disappears to prevent memory leaks
        .onDisappear {
            stopTimer()
        }
        // Reset set timer and states when page changes
        .onChange(of: currentPageIndex) {
            canInteract = false
            showAdditionalContent = false
            startSubtitleTimer()
        }
        // Animated page transition to SignUpView page!
        .fullScreenCover(isPresented: $showContent) {
            // New Changes: Updated to use SignUpView for proper navigation
            SignUpView()
        }
    }

    // Timer management function that creates 3-second countdown before showing subtitle
    private func startSubtitleTimer() {
        stopTimer() // Ensure no existing timer is running
        timer = Timer.scheduledTimer(withTimeInterval: subtitleDelayDuration, repeats: false) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                showAdditionalContent = true
                canInteract = true
            }
        }
    }

    // Timer cleanup function to prevent memory leaks
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // Centralized action handling function for better code organization
    private func handleNextAction() {
        guard canInteract else { return }

        withAnimation(.easeInOut(duration: 0.3)) {
            if currentPageIndex < pages.count - 1 {
                currentPageIndex += 1
                // Note: onChange will handle resetting states and starting new timer
            } else {
                // Go to sign up view
                stopTimer()
                showContent = true
            }
        }
    }
}

// App Intro pages messages
struct AppIntroPage {
    let boldTitle: String
    let italicTitle: String
    let subtitle: String
}

// Vertical Progress Indicator
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

struct AppIntroView_Previews: PreviewProvider {
    static var previews: some View {
        AppIntroView()
    }
}
