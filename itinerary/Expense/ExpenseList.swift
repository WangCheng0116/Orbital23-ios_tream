// ExpenseList.swift
import SwiftUI

class ExpenseList: ObservableObject {
    @Published var expenses = [Expense]()
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
    }
}

