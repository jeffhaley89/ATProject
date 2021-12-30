//
//  RestaurantsListView.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/15/21.
//

import UIKit

class RestaurantsTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(RestaurantTableViewCell.self, forCellReuseIdentifier: "RestaurantTableViewCell")
        backgroundColor = .tableViewGray
        separatorStyle = .none
        translatesAutoresizingMaskIntoConstraints = false
        contentInset = UIEdgeInsets(top: 22, left: 0, bottom: 80, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
