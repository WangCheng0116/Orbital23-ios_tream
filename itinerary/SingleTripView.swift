//This is the template of every trip thay users could see on the main screen

import SwiftUI

struct SingleTripView: View {
    var title: String
    var destination: String
    var description: String
    var imageName: String
    var date: String
    var price: Double
    
    var body: some View {
        VStack(spacing: 0) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxHeight: 250)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0)]),
                        startPoint: .bottom,
                        endPoint: .center
                    )
                )
                .overlay(
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(20)
                        .padding(16),
                    alignment: .bottomLeading
                )
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(destination)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
                
                Text(description)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .padding(.top, 8)
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    
                    Text(date)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.green)
                    
                    Text(String(format: "$%.2f", price))
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.gray.opacity(0.1))
    }
}

struct SingleTripView_Previews: PreviewProvider {
    static var previews: some View {
        SingleTripView(title: "Exploring the Beach",
                       destination: "Bali, Indonesia",
                       description: "Enjoy the sunny beaches and explore the rich Balinese culture.",
                       imageName: "bali",
                       date: "June 10 - June 20, 2023",
                       price: 1999.99)
    }
}
