// This is the app's landing page, the Welcome page!
import SwiftUI

struct WelcomeView: View {
    @State private var showOnboarding = false

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
                
            // Let's Go button to go to the Onboarding pages!
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showOnboarding = true
                }
            }) {
                Text("Let's Go")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(red: 0.01, green: 0.33, blue: 0.18))
                    .cornerRadius(16)
                    .padding(.horizontal, 32)
            }
            .padding(.bottom, 40)
        }
        .background(Color.white) // or Color("BackgroundColor") if you have one
        .edgesIgnoringSafeArea(.all)
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
