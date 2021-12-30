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
    
    init(isOpen: Bool) {
        self = isOpen ? .open : .closed
    }
    
    func textColor() -> UIColor {
        self == .open ? .allTrailsGreen : .red
    }
}

enum HeartState {
    case filled
    case empty
    
    mutating func toggle() {
        self = self == .filled ? .empty : .filled
    }

    func image() -> UIImage? {
        UIImage(image: self == .filled ? .filledHeart : .emptyHeart)
    }
}

class RestaurantInfoView: UIView {
    struct Content {
        let name: String?
        let ratingImage: UIImage?
        let totalRatings: String?
        let priceLevel: String?
        let openClosed: OpenClosed?
        let restaurantPhotos: [Photo]?
        var heartState: HeartState
        let placeID: String?
        let annotation: MKPointAnnotation?
    }

    let containerView: UIView
    let restaurantImageView: PlacePhotoImageView
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

    init(viewState: RestaurantViewState) {
        containerView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        restaurantImageView = {
            let imageView = PlacePhotoImageView()
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
            button.setImage(UIImage(image: .emptyHeart), for: .normal)
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
            button.imageView?.contentMode = .scaleAspectFit
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        rowTwoStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
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
        
        super.init(frame: .zero)
        constructSubviewHierarchy()
        constructSubviewConstraints()
        configureView(with: viewState)
        favoriteButton.addTarget(self, action: #selector(didTapHeartImage), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constructSubviewHierarchy() {
        containerView.addSubview(restaurantImageView)
        rowOneStackView.addArrangedSubview(nameLabel)
        rowOneStackView.addArrangedSubview(favoriteButton)
        rowTwoStackView.addArrangedSubview(ratingImageView)
        rowTwoStackView.addArrangedSubview(totalRatingsLabel)
        rowThreeStackView.addArrangedSubview(priceLevelLabel)
        rowThreeStackView.addArrangedSubview(openClosedLabel)
        infoStackView.addArrangedSubview(rowOneStackView)
        infoStackView.addArrangedSubview(rowTwoStackView)
        infoStackView.addArrangedSubview(rowThreeStackView)
        containerView.addSubview(infoStackView)
        addSubview(containerView)
    }
    
    func constructSubviewConstraints() {
        NSLayoutConstraint.activate([
            restaurantImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            restaurantImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            restaurantImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            restaurantImageView.widthAnchor.constraint(equalTo: restaurantImageView.heightAnchor),
            
            rowOneStackView.leadingAnchor.constraint(equalTo: infoStackView.leadingAnchor),
            rowOneStackView.trailingAnchor.constraint(equalTo: infoStackView.trailingAnchor),
            
            favoriteButton.heightAnchor.constraint(equalToConstant: 22),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),

            ratingImageView.widthAnchor.constraint(equalToConstant: 120),
            
            infoStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            infoStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    func configureView(with viewState: RestaurantViewState) {
        switch viewState {
        case .listView:
            favoriteButton.isHidden = false
            backgroundColor = .white
            layer.borderColor = UIColor.borderGray.cgColor
            layer.borderWidth = 1
            layer.cornerRadius = 8

        case .mapView:
            favoriteButton.isHidden = true
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: viewState == .listView ? 16 : 6),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: viewState == .listView ? 16 : 6),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: viewState == .listView ? -16 : -6),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: viewState == .listView ? -16 : -6),
        ])
    }

    func populate(with content: Content) {
        restaurantImageView.setImage(reference: content.restaurantPhotos?.first?.photoReference)
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

    @objc
    func didTapHeartImage() {
        guard let id = placeID else { return }
        heartState.toggle()
        delegate?.didTapHeartImage(isFavorited: heartState == .filled, placeID: id)
    }
}
