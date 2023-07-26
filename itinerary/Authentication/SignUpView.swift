//
//  SignInNewAccountView.swift
//  itinerary
//
//  Created by yuchenbo on 28/6/23.
//

import SwiftUI



struct SignUpView: View {
    
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
                
                Text("Sign Up With Email")
                    .font(.title)
                    .bold()
                
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
                            try await viewModel.SignUp()
                            showSignInView = false
                            return
                        } catch {
                            print("reached signUp")
                            showAlert = true
                        }
                        
                    }
                }, label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                
               
            }
            .padding()
            //.navigationTitle("Sign Up With Email")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Account Already Exist!"),
                      message: Text("Please login to your existing account."),
                      dismissButton: .default(Text("OK")))
            }
            
        }
    }
}

//struct SignUp_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            SignUpView(showSignInView: .constant(false))
//        }
//    }
//}
