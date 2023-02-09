//
//  MapContentView.swift
//  ArcGIS Maps SDK for Swift
//
//  Created by Fabricio Bezerra local on 2/8/23.
//

import SwiftUI
import ArcGIS
import ArcGISToolkit

struct MapContentView: View {
    private var layers: [Layer]
    private var map: Map
    
    init() {
        layers = createLayers()
        map = createMap()
        map.addOperationalLayers(layers)
    }
        
    /// The point on the screen the user tapped on to identify a feature.
    @State private var identifyScreenPoint: CGPoint?
    /// The popup to be shown as the result of the layer identify operation.
    @State private var popup: Popup?
    /// A Boolean value specifying whether the popup view should be shown or not.
    @State private var showPopup = false
    /// The detent value specifying the initial `FloatingPanelDetent`.  Defaults to "full".
    @State private var floatingPanelDetent: FloatingPanelDetent = .full
    
    @State var showList = false
    
    /// The selected features.
    @State private var selectedFeatures: [Feature] = []
    
    private var featureLayer: FeatureLayer {
        map.operationalLayers.first as! FeatureLayer
    }
        
    var body: some View {
        MapViewReader { mapViewProxy in
            VStack {
                Button(showList ? "Close Layer List" : "Show Layer List") {
                    self.showList.toggle()
                }.padding(.top, 0)
                MapView(map: map)
                    .onSingleTapGesture { screenPoint, _ in
                        identifyScreenPoint = screenPoint
                    }
                    .task(id: identifyScreenPoint) {
                        guard let identifyScreenPoint = identifyScreenPoint else { return }
                        
                        featureLayer.unselectFeatures(selectedFeatures)
                        
                        let identifyResult = await Result(awaiting: {
                            try await mapViewProxy.identifyLayers(
                              screenPoint: identifyScreenPoint,
                              tolerance: 10,
                              returnPopupsOnly: false,
                              maximumResultsPerLayer: 1
                            )
                            
                        }).cancellationToNil()
                        
                        self.identifyScreenPoint = nil
                        let result = try? identifyResult?.get().first
                        
                        if (result?.geoElements != nil) {
                            let features = result?.geoElements as! [Feature]
                            
                            selectedFeatures = features
                            featureLayer.selectFeatures(features)
                        } else {
                            selectedFeatures = []
                        }
                        
                        self.popup = result?.popups.first
                        self.showPopup = self.popup != nil
                        self.showList = false
                    }
                    .floatingPanel(
                        selectedDetent: $floatingPanelDetent,
                        horizontalAlignment: .leading,
                        isPresented: $showPopup
                    ) {
                        Group {
                            if let popup = popup {
                                PopupView(popup: popup, isPresented: $showPopup)
                                    .showCloseButton(true)
                            }
                        }
                        .padding()
                    }
                    .floatingPanel(isPresented: $showList) {
                        List(map.operationalLayers, id: \.self) { item in
                            Text("\(item.name)")
                        }
                        .listStyle(.plain)
                    }
            }
        }
    }
}

struct MapContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapContentView()
    }
}

