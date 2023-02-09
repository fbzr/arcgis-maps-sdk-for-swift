//
//  Map.util.swift
//  ArcGIS Maps SDK for Swift
//
//  Created by Fabricio Bezerra local on 2/9/23.
//

import Foundation
import ArcGIS

func createLayers() -> [Layer] {
    var layers: [Layer] = [];
    
//    let buildingsServiceURL = URL(string: "https://silva.swarthmore.edu/server/rest/services/Buildings/MapServer/0")!
//    let buildingsServiceFeatureTable = ServiceFeatureTable(url: buildingsServiceURL)
//    let buildingsLayer = FeatureLayer(featureTable: buildingsServiceFeatureTable)
//    layers.append(buildingsLayer)
    
    let featureServiceURL = URL(string: "https://silva.swarthmore.edu/server/rest/services/Plant_Centers/MapServer/0")!
    let serviceFeatureTable = ServiceFeatureTable(url: featureServiceURL)
    let plantsLayer = FeatureLayer(featureTable: serviceFeatureTable)
    plantsLayer.popupsAreEnabled = true
    
    // POPUP FIELDS
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
    
    layers.append(plantsLayer)
    
    return layers;
}

func createMap() -> Map {
    let map = Map(basemapStyle: .arcGISTopographic)
    map.initialViewpoint = Viewpoint(latitude: 39.90373709732449, longitude: -75.35271102362825, scale: 16_000)

    return map
}
