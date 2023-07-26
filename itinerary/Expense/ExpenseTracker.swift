// ContentView.swift
import SwiftUI

struct ExpenseView: View {
    @ObservedObject private var expenseList = ExpenseList()
    @State private var isPresentingAddExpense = false
    @State private var selectedCategoryFilter = "All" // Add selectedCategoryFilter

    let categories = ["All", "Food", "Transportation", "Entertainment", "Utilities", "Others"]

    // Dictionary of cute emojis for each category
    let categoryEmojis = [
        "All": "💲",
        "Food": "🍔",
        "Transportation": "🚕",
        "Entertainment": "♠️",
        "Utilities": "🛠️",
        "Others": "❓"
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)

                VStack(spacing: 16) {
                    VStack {
                        ExpenseSummaryView()
                            .environmentObject(expenseList)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(radius: 5)

                        if expenseList.expenses.isEmpty {
                            Text("No expenses yet.")
                                .foregroundColor(.gray)
                        }
                    }

                    Picker("Filter by Category", selection: $selectedCategoryFilter) {
                        ForEach(categories, id: \.self) { category in
                            Text(categoryEmojis[category] ?? "") // Display cute emoji for each category
                                .font(.largeTitle)
                                .tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    ScrollView {
                        ForEach(filteredExpenses) { expense in
                            ExpenseRowView(expense: expense)
                                .padding(.horizontal)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                        }
                    }
                }
                .padding()
                .navigationBarTitle("Expense Tracker", displayMode: .inline)

                VStack {
                    Spacer()
                    Button(action: {
                        isPresentingAddExpense.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 16)
                }
                .sheet(isPresented: $isPresentingAddExpense) {
                    AddExpenseView()
                        .environmentObject(expenseList) // Pass ExpenseList as an environment object here
                }
            }
        }
    }

    private var filteredExpenses: [Expense] {
        if selectedCategoryFilter == "All" {
            return expenseList.expenses
        } else {
            return expenseList.expenses.filter { $0.category == selectedCategoryFilter }
        }
    }
}



struct ExpenseRowView: View {
    let expense: Expense

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            if let emoji = expense.emoji {
                Text(emoji) // Display selected emoji
                    .font(.largeTitle)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.headline)

                HStack {
                    Text("Amount: $\(expense.amount, specifier: "%.2f")")
                    Spacer()
                    Text("\(expense.category)")
                }

                Text("Date: \(expense.date, formatter: dateFormatter)")
                    .foregroundColor(.black)
            }
        }
        .padding(8)
        .cornerRadius(8)
        .shadow(radius: 5)
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

