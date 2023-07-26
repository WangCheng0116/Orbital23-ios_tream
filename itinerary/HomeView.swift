//
//  HomeView.swift
//  itinerary
//
//  Created by yuchenbo on 12/7/23.
//

import SwiftUI
import LeanCloud

struct HomeView: View {
    @Binding var showSignInView: Bool
    //let currentUser: LCUser
    
    var body: some View {
        
        
        TabView {
            // First tab
            NavigationView {
                // Your first view
                MainInterfaceView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "suitcase.fill")
                Text("Trips")
            }
            
            // Second tab
            NavigationView {
                // Your second view
                AddingView()
            }
            .tabItem {
                Image(systemName: "list.bullet.clipboard")
                Text("Activities")
            }
            
            // Third tab
            NavigationView {
                ExpenseView()
            }
            .tabItem {
                Image(systemName: "dollarsign.circle")
                Text("Expenses")
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

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(showSignInView: .constant(false), currentUser: <#LCUser#>)
//    }
//}
