//
//  RestaurantsViewController.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/15/21.
//

import MapKit

class RestaurantsViewController: UIViewController {
    let viewModel: RestaurantsViewModel
    let locationManager = CLLocationManager()
    var rootView: RestaurantsBaseView { view as! RestaurantsBaseView }

    init(viewModel: RestaurantsViewModel = DefaultRestaurantsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        let view = RestaurantsBaseView()
        view.tableView.dataSource = self
        view.tableView.delegate = self
        view.tableView.register(RestaurantTableViewCell.self, forCellReuseIdentifier: "RestaurantTableViewCell")
        view.mapView.delegate = self
        view.mapView.register(RestaurantAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        view.searchHeaderView.searchBarTextField.delegate = self
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        locationManager.delegate = self
        handleLocationAuthorization(status: locationManager.authorizationStatus)
    }
    
    func handleLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .authorizedAlways, .authorizedWhenInUse:
            getRestaurantsViewContent(with: nil)

        case .denied, .restricted:
            displayLocationAlert()
            
        @unknown default:
            return
        }
    }
    
    func getRestaurantsViewContent(with query: String?) {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = rootView.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        viewModel.getRestaurantsViewContent(query: query) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                switch result {
                case .success:
                    self.rootView.tableView.reloadData()
                    self.rootView.mapView.populate(with: self.viewModel.infoViewsContent)

                case let .failure(error):
                    // TODO: display error message accordingly
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension RestaurantsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedRestaurantAnnotation = viewModel.infoViewsContent[indexPath.row].annotation else { return }
        rootView.mapView.selectAnnotation(selectedRestaurantAnnotation, animated: true)
        rootView.viewState = .mapView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.infoViewsContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell") as? RestaurantTableViewCell else {
            return UITableViewCell()
        }

        cell.restaurantInfoView.populate(with: viewModel.infoViewsContent[indexPath.row])
        cell.restaurantInfoView.delegate = self
        return cell
    }
}

extension RestaurantsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        getRestaurantsViewContent(with: textField.text)
        return true
    }
}

extension RestaurantsViewController: RestaurantInfoViewDelegate {
    func didTapHeartImage(isFavorited: Bool, placeID: String) {
        if isFavorited {
            viewModel.saveFavoritedRestaurant(id: placeID)
        } else {
            viewModel.removeFavoritedRestaurant(id: placeID)
        }
    }
}

extension RestaurantsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? RestaurantAnnotationView,
              let content = viewModel.getSelectedRestaurantContent(with: annotation.coordinate)
        else {
            return MKAnnotationView()
        }

        annotationView.restaurantInfoView.populate(with: content)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.image = UIImage(image: .mapPinGreen)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(image: .mapPinGray)
    }
}

extension RestaurantsViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleLocationAuthorization(status: manager.authorizationStatus)
    }
}
