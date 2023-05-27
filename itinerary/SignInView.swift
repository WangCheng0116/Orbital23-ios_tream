//
//  SignInView.swift
//  itinerary
//
//  Created by 王小程 on 26/5/23.
//

import SwiftUI

struct SignInView: View {
    @State var email = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                VStack {
                    TextField("Email Address", text: $email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    	
                    SecureField("Email Address", text: $email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    
                    Button(action: {
                        
                    }
                           , label: {
                        Text("Sign In")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .cornerRadius(20)
                        .background(Color.blue)
                    })
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Sign In")

        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
