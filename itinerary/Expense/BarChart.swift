// BarChart.swift
import SwiftUI

struct BarChart: View {
    let data: [CGFloat]
    let categories: [String]

    // Dictionary of cute emojis for each category
    let categoryEmojis = [
        "Food": "🍔",
        "Transportation": "🚕",
        "Entertainment": "🎉",
        "Utilities": "💡",
        "Others": "❓"
    ]

    var body: some View {
        VStack {
            HStack(spacing: 8) {
                ForEach(0..<data.count, id: \.self) { index in
                    VStack {
                        Spacer()
                        ZStack {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 30, height: calculateHeight(index: index))
                            Text("\(calculateTotalExpense(category: categories[index]))")
                                .foregroundColor(.black)
                                .font(.caption)
                                .offset(y: -calculateHeight(index: index) - 20) // Adjust the offset to avoid overlapping
                        }
                        Text(categoryEmojis[categories[index]] ?? "")
                            .rotationEffect(Angle(degrees: 45))
                            .padding(.top, 4)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }

    private func calculateHeight(index: Int) -> CGFloat {
        let maxValue = data.max() ?? 0
        let maxHeight: CGFloat = 150 // You can adjust the maximum height of the bars
        let ratio = data[index] / maxValue
        return maxHeight * ratio
    }

    private func calculateTotalExpense(category: String) -> String {
        let totalExpense = data[categories.firstIndex(of: category) ?? 0]
        return "$\(String(format: "%.2f", totalExpense))"
    }
}
