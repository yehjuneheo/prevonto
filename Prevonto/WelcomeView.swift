import SwiftUI

struct WelcomeView: View {
    @State private var showContent = false
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Prevonto")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                
                Text("Let’s Take Control...")
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.25, green: 0.33, blue: 0.44))
                    .padding(.top, 4)
                
                Spacer()
                
                // NavigationLink to OnboardingView
                NavigationLink(destination: OnboardingContainerView()) {
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
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
