//
//  SelmaKitWrapperApp.swift
//  SelmaKitWrapper
//
//  Created by Andy Giefer on 15.06.23.
//

import SwiftUI

@main
struct SelmaKitWrapperApp: App {
    var body: some Scene {
        WindowGroup {
            //HWSView()
            ContentView()
                .frame(minWidth: 800, minHeight: 600)
        }
        
        Settings {
            SettingsView()
        }
    }
}
