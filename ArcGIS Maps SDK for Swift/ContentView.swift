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
    @AppStorage("selectedTabIndex") var selectedTabIndex: Int = -1
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTabIndex) {
                MapContentView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map")
                    }
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                LayerListView()
                    .background(Color.gray.opacity(1))
                    .tabItem {
                        Image(systemName: "list.star")
                        Text("Layer List")
                    }
                    
            }
        }
          
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
    }
}
