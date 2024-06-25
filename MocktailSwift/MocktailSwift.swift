//
//  MocktailIosTempApp.swift
//  MocktailIosTemp
//
//  Created by Sachin Pandey on 18/06/24.
//

import SwiftUI

@main
struct MocktailIosTempApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
           HomeView()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
