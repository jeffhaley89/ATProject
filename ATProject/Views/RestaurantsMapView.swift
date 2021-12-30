//
//  RestaurantsMapView.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/15/21.
//

import MapKit

class RestaurantsMapView: MKMapView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with content: [RestaurantInfoView.Content]) {
        removeAnnotations(annotations)
        addAnnotations(content.compactMap { $0.annotation })
        showAnnotations(annotations, animated: true)
    }
}
