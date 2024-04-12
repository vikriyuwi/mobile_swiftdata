//
//  SwiftDataLearningApp.swift
//  SwiftDataLearning
//
//  Created by win win on 12/04/24.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataLearningApp: App {
    
    let myContainer: ModelContainer = {
        let schema = Schema([Expense.self])
        let container = try! ModelContainer(for: schema, configurations: [])
        
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(myContainer)
//        .modelContainer(for: [Expense.self])
    }
}
