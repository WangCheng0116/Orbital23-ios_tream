//
//  HomeView.swift
//  itinerary
//
//  Created by yuchenbo on 12/7/23.
//

import SwiftUI

struct HomeView: View {
    @Binding var showSignInView: Bool
    var body: some View {
        
        
        TabView {
            // First tab
            NavigationView {
                // Your first view
                MainInterfaceView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "1.circle")
                Text("Trips")
            }
            
            // Second tab
            NavigationView {
                // Your second view
                AddingView()
            }
            .tabItem {
                Image(systemName: "2.circle")
                Text("Activities")
            }
            
            // Third tab
            NavigationView {
                // Your third view
                Text("Third View")
                    .navigationTitle("Third")
            }
            .tabItem {
                Image(systemName: "3.circle")
                Text("Third")
            }
            
           
            
            NavigationView {
                // Your third view
                SettingsViewSignOut(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
        }
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showSignInView: .constant(false))
    }
}
