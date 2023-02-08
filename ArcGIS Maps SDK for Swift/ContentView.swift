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
    
    
    @StateObject private var map: Map = {
    // EXAMPLE of popup fetched from Portal
//            let portalItem = PortalItem(
//                    portal: .arcGISOnline(connection: .anonymous),
//                    id: Item.ID(rawValue: "9f3a674e998f461580006e626611f9ad")!
//                )
//                return Map(item: portalItem)
        
        let map = Map(basemapStyle: .arcGISTopographic)
        map.initialViewpoint = Viewpoint(latitude: 39.90373709732449, longitude: -75.35271102362825, scale: 16_000)

        let featureServiceURL = URL(string: "https://silva.swarthmore.edu/server/rest/services/Plant_Centers/MapServer/0")!
        let serviceFeatureTable = ServiceFeatureTable(url: featureServiceURL)
        let plantsLayer = FeatureLayer(featureTable: serviceFeatureTable)
        plantsLayer.popupsAreEnabled = true
        
        let popupFieldAccessionNumber = PopupField()
        popupFieldAccessionNumber.fieldName = "ACC_NUM_AND_QUAL"
        popupFieldAccessionNumber.label = "Accession Number"
        
        let popupFieldFamily = PopupField()
        popupFieldFamily.fieldName = "FAMILY_MC"
        popupFieldFamily.label = "Family"
        
        let popupFieldCommonName = PopupField()
        popupFieldCommonName.fieldName = "COMMON_NAME_PRIMARY"
        popupFieldCommonName.label = "Common Name"

        let popupDef = PopupDefinition()
        popupDef.title = "{NAME}"
        let fieldPopupElement = FieldsPopupElement()
        fieldPopupElement.addFields([popupFieldAccessionNumber,popupFieldCommonName,popupFieldFamily])
        fieldPopupElement.title = "Plant Details"
        
        popupDef.addElement(fieldPopupElement)
        
        plantsLayer.popupDefinition = popupDef
    
        map.addOperationalLayer(plantsLayer)

        return map
    }()
    
    /// The point on the screen the user tapped on to identify a feature.
    @State private var identifyScreenPoint: CGPoint?
    
    /// The popup to be shown as the result of the layer identify operation.
    @State private var popup: Popup?
    
    /// A Boolean value specifying whether the popup view should be shown or not.
    @State private var showPopup = true
    
    /// The detent value specifying the initial `FloatingPanelDetent`.  Defaults to "full".
    @State private var floatingPanelDetent: FloatingPanelDetent = .full

    
    var body: some View {
        MapViewReader { proxy in
            VStack {
                MapView(map: map)
                    .onSingleTapGesture { screenPoint, _ in
                        identifyScreenPoint = screenPoint
                    }
                    .task(id: identifyScreenPoint) {
                        guard let identifyScreenPoint = identifyScreenPoint,
                              let identifyResult = await Result(awaiting: {
                                  try await proxy.identifyLayers(
                                    screenPoint: identifyScreenPoint,
                                    tolerance: 10,
                                    returnPopupsOnly: true
                                  )
                              })
                            .cancellationToNil()
                        else {
                            return
                        }
                        self.identifyScreenPoint = nil
                        self.popup = try? identifyResult.get().first?.popups.first
                        self.showPopup = self.popup != nil
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
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
