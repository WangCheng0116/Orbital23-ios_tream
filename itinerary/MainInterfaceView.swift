//implementation of the main interface

import SwiftUI

struct MainInterfaceView: View {
    @State var isSettingsPresented: Bool = false
    @State var isAddingPresented: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    SingleTripView(title: "Exploring the Beach",
                        destination: "Bali, Indonesia",
                        description: "Enjoy the sunny beaches and explore the rich Balinese culture.",
                        imageName: "bali",
                        date: "June 10 - June 20, 2023",
                        price: 2000.00)
                    
                    SingleTripView(title: "Exploring the Beach",
                        destination: "Bali, Indonesia",
                        description: "Enjoy the sunny beaches and explore the rich Balinese culture.",
                        imageName: "bali",
                        date: "June 10 - June 20, 2023",
                        price: 2000.00)
                    
                    SingleTripView(title: "Exploring the Beach",
                        destination: "Bali, Indonesia",
                        description: "Enjoy the sunny beaches and explore the rich Balinese culture.",
                        imageName: "bali",
                        date: "June 10 - June 20, 2023",
                        price: 2000.00)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listStyle(.plain)
            }
            .navigationBarTitle("Your Trips")
            .font(.headline)
            .toolbar {
                //button for directing to settins
                ToolbarItem (placement: .navigationBarTrailing){
                    Button {
                        isSettingsPresented.toggle()
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(Color.orange)
                            .frame(width: 25, height: 25)
                            .offset(y: 15)
                    }
                }
                
                //button for directing to adding trips
                ToolbarItem (placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingPresented.toggle()
                    }) {
                        Image(systemName: "plus")
                            .frame(width: 25, height: 25)
                            .offset(y: 15)
                            .foregroundColor(Color.orange)
                    }
                }
            }
            .sheet(isPresented: $isSettingsPresented) {
                            SettingsView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct MainInterfaceView_Previews: PreviewProvider {
    static var previews: some View {
        MainInterfaceView()
    }
}
