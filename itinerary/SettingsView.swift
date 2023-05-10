//Settings page, which now currently support login, switching currency and submitting feedback, all of them are to be completed

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let currencies = ["USD", "EUR", "GBP", "JPY", "CNY", "SGD"]
    @State private var selectedCurrency = "USD"
    @State private var isFeedbackPresented = false
    @State private var feedbackText = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("ACCOUNT")) {
                    Button(action: {
                        // present login view
                    }) {
                        HStack {
                            Image(systemName: "cloud.fill")
                                .foregroundColor(Color.orange)
                                .frame(width: 30, height: 30)
                            Text("Login")
                                .foregroundColor(Color.black)
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                                
                        }
                                        }
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
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
                    .foregroundColor(Color.orange)
                    .font(.system(size: 20))
                    .offset(y: 15)
            }))
            .sheet(isPresented: $isFeedbackPresented) {
                feedbackSheet
            }
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
