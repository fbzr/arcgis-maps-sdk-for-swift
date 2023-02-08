//
//  ArcGIS_Maps_SDK_for_SwiftApp.swift
//  ArcGIS Maps SDK for Swift
//
//  Created by Fabricio Bezerra local on 2/7/23.
//

import SwiftUI
import ArcGIS

@main
struct MainApp: App {
    init() {
        if let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String {
            ArcGISEnvironment.apiKey = APIKey(apiKey)
        } else {
            print("NO API_KEY FOUND")
        }
    }
    
    var body: some SwiftUI.Scene {
            WindowGroup {
                ContentView()

                    .ignoresSafeArea()

            }
        }
}
