//
//  ContentView.swift
//  SwiftDataLearning
//
//  Created by win win on 12/04/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // access to model context in container
    @Environment(\.modelContext) var context
    
    @State private var isShowingItemSheet = false
    
    // fetch item data
    @Query(sort: \Expense.date)  var expenses: [Expense] = []
    // @Query(filter: #Predicate<Expense> {$0.value > 1000}, sort: \Expense.date) var expenses: [Expense] = []
    @State private var expenseToEdit: Expense?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses) {expense in
                    ExpenseCell(expense: expense)
                        .onTapGesture {
                            expenseToEdit = expense
                        }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        context.delete(expenses[index])
                    }
                })
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) { AddExpenseSheet() }
            .sheet(item: $expenseToEdit) {expense in
                UpdateExpenseSheet(expense: expense)
            }
            .toolbar {
                if !expenses.isEmpty {
                    Button("Add expense", systemImage: "plus"){
                        isShowingItemSheet = true
                    }
                }
            }
            .overlay {
                if expenses.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No expense", systemImage: "list.bullet.rectangle.portrait")
                    }, description: {
                        Text("Start adding expense to see your list")
                    }, actions: {
                        Button("Add expense") {isShowingItemSheet = true}
                    })
                    .offset(y: -60)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

struct ExpenseCell: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            Text(expense.date, format: .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
            Text(expense.name)
            Spacer()
            Text(expense.value, format: .currency(code: "USD"))
        }
    }
}

struct AddExpenseSheet: View {
    // access to model context in container
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name:String = ""
    @State private var date:Date = .now
    @State private var value:Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value: $value, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {dismiss()}
                }
                if isFormComplete() {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button("Save") {
                            // create expense object
                            let expense = Expense(name: name, date: date, value: value)
                            // insert to container
                            context.insert(expense)
                            
    //                        try! context.save()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    func isFormComplete() -> Bool {
        name != "" && value != 0
    }
}

struct UpdateExpenseSheet: View {
    // access to model context in container
    @Environment(\.modelContext) var context
    
    @Environment(\.dismiss) private var dismiss
    @Bindable var expense:Expense
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense name", text: $expense.name)
                DatePicker("Date", selection: $expense.date, displayedComponents: .date)
                TextField("Value", value: $expense.value, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Update expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
