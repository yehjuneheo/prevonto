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
                
            // Button to load OnboardingView
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showOnboarding = true
                }
            } label: {
                HStack {
                    Text("Let’s Go")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.01, green: 0.33, blue: 0.18))
                .cornerRadius(8)
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 40)
        }
        .background(Color.white) // or Color("BackgroundColor") if you have one
        .edgesIgnoringSafeArea(.all)
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
