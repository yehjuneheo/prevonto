import SwiftUI

struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var acceptedTerms = false
    @State private var navigateToGender = false

    @State private var showValidationMessage = false
    @State private var errorMessage = ""
    
    let testMode = true
    

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Spacer()

                Text("Let’s get Started")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))

                Text("Random Quote ...............................")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.7))

                Group {
                    TextField("Full Name", text: $fullName)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $password)
                    SecureField("Confirm Password", text: $confirmPassword)
                }
                .padding(.horizontal)
                .frame(height: 44)
                .background(Color.white)
                .overlay(Rectangle().frame(height: 1).padding(.top, 43), alignment: .top)
                .foregroundColor(.gray)

                Toggle(isOn: $acceptedTerms) {
                    Text("By continuing you accept our Privacy Policy and Term of Use")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .toggleStyle(CheckboxToggleStyle())
                .padding(.top, 8)

                if showValidationMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                NavigationLink(destination: OnboardingFlowView(), isActive: $navigateToGender) {
                    EmptyView()
                }

                Button(action: {
                    if testMode {
                        navigateToGender = true
                    } else {
                        if fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                            errorMessage = "Please fill in all fields."
                            showValidationMessage = true
                        } else if password != confirmPassword {
                            errorMessage = "Passwords do not match."
                            showValidationMessage = true
                        } else if !acceptedTerms {
                            errorMessage = "Please accept the terms and conditions."
                            showValidationMessage = true
                        } else {
                            showValidationMessage = false
                            navigateToGender = true
                        }
                    }
                }) {
                    Text("Join")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(red: 0.01, green: 0.33, blue: 0.18))
                        .cornerRadius(12)
                }


                HStack {
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                    Text("Or")
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                }

                HStack(spacing: 20) {
                    // Placeholder for Google/Facebook auth buttons
                }

                Spacer()
            }
            .padding()
        }.navigationViewStyle(StackNavigationViewStyle())
            .preferredColorScheme(.light)
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                .onTapGesture {
                    configuration.isOn.toggle()
                }

            configuration.label
        }
    }
}
