//
//  ContentView.swift
//  ArcGIS Maps SDK for Swift
//
//  Created by Fabricio Bezerra local on 2/7/23.
//

import SwiftUI
import ArcGIS
import ArcGISToolkit


struct ContentView: View {
    var body: some View {
            VStack {
                MapContentView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
