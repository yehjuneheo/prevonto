import SwiftUI

struct WelcomeView: View {
    @State private var showOnboarding = false

    var body: some View {
        VStack {
            Spacer()
                
            Text("Prevonto")
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                        
            Text("Let’s Take Control...")
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(Color(red: 0.25, green: 0.33, blue: 0.44))
                .foregroundColor(Color(red: 0.25, green: 0.33, blue: 0.44))
                
            Spacer()
                
            // Next button to go to the Onboarding pages!
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showOnboarding = true
                }
            } label: {
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
            }
            .padding(.bottom, 40)
        }
        .background(Color.white) // or Color("BackgroundColor") if you have one
        .edgesIgnoringSafeArea(.all)
        // Implemented swipe up to go to the Onboarding page
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    let verticalAmount = value.translation.height
                    let horizontalAmount = value.translation.width
                    // Only trigger on upward swipe (negative y), and mostly vertical
                    if abs(verticalAmount) > abs(horizontalAmount) && verticalAmount < -50 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showOnboarding = true
                        }
                    }
                }
        )
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
