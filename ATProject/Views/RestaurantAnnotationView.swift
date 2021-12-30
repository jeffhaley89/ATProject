//
//  RestaurantAnnotationView.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/28/21.
//

import MapKit

class RestaurantAnnotationView: MKAnnotationView {
    let restaurantInfoView = RestaurantInfoView(viewState: .mapView)
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
        detailCalloutAccessoryView = restaurantInfoView
        image = UIImage(image: .mapPinGray)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
