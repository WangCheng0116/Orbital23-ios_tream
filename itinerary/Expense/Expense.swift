// Expense.swift
import SwiftUI

struct Expense: Identifiable {
    let id = UUID()
    let title: String
    var amount: Double // Change to a variable
    let category: String
    let date: Date
    var emoji: String? // Change to a variable
}

