import SwiftUI

struct AddExpenseView: View {
    @State private var title = ""
    @State private var amount = ""
    @State private var selectedCategory = "Food"
    @State private var date = Date()
    @State private var selectedEmoji: String?
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var expenseList: ExpenseList

    let categories = ["Food", "Transportation", "Entertainment", "Utilities", "Others"]
   

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Description", text: $title)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }

                    DatePicker("Date", selection: $date, displayedComponents: .date)

                    
                }

                Button(action: addExpense) {
                    Text("Add Expense")
                }
            }
        }
    }

    func addExpense() {
        guard let amountValue = Double(amount) else {
            return
        }
        let expense = Expense(title: title, amount: amountValue, category: selectedCategory, date: date, emoji: selectedEmoji)
        expenseList.addExpense(expense)
        title = ""
        amount = ""
        selectedCategory = categories.first ?? "Food"
        date = Date()
        selectedEmoji = nil
        presentationMode.wrappedValue.dismiss()
    }
}

