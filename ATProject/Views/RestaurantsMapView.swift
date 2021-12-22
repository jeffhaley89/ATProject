//
//  RestaurantsMapView.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/15/21.
//

import MapKit

class RestaurantsMapView: MKMapView {
    struct Content {
        let annotations: [MKPointAnnotation?]
    }

    let selectedRestaurantInfoView: RestaurantInfoView

    override init(frame: CGRect) {
        selectedRestaurantInfoView = {
            let view = RestaurantInfoView()
            view.isHidden = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        constructSubviewHierarchy()
        constructSubviewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constructSubviewHierarchy() {
        addSubview(selectedRestaurantInfoView)
    }
    
    func constructSubviewConstraints() {
        NSLayoutConstraint.activate([
            selectedRestaurantInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectedRestaurantInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectedRestaurantInfoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func populate(with content: Content) {
        addAnnotations(content.annotations.compactMap { $0 } )
        showAnnotations(annotations, animated: true)
    }
}
