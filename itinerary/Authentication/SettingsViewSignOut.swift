//
//  SettingsViewSignOut.swift
//  itinerary
//
//  Created by yuchenbo on 5/6/23.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {

    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    
    func updateEmail() async throws {
        let email = "hello123@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
}


struct SettingsViewSignOut: View {
   
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    
    let currencies = ["USD", "EUR", "GBP", "JPY", "CNY", "SGD"]
    @State private var selectedCurrency = "USD"
    @State private var isFeedbackPresented = false
    @State private var feedbackText = ""
    
    
    
    var body: some View {
        
        List {
            
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            .foregroundColor(.red)
            
            Section {
                Button("Reset Password") {
                    Task {
                        do {
                            try await viewModel.resetPassword()
                            print("PASSWORD RESET!")
                        } catch {
                            print(error)
                        }
                    }
                }
                
                Button("Update Email") {
                    Task {
                        do {
                            try await viewModel.updateEmail()
                            print("EMAIL UPDATED!")
                        } catch {
                            print(error)
                        }
                    }
                }
            } header: {
                Text("Account management")
            }
            
            
            Section(header: Text("PREFERENCES")) {
                HStack{
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(Color.orange)
                    
                    Picker(selection: $selectedCurrency, label: Text("Change Currency")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency)
                        }
                    }
                }
                
            }
            
            Section(header: Text("FEEDBACK")) {
                Button(action: {
                    isFeedbackPresented.toggle()
                }) {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.orange)
                            .frame(width: 30, height: 30)
                        Text("Send Feedback")
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                    }
                }
            }
        
            
            
            
   
        }
        .navigationTitle("Settings")
        .sheet(isPresented: $isFeedbackPresented) {
            feedbackSheet
        }
    }
    
    
    private var feedbackSheet: some View {
        VStack {
            Text("Send Feedback")
                .font(.headline)
                .padding()
            TextField("Enter your feedback", text: $feedbackText)
                .padding()
            HStack {
                Spacer()
                Button("Cancel") {
                    isFeedbackPresented.toggle()
                }
                .padding()
                Button("Submit") {
                    // submit feedback
                    isFeedbackPresented.toggle()
                }
                .padding()
            }
        }
    }
}

struct SettingsViewSignOut_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsViewSignOut(showSignInView: .constant(false))
        }
    }
}
