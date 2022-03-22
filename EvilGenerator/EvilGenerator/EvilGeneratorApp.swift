//
//  EvilGeneratorApp.swift
//  EvilGenerator
//
//  Created by Майлс on 16.03.2022.
//

import SwiftUI

@main
struct EvilGeneratorApp: App {
    
    @StateObject private var evilInsult = EvilGenVM()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Home()
                    .environmentObject(evilInsult)
            }
        }
    }
}
