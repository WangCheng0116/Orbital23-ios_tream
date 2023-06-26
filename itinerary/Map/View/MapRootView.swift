//
//  MapRootView.swift
//  itinerary
//
//  Created by yuchenbo on 24/6/23.
//

import SwiftUI

struct MapRootView: View {
    var body: some View {
        NavigationView {
            SearchView()
                .navigationBarHidden(true)
        }
    }
}

struct MapRootView_Previews: PreviewProvider {
    static var previews: some View {
        MapRootView()
    }
}
