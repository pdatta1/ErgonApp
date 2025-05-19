//
//  ErgonApp.swift
//  Ergon
//
//  Created by Patrick ATTA-BAAH on 4/30/25.
//

import SwiftUI

@main
struct ErgonApp: App {
    
    @StateObject private var viewModel = TodoItemViewModel()
    
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewModel)
        }
    }
}
