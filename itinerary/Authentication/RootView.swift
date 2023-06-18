//
//  RootView.swift
//  itinerary
//
//  Created by yuchenbo on 5/6/23.
//

import SwiftUI

struct RootView: View {
   
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                MainInterfaceView(showSignInView: $showSignInView)
                //SettingsViewSignOut(showSignInView: $showSignInView)
            }
            
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        
        
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
