//
//  SignInEmailView.swift
//  itinerary
//
//  Created by yuchenbo on 3/6/23.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    
    func SignUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        //try await AuthenticationManager.shared.createUser(email: email, password: password)
        
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    
    func SignIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
}




struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    @State var showAlert: Bool = false
    
    var body: some View {
        
        ZStack {
            Color.orange
                .ignoresSafeArea()
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            Circle()
                .scale(1.35)
                .foregroundColor(.white)
            
            
            VStack {
               
                Spacer()
                Text("Sign In With Email")
                    .bold()
                    .font(.title)
                
                TextField("Email...", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                SecureField("Password...", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                Button(action: {
                    
                    Task {
                        
                        do {
                            print("reached signIn")
                            try await viewModel.SignIn()
                            showSignInView = false
                            print("completed signIn")
                            return
                        } catch {
                            showAlert = true
                            print(error)
                            
                        }
                        
                    }
                }, label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                
                Spacer()
            }
            .padding()
            //.navigationTitle("Sign In With Email")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Account Doesn't Exist"),
                      message: Text("Please sign up for an account first."),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}
