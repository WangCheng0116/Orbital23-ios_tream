// ExpenseSummaryView.swift
import SwiftUI

struct ExpenseSummaryView: View {
    @EnvironmentObject var expenseList: ExpenseList
    
    var body: some View {
        NavigationView {
            VStack {
                if !expenseList.expenses.isEmpty {
                    BarChart(data: createChartData(), categories: createCategories())
                        .padding()
                        .frame(height: 300)
                    
                    List {
                        ForEach(expenseList.expenses.sorted(by: { $0.date > $1.date })) { expense in
                            VStack(alignment: .leading) {
                                Text(expense.title)
                                    .font(.headline)
                                Text("Amount: \(expense.amount)")
                                Text("Category: \(expense.category)")
                                Text("Date: \(expense.date, formatter: dateFormatter)")
                            }
                        }
                    }
                } else {
                    Text("No expenses yet.")
                        .foregroundColor(.gray)
                }
            }
          
        }
    }
    
    func createChartData() -> [CGFloat] {
        // Group expenses by category and calculate the total amount for each category
        let groupedExpenses = Dictionary(grouping: expenseList.expenses, by: { $0.category })
        let categoryTotalAmounts = groupedExpenses.mapValues { $0.reduce(0) { $0 + CGFloat($1.amount) } }
        
        // Extract the total amounts and sort them by category
        let sortedTotalAmounts = categoryTotalAmounts.sorted { $0.key < $1.key }
        return sortedTotalAmounts.map { CGFloat($0.value) }
    }
    
    func createCategories() -> [String] {
        // Group expenses by category and extract the unique categories
        let groupedExpenses = Dictionary(grouping: expenseList.expenses, by: { $0.category })
        return Array(groupedExpenses.keys).sorted()
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

