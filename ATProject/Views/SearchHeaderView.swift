//
//  SearchHeaderView.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/16/21.
//

import UIKit

class SearchHeaderView: UIView {
    
    let logoImageView: UIImageView
    let filterButton: UIButton
    let searchBarTextField: UITextField
    
    override init(frame: CGRect) {
        logoImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(image: .atHeaderLogo)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        filterButton = {
            var configuration = UIButton.Configuration.plain()
            var container = AttributeContainer()
            container.font = .aerialMT(12)
            container.foregroundColor = .gray
            configuration.attributedTitle = AttributedString("Filter", attributes: container)
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
            
            let button = UIButton(configuration: configuration, primaryAction: nil)
            button.layer.borderColor = UIColor.borderGray.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 6
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        searchBarTextField = {
            let textField = UITextField()
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search for a restaurant",
                attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
            textField.backgroundColor = .white
            textField.layer.borderColor = UIColor.borderGray.cgColor
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 6
            textField.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            textField.layer.shadowOpacity = 0.1
            textField.layer.shadowRadius = 1.0
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
            textField.leftViewMode = .always
            textField.font = .aerialRoundedMTBold(14)
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }()
        
        super.init(frame: .zero)
        backgroundColor = .white
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 2.0
        translatesAutoresizingMaskIntoConstraints = false
        constructSubviewHierarchy()
        constructSubviewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func constructSubviewHierarchy() {
        addSubview(logoImageView)
        addSubview(filterButton)
        addSubview(searchBarTextField)
    }
    
    func constructSubviewConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.heightAnchor.constraint(equalToConstant: 34),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            filterButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 12),
            filterButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            filterButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
            filterButton.heightAnchor.constraint(equalToConstant: 36),

            searchBarTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 12),
            searchBarTextField.leadingAnchor.constraint(equalTo: filterButton.trailingAnchor, constant: 8),
            searchBarTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            searchBarTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
            searchBarTextField.heightAnchor.constraint(equalTo: filterButton.heightAnchor)
        ])
    }
}
