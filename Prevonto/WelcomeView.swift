// This is the app's landing page, the Welcome page!
import SwiftUI

struct WelcomeView: View {
    @State private var showOnboarding = false
    @State private var dragOffset: CGFloat = 0.0
    
    // Important variables for helping animate Next button movement!
    let maxButtonMovement: CGFloat = -30
    let swipeThreshold: CGFloat = -30

    var body: some View {
        VStack {
            Spacer()
            
            // Prevonto title
            Text("Prevonto")
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
            
            // Prevonto app slogan
            Text("Let’s Take Control...")
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(Color(red: 0.25, green: 0.33, blue: 0.44))
                .foregroundColor(Color(red: 0.25, green: 0.33, blue: 0.44))
                
            Spacer()
                
            // Next button to go to the Onboarding pages!
            VStack(spacing: 4) {
                Image(systemName: "arrow.up")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                Text("Next")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
            }
            // Clamps the offset to maxButtonMovement
            .offset(y: dragOffset < 0 ? max(dragOffset, maxButtonMovement) : 0)
            .animation(.easeOut, value: dragOffset)
            .padding(.bottom, 40)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showOnboarding = true
                }
            }
        }
        .background(Color.white) // or Color("BackgroundColor") if you have one
        .edgesIgnoringSafeArea(.all)
        // Implemented swipe up functionality to go to the Onboarding page
        .gesture(
            DragGesture(minimumDistance: 10)
                .onChanged { value in
                    // Only respond to upward drags
                    if value.translation.height < 0 {
                        dragOffset = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height < swipeThreshold {
                        // User swiped up far enough and successfully goes to the Onboarding page!
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showOnboarding = true
                        }
                    }
                    // Resets offset to animate the Next button back to its original location!
                    withAnimation(.easeOut) {
                        dragOffset = 0
                    }
                }
        )
        // Animated page transition to Onboarding page!
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingContainerView()
                .transition(.move(edge: .bottom))
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
