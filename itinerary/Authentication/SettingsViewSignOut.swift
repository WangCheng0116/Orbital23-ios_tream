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
    
    
    
}


struct SettingsViewSignOut: View {
   
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @State private var isPasswordSheetPresented = false
    @State private var isEmailSheetPresented = false
    
    let currencies = ["USD", "EUR", "GBP", "JPY", "CNY", "SGD"]
    @State private var selectedCurrency = "USD"
    @State private var isFeedbackPresented = false
    @State private var feedbackText = ""
    @State private var newPassword = ""
    @State private var newEmail = ""
    @State private var userEmail: String = ""
    
    var body: some View {
        
        List {
//            let user = try! AuthenticationManager.shared.getAuthenticatedUser()
//            if let email = user.email  {
//                Text("You are Signed in as: \(email)")
//
//            } else {
//                Text("error")
//            }
            Button("Show email") {
                let authUser = try! AuthenticationManager.shared.getAuthenticatedUser()
                userEmail = authUser.email ?? "No Email"
                print("\(userEmail)")
            }

            Text("You are Signed in as: \(userEmail)")
            
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                        userEmail = ""
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
                    isEmailSheetPresented = true
                }
                Button("Change Password") {
                    isPasswordSheetPresented = true
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
        .sheet(isPresented: $isPasswordSheetPresented, onDismiss: {
            newPassword = ""
        }) {
            passwordSheet
        }
        .sheet(isPresented: $isEmailSheetPresented, onDismiss: {
            newEmail = ""
        }) {
            emailSheet
        }
    }
    
    
    private var feedbackSheet: some View {
        VStack {
            Text("Send Feedback")
                .font(.headline)
                .padding()
            TextField("Enter your feedback", text: $feedbackText)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
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
    
    private var passwordSheet: some View {
            VStack {
                Text("Change Password")
                    .font(.headline)
                    .padding()

                SecureField("Enter new password", text: $newPassword)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                    

                HStack {
                    Spacer()
                    Button("Cancel") {
                        isPasswordSheetPresented.toggle()
                    }
                    .padding()

                    Button("Update Password") {
                        Task {
                            do {
                                try await updatePassword()
                                print("PASSWORD UPDATED!")
                                isPasswordSheetPresented.toggle()
                            } catch {
                                print(error)
                            }
                        }
                    }
                    .padding()
                }
            }
            .padding()
        }

        // Helper function to handle password update
        private func updatePassword() async throws {
            guard let email = try? AuthenticationManager.shared.getAuthenticatedUser().email,
                  !newPassword.isEmpty else {
                throw URLError(.fileDoesNotExist)
            }

            try await AuthenticationManager.shared.updatePassword(email: email, password: newPassword)
        }
    
    private var emailSheet: some View {
            VStack {
                Text("Update Email")
                    .font(.headline)
                    .padding()

                TextField("Enter new email", text: $newEmail)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                    

                HStack {
                    Spacer()
                    Button("Cancel") {
                        isEmailSheetPresented.toggle()
                    }
                    .padding()

                    Button("Update Email") {
                        Task {
                            do {
                                try await updateEmail()
                                print("PASSWORD UPDATED!")
                                isEmailSheetPresented.toggle()
                            } catch {
                                print(error)
                            }
                        }
                    }
                    .padding()
                }
            }
            .padding()
        }

        // Helper function to handle password update
        private func updateEmail() async throws {
            guard let email = try? AuthenticationManager.shared.getAuthenticatedUser().email else {
                throw URLError(.fileDoesNotExist)
            }

            try await AuthenticationManager.shared.updateEmail(email: newEmail)
        }
}

struct SettingsViewSignOut_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsViewSignOut(showSignInView: .constant(false))
        }
    }
}
