//
//  AuthenticationView.swift
//  itinerary
//
//  Created by yuchenbo on 3/6/23.
//

import SwiftUI

struct AuthenticationView: View {
    
    @Binding var showSignInView: Bool
    //@Binding var showSignInEAView: Bool
    
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
                    
                
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView)
                } label: {
                    Text("Sign In With Email")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
//                NavigationLink {
//                    SignInExistingAccountView( showSignInEAView: $showSignInEAView)
//                } label: {
//                    Text("Sign In to Existing Account")
//                        .font(.headline)
//                        .foregroundColor(Color.white)
//                        .frame(height: 55)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
                
            }
            
            .padding()

        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(false)
            )
        }
    }
}
