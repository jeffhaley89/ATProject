//
//  RestaurantsContainerView.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/15/21.
//

import UIKit

enum RestaurantViewState {
    case listView
    case mapView
    
    mutating func toggle() {
        self = self == .mapView ? .listView : .mapView
    }
}

class RestaurantsBaseView: UIView {
    
    let searchHeaderView: SearchHeaderView
    let mapListButton: UIButton
    let containerView: UIView
    let tableView: RestaurantsTableView
    let mapView: RestaurantsMapView
    var viewState = RestaurantViewState.listView {
        didSet {
            didSetViewState(state: viewState)
        }
    }
    
    let listToggleImage = UIImage(image: .listToggle)
    let mapToggleImage = UIImage(image: .mapToggle)
    
    override init(frame: CGRect) {
        containerView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        mapListButton = {
            let button = UIButton()
            button.backgroundColor = .allTrailsGreen
            button.clipsToBounds = true
            button.layer.cornerRadius = 8
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        searchHeaderView = SearchHeaderView()
        tableView = RestaurantsTableView()
        mapView = RestaurantsMapView()
        
        super.init(frame: frame)
        backgroundColor = .white
        constructSubviewHierarchy()
        constructSubviewConstraints()
        mapListButton.addTarget(self, action: #selector(didTapMapListButton), for: .touchUpInside)
        showTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constructSubviewHierarchy() {
        containerView.addSubview(mapView)
        containerView.addSubview(tableView)
        addSubview(containerView)
        addSubview(mapListButton)
        addSubview(searchHeaderView)
    }
    
    func constructSubviewConstraints() {
        NSLayoutConstraint.activate([
            searchHeaderView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchHeaderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchHeaderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: searchHeaderView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            mapView.topAnchor.constraint(equalTo: containerView.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            mapListButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            mapListButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            mapListButton.widthAnchor.constraint(equalToConstant: 112),
            mapListButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func didSetViewState(state: RestaurantViewState) {
        switch state {
        case .listView:
            showTableView()

        case .mapView:
            showMapView()
        }
    }
    
    func showTableView() {
        containerView.bringSubviewToFront(tableView)
        mapListButton.setImage(mapToggleImage, for: .normal)
    }
    
    func showMapView() {
        containerView.bringSubviewToFront(mapView)
        mapListButton.setImage(listToggleImage, for: .normal)
    }

    @objc
    func didTapMapListButton() {
        viewState.toggle()
    }
}
