//
//  RestaurantInfoView.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/15/21.
//

import MapKit

protocol RestaurantInfoViewDelegate: AnyObject {
    func didTapHeartImage(isFavorited: Bool, placeID: String)
}

enum OpenClosed: String {
    case open = "OPEN"
    case closed = "CLOSED"
    
    init?(isOpen: Bool) {
        self = isOpen ? .open : .closed
    }
    
    func textColor() -> UIColor {
        self == .open ? UIColor(red: 0.259, green: 0.541, blue: 0.075, alpha: 1) : .red
    }
}

enum HeartState {
    case filled
    case empty
    
    mutating func toggle() {
        self = self == .filled ? .empty : .filled
    }

    func image() -> UIImage? {
        UIImage(named: self == .filled ? "FilledHeart" : "EmptyHeart")
    }
}

class RestaurantInfoView: UIView {
    struct Content {
        
//        let geometry: Geometry?
//        let name: String?
//        let openingHours: OpeningHours?
//        let photos: [Photo]?
//    //    let placeID: String
//        let priceLevel: Int? // $$$
//        let rating: Double? // 1 to 5
//        let userRatingsTotal: Int?
        
        
        let name: String?
        let ratingImage: UIImage?
        let totalRatings: String?
        let priceLevel: String?
        let openClosed: OpenClosed?
        let restaurantImage: UIImage?
        var heartState: HeartState
        let placeID: String?
        let annotation: MKPointAnnotation?
    }

    let restaurantImageView: UIImageView
    let infoStackView: UIStackView
    let rowOneStackView: UIStackView
    let nameLabel: UILabel
    let favoriteButton: UIButton
    let rowTwoStackView: UIStackView
    let ratingImageView: UIImageView
    let totalRatingsLabel: UILabel
    let rowThreeStackView: UIStackView
    let priceLevelLabel: UILabel
    let openClosedLabel: UILabel
    var placeID: String?
    weak var delegate: RestaurantInfoViewDelegate?

    var heartState: HeartState = .empty {
        didSet {
            favoriteButton.setImage(heartState.image(), for: .normal)
        }
    }

    override init(frame: CGRect) {
        restaurantImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        infoStackView = {
            let stackView = UIStackView()
            stackView.alignment = .leading
            stackView.axis = .vertical
            stackView.distribution = .fillProportionally
            stackView.spacing = 4
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        rowOneStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.spacing = 0
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()

        nameLabel = {
            let label = UILabel()
            label.font = .aerialRoundedMTBold(16)
            label.textColor = .darkGray
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
                
        favoriteButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "emptyHeart"), for: .normal)
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
            button.imageView?.contentMode = .scaleAspectFit
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        rowTwoStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
//            stackView.distribution = .fillProportionally
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()

        ratingImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        totalRatingsLabel = {
            let label = UILabel()
            label.font = .aerialMT(12)
            label.textColor = .lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        rowThreeStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.spacing = 4
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()

        priceLevelLabel = {
            let label = UILabel()
            label.font = .aerialMT(14)
            label.textColor = .lightGray
            label.setContentHuggingPriority(.required, for: .horizontal)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        openClosedLabel = {
            let label = UILabel()
            label.font = .aerialMT(12)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        super.init(frame: frame)
        backgroundColor = .white
        layer.borderColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        constructSubviewHierarchy()
        constructSubviewConstraints()
        favoriteButton.addTarget(self, action: #selector(didTapHeartImage), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constructSubviewHierarchy() {
        addSubview(restaurantImageView)
        rowOneStackView.addArrangedSubview(nameLabel)
        rowOneStackView.addArrangedSubview(favoriteButton)
        rowTwoStackView.addArrangedSubview(ratingImageView)
        rowTwoStackView.addArrangedSubview(totalRatingsLabel)
        rowThreeStackView.addArrangedSubview(priceLevelLabel)
        rowThreeStackView.addArrangedSubview(openClosedLabel)
        infoStackView.addArrangedSubview(rowOneStackView)
        infoStackView.addArrangedSubview(rowTwoStackView)
        infoStackView.addArrangedSubview(rowThreeStackView)
        addSubview(infoStackView)
    }
    
    func constructSubviewConstraints() {
        NSLayoutConstraint.activate([
            restaurantImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            restaurantImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            restaurantImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            restaurantImageView.widthAnchor.constraint(equalTo: restaurantImageView.heightAnchor),
            
            rowOneStackView.leadingAnchor.constraint(equalTo: infoStackView.leadingAnchor),
            rowOneStackView.trailingAnchor.constraint(equalTo: infoStackView.trailingAnchor),
            
            favoriteButton.heightAnchor.constraint(equalToConstant: 22),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),

            ratingImageView.widthAnchor.constraint(equalToConstant: 120),
            
            infoStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            infoStackView.leadingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
    func populate(with content: Content) {
        restaurantImageView.image = content.restaurantImage
        nameLabel.text = content.name
        heartState = content.heartState
        ratingImageView.image = content.ratingImage
        totalRatingsLabel.text = content.totalRatings
        priceLevelLabel.text = content.priceLevel
        setOpenClosedLabel(state: content.openClosed)
        placeID = content.placeID
    }
    
    func setOpenClosedLabel(state: OpenClosed?) {
        guard let state = state else { return }
        openClosedLabel.text = state.rawValue
        openClosedLabel.textColor = state.textColor()
    }
    
    func toggleViewState(state: RestaurantViewState) {
        switch state {
        case .listView:
            favoriteButton.isHidden = false

        case .mapView:
            favoriteButton.isHidden = true
        }
    }
    
    @objc
    func didTapHeartImage() {
        guard let id = placeID else { return } // TODO: modify placeID to non optional?
        heartState.toggle()
        delegate?.didTapHeartImage(isFavorited: heartState == .filled, placeID: id)
    }
}
