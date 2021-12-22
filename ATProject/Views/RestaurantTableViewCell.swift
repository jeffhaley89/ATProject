//
//  RestaurantTableViewCell.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/16/21.
//

import MapKit

class RestaurantTableViewCell: UITableViewCell {
    let restaurantInfoView: RestaurantInfoView

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        restaurantInfoView = {
            let view = RestaurantInfoView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        constructSubviewHierarchy()
        constructSubviewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constructSubviewHierarchy() {
        contentView.addSubview(restaurantInfoView)
    }
    
    func constructSubviewConstraints() {
        NSLayoutConstraint.activate([
            restaurantInfoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            restaurantInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            restaurantInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            restaurantInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
}
