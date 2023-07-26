//
//  Temp.swift
//  itinerary
//
//  Created by yuchenbo on 24/6/23.
//

import SwiftUI

struct Temp: View {
    var body: some View {
       
        
        CreateTripView()
            .environmentObject(TripManager())
    }
}

struct Temp_Previews: PreviewProvider {
    static var previews: some View {
        Temp()
    }
}
