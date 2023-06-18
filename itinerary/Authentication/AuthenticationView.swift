//
//  AuthenticationView.swift
//  itinerary
//
//  Created by yuchenbo on 3/6/23.
//

import SwiftUI

struct AuthenticationView: View {
    
    @Binding var showSignInView: Bool
    
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
                
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    
                
//                NavigationLink {
//                    //SignInEmailView(showSignInView: $showSignInView)
//                    SignUpView( showSignUpView: $showSignUpView)
//                } label: {
//                    Text("Sign Up With Email")
//                        .font(.headline)
//                        .foregroundColor(Color.white)
//                        .frame(height: 55)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView)
                } label: {
                    Text("Sign In with Email")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
            }
            
            .padding()

        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(false))
        }
    }
}
